class Commander
	include Cinch::Plugin
	
	match /join (.+)/, method: "join"
	match /part (.+)/, method: "part"
	match /rename (.+)/, method: "rename"
	match /irc (.+)/, method: "new_irc"
	match "channels", method: "channels"
	
	def join(m, channel)
		if authorized?(m)
			m.bot.join(channel)
			m.reply "Success."
		end
	end
	
	def part(m, channel)
		if authorized?(m)
			m.bot.part(channel, reason = "ordered by #{m.user.nick}")
		end
	end
	
	def rename(m, new_name)
		if authorized?(m)
			m.bot.nick = new_name
			m.reply "I changed my name to #{new_name}!"
		end
	end
	
	def new_irc(m, addr)
		
	end
	
	def channels(m)
		if authorized?(m)
			m.reply m.bot.channels
		end
	end
	
	
	def authorized?(m)
		@authorized_users = ["p137", "adrian17", "daaave", "shibu", "Ivarpe", "Kono_Dio_da", "Salem"]
		return true if @authorized_users.include? m.user.nick or m.user.opped?
		return false
	end
end