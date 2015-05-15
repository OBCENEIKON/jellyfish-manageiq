require 'spec_helper'

describe Jellyfish::ManageIQ do
  it 'has a version number' do
    expect(Jellyfish::ManageIQ::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end

describe Jellyfish::ManageIQ::Provisioner do
  it 'provisions cloud instances using manage iq' do
    client = build_client
    order_item = build_order_item
    setup_provisioner_spec(client)

    ManageIQ.provision(order_item.id)
    order_item.reload

    expect(client).to have_received(:post)
    expect(order_item.provision_status).to eq 'pending'
    expect(order_item.payload_acknowledgement).to eq('results' => 'good job')
    expect(order_item.payload_request).to be_present
  end

  it 'sets the status to critical when a response between 400 and 407 happens' do
    client = build_client(404)
    order_item = build_order_item
    setup_provisioner_spec(client)

    ManageIQ.provision(order_item.id)
    order_item.reload

    expect(order_item.provision_status).to eq 'critical'
  end

  it 'sets the status to warning when a response other than 200s or 400 to 407 happens' do
    client = build_client(500)
    order_item = build_order_item
    setup_provisioner_spec(client)

    ManageIQ.provision(order_item.id)
    order_item.reload

    expect(order_item.provision_status).to eq 'warning'
  end

  def build_order_item
    create(:order_item, uuid: '61810e22-f212-4429-a1ca-f1aae51904a0', provision_status: :unknown)
  end

  def build_client(response_code = 200)
    post_response = double('response', body: '{"results": "good job"}', code: response_code)
    double('client', post: post_response)
  end

  def setup_provisioner_spec(client)
    create(:staff, email: 'test@example.com')
    ENV['MIQ_ENABLED'] = 'true'
    ENV['MIQ_USER_EMAIL'] = 'test@example.com'

    allow(RestClient::Resource).to receive(:new) do
      double('rest client', '[]'.to_sym => client)
    end
  end
end
