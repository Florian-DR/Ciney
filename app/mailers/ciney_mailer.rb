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
        mail(to: [@email], bcc: ENV['GMAIL_ADDRESS'], subject: "Réservation pour les gites d'Auwez - #{@start_date} / #{@end_date}")
    end

    def contact_mailer
        @name = params[:name]
        @first_name = params[:first_name]
        @email = params[:email]
        @telephone = params[:telephone]
        @message = params[:message]
        mail(to: [@email], bcc: ENV['GMAIL_ADDRESS'], subject: "Prise de contact - #{@name} #{@first_name}")
    end

    def team_building_inquiry_mailer
        inquiry = params.fetch(:inquiry)
        @company = inquiry.fetch("company")
        @contact_name = inquiry.fetch("contact_name")
        @email = inquiry.fetch("email")
        @telephone = inquiry.fetch("telephone")
        @participants = inquiry.fetch("participants")
        @desired_dates = inquiry.fetch("desired_dates")
        @package = TeamBuildingInquiry::PACKAGE_OPTIONS.key(inquiry.fetch("package"))
        @message = inquiry.fetch("message")

        farm_email = ENV.fetch("GMAIL_ADDRESS")
        recipients = { to: @email }
        recipients[:bcc] = farm_email unless @email.casecmp?(farm_email)

        attachments.inline["logo-ferme-dauwez.png"] = {
          mime_type: "image/png",
          content: File.binread(Rails.root.join("app/assets/images/logo-email.png")),
        }

        mail(
          **recipients,
          subject: "Votre projet team building à la Ferme d’Auwez – #{@company}".squish,
        ) do |format|
          format.html { render layout: "team_building_mailer" }
          format.text
        end
    end

    # def mariages_reservation_mailer
    #     @email = params[:email]
    #     @date = params[:date]
    #     @telephone = params[:telephone]
    #     @message = params[:message]
    #     mail(bcc: [@email], subject: "Réservation pour un mariage à la Ferme d'Auwez - #{@date}")
    # end
end
