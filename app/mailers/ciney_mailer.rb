class CineyMailer < ApplicationMailer
    def reservation_mailer
        email = params[:email]
        mail(to: email, subject: "Réservation pour les gites d'Auwez")
    end
end
