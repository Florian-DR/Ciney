class ContactsController < ApplicationController

    def contact
    end

    def reservation_sender
        email = params[:email]
        CineyMailer.with(email: email).reservation_mailer.deliver_now
    end
end
