Rails.application.config.generators do |g|
  g.template_engine :all
  g.fallbacks[:all] = :haml # or haml/slim etc
end