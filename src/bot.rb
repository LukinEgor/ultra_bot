require 'telegram/bot'
require './src/schedule_adapter.rb'

token = ENV["TELEGRAM_TOKEN"]
schedule = ScheduleAdapter.new
answers_keyboard =
  Telegram::Bot::Types::ReplyKeyboardMarkup
  .new(keyboard: ["сегодня", "завтра", "на неделю", "поиск"], one_time_keyboard: true)

commands =
  schedule.exercises
  .map { |ex| [ex, "/#{ex.gsub(/[ +-]/, '_')}"] }
  .to_h

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.sendMessage(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}")
    when 'сегодня'
      bot.api.sendMessage(chat_id: message.chat.id, text: schedule.now, reply_markup: answers_keyboard)
    when 'завтра'
      bot.api.sendMessage(chat_id: message.chat.id, text: schedule.tomorrow, reply_markup: answers_keyboard)
    when 'на неделю'
      bot.api.sendMessage(chat_id: message.chat.id, text: schedule.all_week, reply_markup: answers_keyboard)
    when 'поиск'
      text =
        commands
        .reduce("Выберите тренировку:\n") { |acc, (k, v)| acc += "#{v}\n" }

      bot.api.sendMessage(chat_id: message.chat.id, text: text)
    else
      result = commands.detect { |k, v| v == message.text }

      if result.nil?
        bot.api.sendMessage(chat_id: message.chat.id, text: "Введено некорректное название", reply_markup: answers_keyboard)
      else
        exercise = result[0]
        bot.api.sendMessage(chat_id: message.chat.id, text: schedule.search(exercise), reply_markup: answers_keyboard)
      end
    end
  end
end
