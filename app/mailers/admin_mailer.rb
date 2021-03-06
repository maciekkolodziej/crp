class AdminMailer < ActionMailer::Base
  default from: '"CRP" <crp@inevi.pl>',
          to: "maciek@kolodziej.com.pl"
  
  def controller
    'AdminMailer'
  end
  
  def new_user(user)
    @user = user
    mail(subject: "#{@user.first_name} #{@user.last_name} zarejestrował(a) się w CRP.")
  end

end