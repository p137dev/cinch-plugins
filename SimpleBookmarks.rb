 # SimpleBookmarks - a plugin for adding and looking up bookmarks. Doesn't really check if a link is correct & reads the file line by line (the link DB can be long, so I won't be slurping it).

class SimpleBookmarks
	include Cinch::Plugin
	
	match /bookmark (.+) (.+)/, method: :add
	match /lookup (.+)/, method: :lookup
	
	def add(m, name, link)
		bookmarkfile = File.open('bookmarks.db', 'a')
		bookmarkfile << "\n#{name}, #{link}"
		bookmarkfile.close
		m.reply "#{m.user.nick}: bookmark added."
	end
	
	def lookup(m, name)
		bookmarkfile = File.open('bookmarks.db', 'r')
		debug "File opened, initializing search..."
		bookmarkfile.each_line do |line|
			entry = line.chomp.split(", ")
			debug "Current entry: #{entry[0]} is #{entry[1]}"
			if entry[0] == name
				m.reply "#{m.user.nick}: Bookmark for #{entry[0]} is #{entry[1]}."
				@found_bookmark = true
			end
		end
		m.reply "#{m.user.nick}: bookmark not found." unless @found_bookmark
		@found_bookmark = false
		bookmarkfile.close
	end
	
end
