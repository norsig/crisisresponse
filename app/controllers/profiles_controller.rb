# frozen_string_literal: true

class ProfilesController < ApplicationController
  RECORDS_PER_PAGE = 12

  def index
    @search = Search.new(search_params)

    @people = @search.
      close_matches.
      includes(:response_plans, :visibilities, :reviews).
      page(params[:page]).
      per(RECORDS_PER_PAGE)

    @due_for_review = @people.select(&:due_for_review?)
  end

  private

  def search_params
    params.require(:search).permit(:name)
  rescue ActionController::ParameterMissing
    {}
  end
end
