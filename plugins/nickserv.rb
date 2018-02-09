class NickServ
  include Cinch::Plugin

  match />nsregister (.+) (.+)/, method: :register
  match />nsverify (.+)/, method: :verify

  def register(m, pass, email)
    if m.user.oper?
      User('NickServ').send("register #{pass} #{email}")
      CONFIG['nickservpass'] = pass.to_s
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      m.reply 'I sent verification to nickserv. It might need to verify the email. In that case, type `>nsverify [code]` to verify it. Otherwise, the password has been logged into the config and it will auto-authenticate on startup!'
    else
      m.reply 'You are not permitted to do this action!'
    end
  end

  def verify(m, code)
    if m.user.oper?
      User('NickServ').send("verify register #{CONFIG['nickname']} #{code}")
      m.reply 'Hey! NickServ verified!'
    else
      m.reply 'You are not permitted to do this action!'
    end
  end
end
