require 'nokogiri'
require 'open-uri'

module ScheduleParser
  class << self
    @@days = {1 => "Понедельник",
              2 => "Вторник",
              3 => "Среда",
              4 => "Четверг",
              5 => "Пятница",
              6 => "Суббота",
              7 => "Воскресенье" }

    def days_name
      @@days
    end

    def parse
      @@data = get_data
      times = @@data.map { |field| field[0] }
      (1..7)
        .map { |day| get_day_schedule(@@data, day, times) }
        .to_h
    end

    def exercises
      @@data
        .each { |it| it.delete_at(0) }
        .flatten
        .uniq
        .select { |ex| ex != "" }
        .sort
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

    def get_day_schedule(data, day, times)
      result = data.map do |field|
        number = data.index(field)
        if field[day] != ""
          { time: times[number], name: field[day] }
        else
          nil
        end
      end
        .compact
      [@@days[day], result]
    end
  end
end
