# frozen_string_literal: true

# Filters users based on follow relationships
class UserFilterService < ApplicationService
  def initialize(current_user:, filter: nil)
    @current_user = current_user
    @filter = filter
  end

  def call
    filtered = apply_filter
    ServiceResult.success(filtered)
  rescue StandardError => e
    ServiceResult.failure(e.message)
  end

  private

  attr_reader :current_user, :filter

  def apply_filter
    if filter == 'followed' && current_user
      current_user.following
    else
      User.all
    end
  end
end
