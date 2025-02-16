class ReservationsController < ApplicationController
  skip_before_action :authenticate_user!
  def reservation
      @gites = Gite.all.order(:id)
      @events = Gite.events
      @non_available = Gite.events_dates
  end

  def gites_reservation_sender
      CineyMailer.with(email: params[:email], 
                      gite: params[:gite], 
                      capacity: params[:capacity], 
                      telephone: params[:telephone], 
                      message: params[:message], 
                      start_date: params[:start_date], 
                      end_date: params[:end_date]).gites_reservation_mailer.deliver_now

      redirect_to reservation_path 
      flash.notice = "Votre demande à été envoyée, un mail de confirmation devrait suivre"
  end

  def mariages_reservation_sender
      CineyMailer.with(email: params[:email], 
                      date: params[:date], 
                      telephone: params[:telephone], 
                      message: params[:message]).mariages_reservation_mailer.deliver_now

      redirect_to reservation_path 
      flash.notice = "Votre demande à été envoyée, un mail de confirmation devrait suivre"
  end
end
