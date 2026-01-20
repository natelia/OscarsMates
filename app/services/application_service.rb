# frozen_string_literal: true

# Base class for all service objects
# Provides a standard interface with .call class method
class ApplicationService
  def self.call(...)
    new(...).call
  end

  def call
    raise NotImplementedError, "#{self.class} must implement #call"
  end
end
