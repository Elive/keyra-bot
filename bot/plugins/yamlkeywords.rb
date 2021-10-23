require 'yaml'

module Cinch
    module Plugins
        class YamlKeywords
            include Cinch::Plugin

            def initialize(*args)
                super
                if File.exist?('keywords.yaml')
                    then @keywords = YAML.load_file('keywords.yaml')
                else @keywords = {}
                end

                @replys = []
            end

            def keywords(m)
                #m.reply "Listing of keywords assigned is disabled to avoid flood, if you want to collaborate by enabling this feature to send the list only in a private message to the user you can check the code at https://github.com/Elive/keyra-bot"
                if
                    @keywords.size > 0
                    then
                    m.user.send `curl -F 'sprunge=<keywords.yaml' http://sprunge.us`
                    m.reply "Sent you the list of keywords in a private message!"
                else
                    m.reply "No keywords defined yet."
                end
            end

            def keyword_define(m, keyword, definition)
                if @keywords[keyword]
                    then m.reply "Redefining '#{keyword}' from: '#{@keywords[keyword]}' to: '#{definition}'."
                else m.reply "Defining '#{keyword}' with: '#{definition}'."
                end
                @keywords[keyword] = definition
                update_store
            end

            def keyword_check(m, keyword)
                if @keywords[keyword]
                    then m.reply "'#{keyword}' is defined as: '#{@keywords[keyword]}'."
                else m.reply "'#{keyword}' is not defined."
                end
            end

            def keyword_forget(m, keyword)
                if
                    @keywords[keyword]
                    then
                    m.reply "'#{keyword}' was defined as: '#{@keywords[keyword]}'."
                    @keywords.delete(keyword)
                    update_store
                else
                    m.reply "'#{keyword}' is not defined."
                end
            end

            def find_keyword(m)
                @keywords.each do |k,v|
                    Regexp.new(k, Regexp::IGNORECASE).match(m.message) do |r|
                        # give her some humanity
                        # this is supposed to say: ( words * 60 ) / words-per-minute, bigger is the last number and less is the wait: ((50 * 60) / 140) = 21; ((50 * 60) / 180 = 16
                        #delayed_answer = ( ( v.split.size * 60 ) / 140 ).to_f
                        #delayed_answer = ( ( v.split.size * 60 ) / 180 ).to_f
                        delayed_answer = ( ( v.split.size * 60 ) / 250 ).to_f
                        # add 2 more seconds of humanity
                        delayed_answer = delayed_answer + 2
                        #m.reply delayed_answer

                        # wait and...
                        sleep delayed_answer
                        # answer including nick (may be annoying)
                        #m.reply "#{m.user.nick}, " + v
                        # answer simple sentences, without hilight user nick

                        # say it unless its a registered said reply
                        unless @replys.include?(v)
                            m.reply v
                        end

                        # add the reply to an array list
                        @replys.push v
                        # and remove it automatically after a bit of time
                        Timer(300, shots: 1) {
                            @replys.delete v
                            #m.reply "removed answer: " + v
                        }
                    end
                end
                # The next code doesn't seems to answer if we have insert a regex, but the previous code does the job, thx graft
                    #Regexp.new(keyword).match(m.message)
                #}.compact.sort_by{|matchdata|
                    #matchdata.begin(0)
                #}.each{|matchdata|
                    #m.reply @keywords[matchdata[0]]
                #}
            end

            listen_to :channel
            def listen(m)
                case
                    m.message
                when /^!keywords/  # temporally disabled, in order to avoid flooding in the channel
                    keywords(m)
                when /^!keyword '([^']+)' (.+)$/, /^!keyword "([^"]+)" (.+)$/, /^!keyword (\S+) (.+)$/
                    keyword_define(m, $1, $2)
                when /^!keyword (\S+)$/, /^!keyword\? (.+)$/
                    keyword_check(m, $1)
                when /^!forget (.+)$/
                    keyword_forget(m, $1)
                else
                    find_keyword(m)
                end
            end

            def update_store
                synchronize(:update) do
                    File.open('keywords.yaml', 'w') do |fh|
                        YAML.dump(@keywords, fh)
                    end
                end
            end

        end
    end
end
