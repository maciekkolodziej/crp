I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

module RailsI18n
  module Pluralization
    module Polish
      def self.rule
        lambda do |n|
          if n == 1
            :one
          elsif [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100)
            :few
          elsif ([0, 1] + (5..9).to_a).include?(n % 10) || [12, 13, 14].include?(n % 100)
            :many
          else
            :other
          end
        end
      end 
    end
  end
end