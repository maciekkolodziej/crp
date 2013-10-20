class LogMailer < ActionMailer::Base
  default from: '"CRP" <crp@maciekkolodziej.pl>',
          to: "maciek@kolodziej.com.pl"
          
  def wrong_receipts_count(sale)
    @sale = sale
    mail(subject: "Wrong receipt count")
  end
  
  def wrong_receipts_value(sale)
    @sale = sale
    mail(subject: "Wrong receipt value")
  end
  
end
