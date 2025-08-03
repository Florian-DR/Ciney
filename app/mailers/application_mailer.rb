class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(ENV['GMAIL_ADDRESS'], "Gites d'Auwez")
  layout "mailer"
end
