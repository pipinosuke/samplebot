require "slack"
require "date"
require "dotenv"

Dotenv.load
TOKEN = ENV['SlackToken']

Slack.configure {|config| config.token = TOKEN }
client = Slack.realtime
time = DateTime.now
date = Date.today

def Slackpost(text, channel)
  Slack.chat_postMessage(text: "#{text}",channel: "#{channel}")
end

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  # 得られたmessageにtestが含まれていて、botからのメッセージでなければ
  if data["subtype"] != "bot_message"
    Slackpost("うんこ", "general") if data["text"].include?("うん")
    Slackpost("おはよー", "general") if data["text"].include?("おはよ")
    Slackpost("おやすみ","general") if data["text"].include?("おやすみ")
  end

  next unless time.min + time.sec == 00
    if time.hour == 07
      Slackpost("おはよー", "general")
      next unless date.day == 25
      Slackpost("@here そろそろ家賃払うぶー", "general")
    end

    if time.hour == 19
      Slack.chat_postMessage(text: "今日もお疲れー", channel: "general")
      Slackpost("今日もお疲れー","general")
      Slackpost("@here 明日は燃えるゴミの日","general") if date.wday == 6 || 3
      Slackpost("@here 明日は缶とペットボトルの日", "general" ) if date.wday == 4
    end
end

client.start
