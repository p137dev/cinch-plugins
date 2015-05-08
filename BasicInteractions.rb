class BasicInteractions
	include Cinch::Plugin
	
	match "ping", method: :ping
	match "die", method: :die
	match "roulette", method: :roulette
	
	def ping(m)
		m.reply "pong"
	end
	
	def roulette(m)
		roll = rand(1..100)
		if roll > 40 and roll < 80
			m.channel.kick(m.user, reason = roll)
			m.reply "*bang*"
		else
			m.reply "#{m.user.nick}: you survived (#{roll})"
		end
	end
	
	def die(m)
		m.channel.kick(m.user, reason = "go awai") unless m.user.name == "your_name_goes_here"
	end
	
end