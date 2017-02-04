require 'test/unit'
require './src/schedule_parser.rb'

class ScheduleParserTest < Test::Unit::TestCase
  def test_first_train
    schedule = ScheduleParser.parse
    exercise = schedule["Понедельник"]
      .detect{ |ex| ex[:time] == "8:00"}

    assert_equal(exercise[:name], "ABT")
  end

  def test_last_train
    schedule = ScheduleParser.parse
    exercise = schedule["Воскресенье"]
      .detect{ |ex| ex[:time] == "19:00"}

    assert_equal(exercise[:name], "CROSSFIT")
  end
end
