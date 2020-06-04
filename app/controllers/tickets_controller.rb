# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tickets = Ticket.includes(:organisation, :user).all
  end
end
