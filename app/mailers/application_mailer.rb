class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "Chord Book <help@chordbook.app>")
  layout "mailer"
end
