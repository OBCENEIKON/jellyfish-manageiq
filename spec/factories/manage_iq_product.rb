FactoryGirl.define do
  factory :manage_iq_product do
    options nil
    sequence :service_type_id
    sequence :service_catalog_id
    sequence :chef_role do |n|
      "role_#{n}"
    end
  end
end
