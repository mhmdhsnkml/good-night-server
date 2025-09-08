# Track database query latency
ActiveSupport::Notifications.subscribe('sql.active_record') do |name, start, finish, id, payload|
  duration = (finish - start) * 1000 # Convert to milliseconds
  
  # Log slow queries (> 100ms) with details
  if duration > 100
    Rails.logger.warn "[SLOW QUERY] #{duration.round(2)}ms - #{payload[:sql]}"
  end
end
