class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(ENV["GMAIL_ADDRESS"], "La Ferme d’Auwez")
  layout "mailer"
end
