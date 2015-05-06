module ObserverCallbackEvents
  extend ActiveSupport::Concern

  included do
    after_find :relay_event
  end

  def relay_event
    ap self
  end
end