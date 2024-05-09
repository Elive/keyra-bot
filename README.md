Keyra Bot
=========

Fast, extremely light (7~ mb RAM), ruby (cinch) based, simply useful IRC bot which is meant to be a helpful tool for the end-user, answering its questions like a real human 

Its name comes from the old traditional "keyra" bot very known on the Elive channels, originally writed in perl by felix

Features
========

- **Automatic reply's** based on keywords (regex featured) that the people will say in the channel
  - these messages are saved in a (yaml) plain file, which is very easy and fast to add new ones but specially modify existing messages, which is extremely more efficient than dealing with the bot online, by other side anybody can add and modify its messages interactively too, which makes it useful to learn new things.

- **Reminders**: simple feature that reminds you about something after a given time, it also detects when somebody wants to have a reminder

- **Memo's**: It gives messages to users when they connects back into the channel

- **Scores**: Just a small plugin for give scores to the users



Run it!
=======

~~First you should install the required gems as user (recommended):~~
> ~~gem install cinch~~
    

**IMPORTANT**:  the actual version of cinch doesn't support ruby 3.0 or higher, so you must install an older version like **2.7** to make it running, this is a small recipe:
```
# rm -rf .local/share/gem/ .gem* .rvm*
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s
unset GEM_HOME
source ~/.rvm/scripts/rvm
sudo -H -n echo || rvm autolibs disable  # this is run if you don't have 'sudo' access on the server for your user
if ! rvm install 2.7 ; then
    mkdir -p ~/Downloads
    cd ~/Downloads
    wget https://www.openssl.org/source/openssl-1.1.1t.tar.gz
    tar zxvf openssl-1.1.1t.tar.gz
    cd openssl-1.1.1t
    ./config --prefix=$HOME/.openssl/openssl-1.1.1t --openssldir=$HOME/.openssl/openssl-1.1.1t
    make
    make install
    rm -rf ~/.openssl/openssl-1.1.1t/certs
    ln -s /etc/ssl/certs ~/.openssl/openssl-1.1.1t/certs
    rvm reinstall ruby-2.7 --with-openssl-dir=$HOME/.openssl/openssl-1.1.1t
fi
gem install cinch cinch-yaml-keywords
```

You may optionally install other dependencies too like ruby-yaml

Also you need an *account.yaml* file in the keyra-bot/database directory with similar contents:

    ---
    user: keyra
    pass: SECRET
    server: irc.freenode.net

Then just run the scripts/ for each purpose


How to use:
===========


Automatic Reply's
-----------------
This feature is very simple and doesn't require to call the bot at all, if somebody says a word that is listed on his database, which you can add/modify entries manually editing the file (requires restart) or interactively from the bot channel, the bot will answer what you need to know about.

The database is stored in a plain-text yaml file, which is saved among restarts and ages

Example:

    <Elive_user2> Where i can get the experimental beta installer???
    <keyra> this beta installer is already finished, you should download a newer version of Elive which you can directly install

Interactive commands:

    !keywords                         # list all definitions
    !keyword? <keyword>               # show single definition
    !keyword  <keyword>  <definition> # define without spaces
    !keyword '<keyword>' <definition> # define with spaces
    !keyword "<keyword>" <definition> # define with spaces
    !forget   <keyword>               # remove definition
    <keyword>                         # display definition

Much suggested is to use regex for the matches, so that an user saying **beta installer** or **installer beta** would work. There's some examples:

    # will accept "beta installer" or "experimental installer"
    (beta|experimental) installer:   the new installer is ready!

    # accepts "installer" or "instaler"
    instal(l?)er:   the installer r00lz!

    # accepts words in any order: "beta installer of elive", "installer beta of elive", "of elive beta installer":
    (?=.*beta)(?=.*installer).*of elive:   the installer of elive is the best one!

    # if you need to add entries wich includes the ":" colon char, make sure to quote it with also !, like:
    test: ! 'result with a : colon char'

*Bonus*: It is much more friendly and fast to modify the entries or adding new ones directly in an editor, the database is a plain file and you can edit it manually, after you have finished, you just need to reload the plugin with '!plugin reload YamlKeywords', this is an unique feature that no other bots probably has :)


Memos to other users
--------------------
Simple as this:

    <Thanatermesis> !memo princeamd when you come back tell me about your last features!
            <keyra> Ok, I'll notify princeamd when (s)he enters the channel!
                    --> princeamd enters in the channel
            <keyra> princeamd, memo for you: <Thanatermesis/#elive-dev/2014-08-26 15:49>  when you come back tell me about your last features!


And the message will be passed to princeamd the next time he connects back

Reminders
---------
This is an example:

    [21:30:01] <Thanatermesis> remind me about pizza! in 1 min
    [21:30:02]        <keyra2> Thanatermesis: don't worry! I will remind you about "pizza!" in 1 min
    [21:31:01]        <keyra2> Thanatermesis: pizza!

The bot will take care of that for you and will tell you want you need to remember when the time has passed
You can use a very english language that it should understand it, for example:

    hey john, can you remind me about my pizza is going to burn in 1 hour ?

The 'regex' syntax that you can use is something like:

    /(.*)remind (us|me|#[^ ]*) (?:about|to|that) (.*) (?:(in) ([0-9]+) (min(?:ute(s|)|s)?|hour(?:s)?))/i

Note: the reminders are not saved in any database, if the bot restarts, they will be forgotten

Scores
------
Just a small and funny plugin for motivate the users:

    <thanatermesis> princeamd +1
            <keyra> princeamd actual score is 69!

Plugin Management
-----------------
You can also unload / load / reload bot plugins with the command:

    !plugin reload YamlKeywords

This is extremely useful for development, if you dont want to restart the bot everytime which is very slow


Collaborate
-----------
You are more than welcome to fork the bot and improve it, if this doesn't change his behaviour or the resources needed I should not have any problem to pull the requests :)

Credits
-------
This plugin is made mostly from other's code, cinch and cinch plugins, specially from mpapis user, thanks to all of them
I have put all the plugins inside a single git tree without tracking the original sources since they are meant to be complete or simply useful, for simplicity, time, and ability to modify things more easly
