# frozen_string_literal: true

class OrganisationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @q = Organisation.order(:name).ransack(params[:q])
    @organisations = @q.result(distinct: true)
  end

  def show
    @organisation = Organisation.includes(:users).find_by(slug: params[:id])
    @organisation.fetch_cc_data
  end
end
