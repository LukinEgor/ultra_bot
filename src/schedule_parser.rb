require 'nokogiri'
require 'open-uri'

module ScheduleParser
  class << self
    def parse
      data = get_data
      result = {}
      (1..7)
        .map { |day| get_day_schedule(data, day) }
        .to_h
    end

    private
    def get_data
      doc = Nokogiri::HTML(open("http://fitness-ultra.ru/shedule/"))
      doc
        .css('.shedule_full')
        .css('.rpl')
        .map do |div|
          div.children
            .select { |ch| !ch.text.include? "\n" }
            .map { |ch| ch.text }
        end
    end

    def get_day_schedule(data, day)
      result = data.map { |field| [data.index(field) + 1, field[day]] }
      [day, result.to_h]
    end
  end
end
