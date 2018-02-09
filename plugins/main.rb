class Main
  include Cinch::Plugin

  listen_to :channel, method: :checkforspammers, strip_colors: true

  def checkforspammers(m)
    users = m.channel.users.keys.join(',').split(',')
    message = m.params[1].split(' ')
    i = 0
    while i < message.length
      message[i] = message[i].tr('^A-Za-z0-9', '')
      i += 1
    end
    banspammer = false
    mention = 0
    users.each do |meme|
      mention += 1 if message.include?(meme) == true
    end
    banspammer = true if mention > 2
    bot.irc.send("KILL #{m.user.name} Spam is off topic on ChewChat") if banspammer == true
  end
end
