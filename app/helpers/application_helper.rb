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
  
  def showold(model, attribute, options = {})
    model_class = model.class.name.constantize
    if attribute.class == Symbol
      options[:label] ||= model_class.human_attribute_name(attribute)
      if model.read_attribute(attribute) == nil
        attribute = '<span class="not_set">' + t('not_set', default: 'Not set') + '</span>'
      elsif model.column_for_attribute(attribute).type == :boolean
        attribute = b model.read_attribute(attribute)
      else
        attribute = model.read_attribute(attribute)
      end
    end

    output = "<dt>#{options[:label]}:</dt>"
    output += "<dd>#{attribute}</dd>"
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
    
end
