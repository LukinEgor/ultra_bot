require 'test/unit'
require './src/schedule_parser.rb'

class ScheduleParserTest < Test::Unit::TestCase
  def test_first_train
    schedule = ScheduleParser.parse
    assert_equal(schedule[1][1], "ABT")
  end

  def test_last_train
    schedule = ScheduleParser.parse
    assert_equal(schedule[7][11], "CROSSFIT")
  end
end
