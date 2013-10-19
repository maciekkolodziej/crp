class LogMailer < ActionMailer::Base
  default from: '"CRP" <crp@maciekkolodziej.pl>',
          to: "maciek@kolodziej.com.pl"
          
  def create(subject, message)
    subject ||= ""
    message ||= ""
    mail(subject: subject, body: message)
  end
end
