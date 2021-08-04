#!/usr/bin/env ruby
require 'cinch'
require 'yaml'

# Plugins
require_relative "plugins/identify.rb"
require_relative "plugins/yamlscore.rb"
require_relative "plugins/yamlmemo.rb"
require_relative "plugins/yamlkeywords.rb"
require_relative "plugins/remind.rb"
require_relative "plugins/welcome.rb"
#require "cinch/plugins/urlscraper"

require_relative "plugins/plugin_management.rb"


bot = Cinch::Bot.new do
    configure do |c|
        c.ping_interval = 240
        #c.plugins.prefix = "!"

        # You can set these details here or in an external file too, which will be not tracked by git
        account = YAML.load_file '../database/account.yaml'

        #c.server = "irc.freenode.org"
        c.server = account['server']
        #c.channels = ["#elive-bots"]
        # anybody knows how to set this on the yaml file ? (list of items
        c.channels = ["#elive", "#elive-dev", "#elive-bots"]

        #c.user = "superkeyra2"
        c.user = account['user']
        c.realname = account['user']
        c.nick = account['user']

        # The Nickserv accouname of the bot. This is usually the same as the nickname
        c.sasl.username = account['user']
        # The Nickserv password of the bot.
        c.sasl.password = account['pass']


        #
        # Plugins:
        #
        c.plugins.plugins = [
            Cinch::Plugins::Identify,
            Cinch::Plugins::YamlScore,
            Cinch::Plugins::YamlMemo,
            Cinch::Plugins::YamlKeywords,
            Cinch::Plugins::Remind,
            Cinch::Plugins::Welcome,
            Cinch::Plugins::PluginManagement,
        ]

        # if you need to identify with pass your user-bot, see https://github.com/cinchrb/cinch-identify


        if defined?(account['pass'])
                    c.plugins.options[Cinch::Plugins::Identify] = {
                        :username => account['user'],
                        :password => account['pass'],
                        :type     => :nickserv,
                    }
        end


        # user, +1
        # The following line is optional, if committed there will be no message.
        #c.plugins.options[Cinch::Plugins::YamlScore] = { warn_no_user_message: "User %s is not in the channel, who do you want to score?" }

        #!keywords                         # list all definitions
        #!keyword? <keyword>               # show single definition
        #!keyword  <keyword>  <definition> # define without spaces
        #!keyword '<keyword>' <definition> # define with spaces
        #!keyword "<keyword>" <definition> # define with spaces
        #!forget   <keyword>               # remove definition
        #<keyword>                         # display definition

        # just paste an url in the channel
        # note: it uses some amount of RAM, instead of 1.8 % it goes to 4.5 %
        #c.plugins.plugins = [Cinch::Plugins::UrlScraper]

    end

end

bot.start
