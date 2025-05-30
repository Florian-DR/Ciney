class CineyMailer < ApplicationMailer
    def gites_reservation_mailer
        @name = params[:name]
        @first_name = params[:first_name]
        @email = params[:email]
        @gite = params[:gite]
        @capacity = params[:capacity]
        @telephone = params[:telephone]
        @message = params[:message]
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        mail(bcc: [@email], subject: "Réservation pour les gites d'Auwez - #{@start_date} / #{@end_date}")
    end

    def contact_mailer
        @name = params[:name]
        @first_name = params[:first_name]
        @email = params[:email]
        @telephone = params[:telephone]
        @message = params[:message]
        mail(bcc: [@email], subject: "Prise de contact - #{@name} #{@first_name}")
    end

    # def mariages_reservation_mailer
    #     @email = params[:email]
    #     @date = params[:date]
    #     @telephone = params[:telephone]
    #     @message = params[:message]
    #     mail(bcc: [@email], subject: "Réservation pour un mariage à la Ferme d'Auwez - #{@date}")
    # end
end
