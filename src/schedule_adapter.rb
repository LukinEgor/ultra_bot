require_relative './schedule_parser.rb'

class ScheduleAdapter
  def initialize
    @api = ScheduleParser.parse
    @exercises = ScheduleParser.exercises
    @days_name = ScheduleParser.days_name
  end

  def now
    weekday = @days_name[Date.today.wday]
    exercises = @api[weekday]
    format(exercises)
  end

  def tomorrow
    weekday = @days_name[Date.today.wday == 7 ? 1 : Date.today.wday + 1]
    exercises = @api[weekday]
    format(exercises)
  end

  def all_week
    @api.reduce("") { |acc, (k, v)| acc += "#{k}:\n#{format(v)}\n" }
  end

  def search(exercise)
    @api
      .map { |k, v| [k, v.select { |ex| ex[:name] == exercise } ] }
      .to_h
      .select { |k, v| v.size != 0  }
      .reduce("") { |acc, (k, v)| acc += "#{k}:\n#{format(v)}\n" }
  end

  def exercises
    @exercises
  end

  private
  def format(exercises)
    exercises.reduce("") do |acc, ex|
      acc += "#{ex[:time]} - #{ex[:name]}\n"
    end
  end
end
