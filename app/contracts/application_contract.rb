class ApplicationContract < Dry::Validation::Contract
  UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

  register_macro(:uuid) do
    key.failure('must be a valid UUID') unless UUID_FORMAT.match?(value)
  end
end
