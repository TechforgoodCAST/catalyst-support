# frozen_string_literal: true

class OrganisationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @organisations = Organisation.order(:name)
  end

  def show
    @organisation = Organisation.includes(:users).find_by(id: params[:id])
  end
end
