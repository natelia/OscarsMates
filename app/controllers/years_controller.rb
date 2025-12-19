class YearsController < ApplicationController
  def index
    @available_years = Nomination.available_years
  end
end
