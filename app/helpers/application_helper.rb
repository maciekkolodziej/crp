module ApplicationHelper

  def show(string)
    if string.class == TrueClass || string.class == FalseClass
      b string
    elsif string.blank?
      not_set
    else
      string
    end
  end
  
  def not_set
    output = '<span class="not_set">' + t('not_set', default: 'Not set') + '</span>'
    output.html_safe
  end
  
  def b(value, options = {})
    if value.class == TrueClass or value.class == FalseClass
      options = {
        :true => :positive,
        :false => :negative,
        :scope => [:boolean],
        :locale => I18n.locale
      }.merge options
      
      boolean = !!value
      key = boolean.to_s.to_sym
   
      t(options[key], :scope => options[:scope], :locale => options[:locale])
    else
      value
    end
  end
  
  def to_dropdown(model, options = {} )
    model = model.to_s.classify.constantize
    for a in [options[:attribute], :symbol, :name, :id]
      if model.column_names.include?(a.to_s)
        options = model.all.map{|i| [i.read_attribute(a), i.id]}
        break
      end
    end
    options
  end
    
end
