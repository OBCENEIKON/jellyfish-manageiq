class AlertsController < ApplicationController
  after_action :verify_authorized
  after_action :post_hook

  before_action :pre_hook
  before_action :load_alerts, only: [:index]
  before_action :load_alert, only: [:show, :update, :destroy]
  before_action :load_update_params, only: [:update]
  before_action :load_create_params, only: [:create]

  api :GET, '/alerts', 'Returns all alerts.'
  param :active, :bool, required: false
  param :latest, :bool, required: false
  param :sort, Array, required: false
  param :not_status, Array, required: false
  param :includes, Array, required: false, in: %w(project)
  param :page, :number, required: false
  param :per_page, :number, required: false

  def index
    authorize Alert
    respond_with_params @alerts
  end

  api :GET, '/alerts/:id', 'Shows alert with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    authorize @alert
    respond_with @alert
  end

  api :POST, '/alerts', 'Creates a new alert'
  param :project_id, String, required: true, desc: 'The project id issued with this new alert. <br>A 0 indicates system wide alert.'
  param :staff_id, String, required: true, desc: 'The staff id of the user who is posting this new alert. <br>0 indicates a system generated alert.'
  param :order_item_id, String, required: true, desc: 'The order item id associated with this new alert. <br>A 0 indicates a project wide alert.'
  param :status, String, required: true, desc: 'HTTP status code issued with this alert. <br>Valid Options: OK, WARNING, CRITICAL, UNKNOWN, PENDING'
  param :message, String, required: true, desc: 'The message content of the new alert.'
  param :start_date, String, required: false, desc: 'Date this alert will begin appearing. Null indicates the alert will start appearing immediately.'
  param :end_date, String, required: false, desc: 'Date this alert should no longer be displayed after. Null indicates the alert does not expire.'
  description 'Endpoint to create a new status alert for an order. <br>If a status alert is the same as the last one recorded for the service, then the existing status alert is updated. <br> Otherwise, a new status alert is created for the service.'
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    @alert = Alert.new @alert_params
    authorize @alert
    last_alert = last_alert_for_service
    if last_alert.nil? || last_alert.status != @alert.status
      # Save a new alert if none exist, or if statuses differ
      @alert.save
    else
      # Update an existing alert
      @alert = Alert.find @alert_id
      authorize @alert
      load_update_params
      @alert.update_attributes @alert_params
    end
    respond_with @alert
  end

  api :PUT, '/alerts/:id', 'Updates alert with given :id'
  param :staff_id, String, required: false, desc: 'The staff id of the user who is posting this new alert. <br>0 indicates a system generated alert.'
  param :message, String, required: false, desc: 'The message content to update alert with.'
  param :start_date, String, required: false, desc: 'Date this alert will begin appearing. Null indicates the alert will start appearing immediately.'
  param :end_date, String, required: false, desc: 'Date this alert should no longer be displayed after. Null indicates the alert does not expire.'
  description 'Endpoint to update an existing alert. <br>To preserve referential integrity, only the following attributes can be changed: message, start_date, end_date.'
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def update
    authorize @alert
    @alert.update_attributes @alert_params
    respond_with @alert
  end

  api :DELETE, '/alerts/:id', 'Deletes alert with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize @alert
    @alert.destroy
    respond_with @alert
  end

  private

  def load_create_params
    params.require :project_id
    params.require :staff_id
    params.require :order_item_id
    params.require :status
    params.require :message
    @alert_params = params.permit(:project_id, :staff_id, :order_item_id, :status, :message, :start_date, :end_date)
  end

  def load_update_params
    @alert_params = params.permit(:staff_id, :message, :start_date, :end_date)
  end

  def load_alert_mapping
    # TODO : Hardcoded now, but should take host/port/service and map to project/order; staff_id == 0 or TBD
    @alert_mapping = { project_id: '1', staff_id: '0', order_item_id: '1' }
  end

  def load_alerts
    params.slice(:active, :not_status, :sort, :page, :per_page, :includes, :latest)
    query = policy_scope(Alert)
    query = apply_active_or_inactive(query)
    query = apply_not_status(query)
    query = apply_sort(query)
    query = apply_latest(query)
    @alerts = query_with query.where(nil), :includes, :pagination
  end

  def apply_latest(query)
    if params[:latest].present? && params[:latest] == 'true'
      query = query.latest
    end
    query
  end

  def apply_sort(query)
    if params[:sort].present?
      (%w(project_order oldest_first newest_first) & params[:sort]).each do |sort|
        query = query.send sort.to_sym
      end
    end
    query
  end

  def apply_not_status(query)
    if params[:not_status].present?
      (%w(OK WARNING CRITICAL PENDING UNKNOWN) & params[:not_status]).each do |status|
        query = query.not_status(status)
      end
    end
    query
  end

  def apply_active_or_inactive(query)
    if params[:active].present?
      query = params[:active] == 'true' ? query.active : query.inactive
    end
    if params[:inactive].present?
      query = params[:inactive] == 'true' ? query.inactive : query.active
    end
    query
  end

  def load_alert
    @alert = Alert.find params.require(:id)
  end

  def load_alert_id
    conditions = {
      project_id: @alert_params['project_id'],
      order_item_id: @alert_params['order_item_id'],
      status: @alert_params['status']
    }
    @alert_id = Alert.where(conditions).pluck(:id).first
  end

  def last_alert_for_service
    conditions = {
      project_id: @alert_params['project_id'],
      order_item_id: @alert_params['order_item_id']
    }
    Alert.where(conditions).order('updated_at DESC').limit(1).first
  end
end
