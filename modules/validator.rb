module Validator
  def valid?
    validate!
    errors.empty?
  end
end
