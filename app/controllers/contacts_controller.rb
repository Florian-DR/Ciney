class ContactsController < ApplicationController

    def contact
    end

    def reservation_sender
        email = params[:email]
        gite = params[:gite]
        capacity = params[:capacity]
        telephone = params[:telephone]
        message = params[:message]
        start_date = params[:start_date]
        end_date = params[:end_date]
        CineyMailer.with(email: email, gite: gite, capacity: capacity, telephone: telephone, message: message, start_date: start_date, end_date: end_date).reservation_mailer.deliver_now
        redirect_to contact_path 
        flash.notice = "Votre demande à été envoyée, un mail de confirmation devrait suivre"
    end
end
