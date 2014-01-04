class Taking < ActiveRecord::Base
  stampable
  has_paper_trail
  
  validates :store_id, presence: true
  validates :date, presence: true, uniqueness: { scope: :store_id }
  validates :value, presence: true, numericality: true
  validates :card_payments, presence: true, numericality: true
  
  belongs_to :store
  
  before_save :calculate_cash_payments
  
  def calculate_cash_payments
    self.cash_payments = self.value - self.card_payments
  end
  
  # Finds last sale date for given stores or store
  def self.last_date(options = {})
    options[:stores]          ||= Store.all
    takings = self.where(store_id: options[:stores].map{|s| s.id}).order('date DESC')
    takings.any? ? takings.first.date : nil
  end
  
  def self.by_day_of_week(options = {})
    options[:stores]          ||= Store.all
    options[:agregate]        ||= 'AVG'
    options[:value]           ||= 'value'
    options[:to]              ||= self::last_date
    options[:from]            ||= Date::parse(options[:to].to_s) - 90.days
    
    records = self.select("WEEKDAY(date) AS weekday, store_id, #{options[:agregate].to_s}(#{options[:value].to_s}) AS value")
                  .where('date >= ? AND date <= ?', options[:from].to_s, options[:to].to_s)
                  .group('weekday')
                  .order('weekday')
        
    if options[:for_chart]
      @chart_data = []
      options[:stores].each do |store|
        @chart_data << {name: store.symbol, data: records.where(store_id: store.id).map{|r| [Crp::WEEKDAYS[I18n.locale][r.weekday], r.value.to_i]}}
      end
      @chart_data
    else
      records
    end
  end
  
  def self.by_day(options = {})
    options[:stores]          ||= Store.all
    options[:to]              ||= self::last_date
    options[:from]            ||= Date::parse(options[:to].to_s) - 31.days
    
    records = self.where('date >= ? AND date <= ?', options[:from].to_s, options[:to].to_s)
                  .order('date')
                  
    if options[:for_chart]
      @chart_data = []
      options[:stores].each do |store|
        @chart_data << {name: store.symbol, data: records.where(store_id: store.id).map{|r| [r.date, r.value.to_i]}}
      end
      @chart_data
    else
      records
    end    
  end
  
  def self.by_month(options = {})
    options[:stores]          ||= Store.all
    options[:agregate]        ||= 'AVG'
    options[:value]           ||= 'value'
    options[:to]              ||= self::last_date
    options[:from]            ||= Date::parse(options[:to].to_s) - 24.months
    
    records = self.select("DATE_FORMAT(date, '%Y-%m') AS month, store_id, #{options[:agregate].to_s}(#{options[:value].to_s}) AS value")
                  .where('date >= ? AND date <= ?', options[:from].to_s, options[:to].to_s)
                  .group('month')
                  .order('month')
        
    if options[:for_chart]
      @chart_data = []
      options[:stores].each do |store|
        @chart_data << {name: store.symbol, data: records.where(store_id: store.id).map{|r| [I18n::l(Date::parse(r.month.to_s + '-01'), format: "%b %y"), r.value.to_i]}}
      end
      @chart_data
    else
      records
    end
  end

end
