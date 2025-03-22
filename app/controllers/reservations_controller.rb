class ReservationsController < ApplicationController
  skip_before_action :authenticate_user!
  def reservation
    # Faster to load on the controller than on the view
    @gite_1 = @gites.first
    @gite_2 = @gites.second
    @gite_3 = @gites.third

    if params["start_date"] && session[:dates_1] && session[:dates_2] && session[:dates_3]
      @events_1 = session[:dates_1]
      @events_2 = session[:dates_2] 
      @events_3 = session[:dates_3]
    else
      @events_1 = session[:dates_1] = @gite_1.events_dates
      @events_2 = session[:dates_2] = @gite_2.events_dates
      @events_3 = session[:dates_3] = @gite_3.events_dates
    end

  end

  def gites_reservation_sender
    if params[:gite].size < 2 
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
