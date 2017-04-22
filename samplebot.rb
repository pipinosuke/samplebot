require "slack"
require "date"
require "dotenv"

Dotenv.load
TOKEN = ENV['SlackToken']

Slack.configure {|config| config.token = TOKEN }
client = Slack.realtime
time = DateTime.now
date = Date.today

def Slackpost(text, channel = "general")
  Slack.chat_postMessage(text: "#{text}",channel: "#{channel}")
end

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  # 得られたmessageにtestが含まれていて、botからのメッセージでなければ
  if data["subtype"] != "bot_message"
    Slackpost("うんこ！うんこ！", "general") if data["text"].include?("うん")
    Slackpost("おはよー", "general") if data["text"].include?("おは")
    Slackpost("おやすみ","general") if data["text"].include?("おやす")
    Slackpost("#{time.hour}時#{time.min}分#{time.sec}秒です","general") if data["text"].include?("時間")
  end

    if time.hour == 07
      Slackpost("おはよー", "general")
      next unless date.day == 25
      Slackpost("@channel そろそろ家賃払うぶー", "general")
    elsif time.hour == 19
      Slackpost("今日もお疲れー","general")
      Slackpost("@channel 明日は燃えるゴミの日","general") if date.wday == 6 || 3
      Slackpost("@channel 明日は缶とペットボトルの日", "general" ) if date.wday == 4
    end
end

client.start
