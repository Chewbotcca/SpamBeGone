class Setup
  def initialize
    begin
      require 'yaml'
    rescue LoadError
      puts 'YAML not found! Is your ruby ok?'
      exit
    end
    unless File.exist?('config.yaml')
      puts 'No config file! Creating one now..'
      File.new('config.yaml', 'w+')
      exconfig = YAML.load_file('config.example.yaml')
      File.open('config.yaml', 'w') { |f| f.write exconfig.to_yaml }
    end
    @config = YAML.load_file('config.yaml')
    exit if @config == false
  end

  def welcome(skipwelcome = true)
    unless skipwelcome
      puts 'Welcome to SpamBeGone bot setup'
      puts 'This really simple GUI will guide you in setting up the bot by yourself!'
      puts 'Press enter to get started'
      gets
    end
    config
  end

  def config
    puts 'Alright! Config time.'

    puts 'What would you like to configure?'
    puts '[1] - Bot information (REQUIRED)'
    puts '[2] - Connection information (REQUIRED)'
    puts '[3] - Exit'
    input = gets.chomp

    configure('bot') if input == '1'
    configure('server') if input == '2'
    exit
  end

  def configure(section)
    if section == 'bot'
      puts 'Pick a nickname for the bot - REQUIRED'
      @config['nickname'] = gets.chomp

      puts 'What channels should the bot join on startup? this must be comma seperated with #s before the names. - Optional'
      puts 'Hint! You can always invite the bot to your channel and it will join!'
      @config['channels'] = gets.chomp

      puts "What should be the bot's realname? This is shown in a whois. - Optional"
      @config['realname'] = gets.chomp

      puts 'What should be the bot\'s USERNAME? (this is what\'s shown before the @ in a hostname. e.g. chew!THIS@blah) - Optional'
      @config['username'] = gets.chomp

      puts 'NickServ Password - Optional'
      puts 'Not registered? The bot has a built in NickServ registration process!'
      @config['nickservpass'] = gets.chomp

      puts 'Bot Oper Username - Required'
      puts 'The bot needs oper access to kill users, please put in the oper username'
      @config['operusername'] = gets.chomp

      puts 'Bot Oper Pass - Required'
      puts 'The bot needs oper access to kill users, please put in the oper password'
      @config['operpass'] = gets.chomp

      puts 'It turns out you\'re done configuring bot settings!'
      save
      config
    end

    if section == 'server'
      puts 'Enter the server address (hostname, IP, whatever, NO PORT yet) - REQUIRED'
      @config['server'] = gets.chomp

      puts 'Enter the server port, if you don\'t know, use 6667 - REQUIRED'
      @config['port'] = gets.chomp

      puts 'Connect using SSL? (true/false)'
      input = gets.chomp
      @config['ssl'] = true?(input)

      puts 'Done configuring server connection information!'
      save
      config
    end
  end

  def save
    File.open('config.yaml', 'w') { |f| f.write @config.to_yaml }
  rescue => e
    puts 'uh oh, there was an error saving. Report the following error to Chew on github'
    puts e
  end

  def true?(obj)
    obj.to_s == 'true'
  end
end

jerry = Setup.new
jerry.welcome(false)
