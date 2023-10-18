class CineyMailer < ApplicationMailer
    def reservation_mailer
        @email = params[:email]
        @gite = params[:gite]
        @capacity = params[:capacity]
        @telephone = params[:telephone]
        @message = params[:message]
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        mail(bcc: [@email], subject: "Réservation pour les gites d'Auwez")
    end
end
