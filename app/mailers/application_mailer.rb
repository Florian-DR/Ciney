class ApplicationMailer < ActionMailer::Base
  # default from: email_address_with_name('deradigues@gmail.com ', "Gites d'Auwez")
  default from: email_address_with_name('florian.radigues@gmail.com ', "Gites d'Auwez")
  layout "mailer"
end
