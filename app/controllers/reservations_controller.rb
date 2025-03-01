class ReservationsController < ApplicationController
  skip_before_action :authenticate_user!
  def reservation
      @gites = Gite.all.order(:id)
      @events = Gite.events
      @non_available = Gite.events_dates
  end

  def gites_reservation_sender
    if params[:gite].size < 2 
      @events = Gite.events
      @non_available = Gite.events_dates
      redirect_to reservation_path 
      flash.alert = "Votre demande n'a pas pu être envoyé parce qu'aucun gite n'a été sélectionné"
    else
      CineyMailer.with(
                      name: params[:name],
                      first_name: params[:first_name],
                      email: params[:email], 
                      gite: to_beautiful_string(params[:gite]), 
                      capacity: params[:capacity], 
                      telephone: params[:telephone], 
                      message: params[:message], 
                      start_date: params[:start_date], 
                      end_date: params[:end_date]).gites_reservation_mailer.deliver_now
      redirect_to reservation_path 
      flash.notice = "Votre demande à été envoyée, un mail de confirmation devrait suivre"
    end
  end

  # def mariages_reservation_sender
  #     CineyMailer.with(email: params[:email], 
  #                     date: params[:date], 
  #                     telephone: params[:telephone], 
  #                     message: params[:message]).mariages_reservation_mailer.deliver_now

  #     redirect_to reservation_path 
  #     flash.notice = "Votre demande à été envoyée, un mail de confirmation devrait suivre"
  # end

  private

  def to_beautiful_string(gites)
    gites.drop(1).join(" & ")
  end
end
