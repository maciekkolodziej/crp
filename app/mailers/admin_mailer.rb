class AdminMailer < ActionMailer::Base
  default from: '"CRP" <crp@maciekkolodziej.pl>',
          to: "maciek@kolodziej.com.pl"
  
  def new_user(user)
    @user = user
    mail(subject: "#{@user.first_name} #{@user.last_name} zarejestrował(a) się w CRP.")
  end

end