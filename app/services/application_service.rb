class ApplicationService
  class << self
    def validate_with_contract(contract_class, params)
      result = contract_class.new.call(params.to_h)
      
      if result.success?
        { success: true, data: result.to_h }
      else
        error_response('Params validation error', result.errors.to_h)
      end
    end
  
    def success_response(message, data, code = 200)
      { success: true, data: data, message: message, code: code }
    end
  
    def error_response(message, errors = {}, code = 400)
      { success: false, errors: errors, message: message, code: code }
    end
  end
end
