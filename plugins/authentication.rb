class Authentication
  include Cinch::Plugin

  listen_to :connect, method: :identify
  listen_to :connect, method: :operup

  def identify(_m)
    User('NickServ').send("identify #{CONFIG['nickservpass']}") unless CONFIG['nickservpass'].nil? || CONFIG['nickservpass'] == ''
  end

  def operup(_m)
    bot.oper(CONFIG['operpass'], CONFIG['operusername']) unless CONFIG['operpass'].nil? || CONFIG['operpass'] == ''
  end
end
