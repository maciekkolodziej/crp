class LogMailer < ActionMailer::Base
  default from: '"CRP" <crp@inevi.pl>',
          to: "maciek@kolodziej.com.pl"
          
  def sale_report(sale)
    @sale = sale    
    mail(subject: "Utarg w #{@sale.pos_id} z #{@sale.date} wynosi #{@sale.value} (#{@sale.receipt_count} par.)")
  end
  
end
