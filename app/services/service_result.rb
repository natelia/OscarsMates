# frozen_string_literal: true

# Value object representing the result of a service operation
# Provides a consistent interface for success/failure handling
class ServiceResult
  attr_reader :data, :error

  def initialize(success:, data: nil, error: nil)
    @success = success
    @data = data
    @error = error
  end

  def success?
    @success
  end

  def failure?
    !@success
  end

  # Convenience class methods for creating results
  def self.success(data = nil)
    new(success: true, data: data)
  end

  def self.failure(error)
    new(success: false, error: error)
  end
end
