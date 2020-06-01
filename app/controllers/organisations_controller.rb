# frozen_string_literal: true

class OrganisationsController < ApplicationController
  def index
    @organisations = Organisation.order(:name)
  end

  def show
    @organisation = Organisation.find_by(id: params[:id])
  end
end
