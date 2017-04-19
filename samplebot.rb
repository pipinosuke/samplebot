require "slack"
require "date"

TOKEN = "xoxb-171683075394-rANMa3wjjrOwXmDC7fqtor5f"

Slack.configure {|config| config.token = TOKEN }
client = Slack.realtime
time = DateTime.now
date = Date.today

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  # 得られたmessageにtestが含まれていて、botからのメッセージでなければ
  if data["subtype"] != "bot_message"
    Slack.chat_postMessage(text: "うんこ！！", channel: "general") if data["text"].include?("うん")
    Slack.chat_postMessage(text: "おはよー", channel: "general") if data["text"].include?("おはよ")
    Slack.chat_postMessage(text: "おやすみー", channel: "general") if data["text"].include?("おやすみ")
  end

  break unless time.min + time.sec == 00
    if time.hour == 07
      Slack.chat_postMessage(text: "おはようだぶー", channel: "general")
      break unless date.day == 25
      Slack.chat_postMessage(text: "そろそろ家賃払うぶー", channel: "general")
    end

    if time.hour == 19
      Slack.chat_postMessage(text: "今日もお疲れー", channel: "general")
      Slack.chat_postMessage(text: "明日は燃えるゴミの日", channel: "general") if date.wday == 6 || 3
      Slack.chat_postMessage(text: "明日はカンとペットボトルの日", channel: "general") if date.wday == 4
    end
end

client.start
