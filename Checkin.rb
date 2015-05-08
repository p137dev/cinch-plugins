# Checkin - a plugin for checking in various places. Other users can check where you last checked in.

class Checkin
	include Cinch::Plugin
	
	match /checkin (.+)/, method: :checkin
	match /whereis (.+)/, method: :whereis
	match "whereami", method: :whereami
	
	def checkin(m, place)
		$checkins[m.user.nick] = [place, Time.now]
		m.reply "Checked in."
	end
	
	def whereis(m, person)
		person = person.strip
		if $checkins[person]
			m.reply "#{m.user.nick}: #{person}'s last updated location was: #{$checkins[person][0]} at #{$checkins[person][1]}."
		else
			m.reply "#{m.user.nick}: There are no checkins for that person yet."
		end
	end
	
	def whereami(m)
		m.reply "#{m.user.nick}: Your last location was: #{$checkins[m.user.nick][0]} at #{$checkins[m.user.nick][1]}"
	end
	
end

# The checkins hash.
$checkins = Hash.new