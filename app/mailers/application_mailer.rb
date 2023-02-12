class ApplicationMailer < ActionMailer::Base
  default from: "john@#{Rails.application.config.outbound_email_domain}"

  layout "mailer"
end
