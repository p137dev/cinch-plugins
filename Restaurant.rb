# Restaurant - a plugin for maintaining local restaurant dishes. Loads the dishes into the memory, because the DB is not really long.

class Restaurant
	include Cinch::Plugin
	
	match /dish (.+)/, method: :search
	match /add (.+) (\d+\.\d+)/, method: :add
	match 'random_dish', method: :random_dish
	match 'hours', method: :hours
	match 'load', method: :load_dishes
	
	def search(m, dish_name)
		unless $dishes[dish_name].nil?
			m.reply "#{m.user.nick}: #{dish_name} costs #{$dishes[dish_name]}."
		else
			m.reply "#{m.user.nick}: there is no such dish :("
		end
	end
	
	def load_dishes(m)
		dishreload
	end
	
	def add(m, dish_name, dish_value)
		restaurantdb = File.open('restaurant.db', 'a')
		restaurantdb << "\n#{dish_name}, #{dish_value}"
		m.reply "Appended new entry: #{dish_name} costing #{dish_value}"
		restaurantdb.close
		dishreload
	end
	
	def random_dish(m)
		temp = $dishes.keys
		temp_selection = temp[rand(temp.size)]
		m.reply "#{m.user.nick}: a random dish for you is #{temp_selection} costing #{$dishes[temp_selection]}"
	end
	
	def hours(m)
		@restaurant_name = "Sample-Restaurant"
		@hour_open_regular = [10, 21]
		@hour_open_weekend = [12, 20]
		if Time.now.sunday? or Time.now.saturday?
			if Time.now.hour >= @hour_open_weekend[0] and Time.now.hour <= @hour_open_weekend[1]
				m.reply "#{@restaurant_name} is open. The opening hours are #{@hour_open_weekend[0]} to #{@hour_open_weekend[1]}."
			else
				m.reply "#{@restaurant_name} is closed."
			end
		else
			if Time.now.hour >= @hour_open_regular[0] and Time.now.hour <= @hour_open_regular[1]
				m.reply "#{@restaurant_name} is open. The opening hours are #{@hour_open_regular[0]} to #{@hour_open_regular[1]}."
			else
				m.reply "#{@restaurant_name} is closed."
			end
		end
	end
	
end

# dishreload - a function used by Dish::Add and Dish::Load

def dishreload
	$dishes.clear
	restaurantdb = IO.readlines('restaurant.db')
	restaurantdb.each do |line|
		temp = line.chomp.split(", ").to_a
		$dishes[temp[0]] = temp[1]
	end
	m.reply "Loaded."
end

# A hash of the dishes.
$dishes = Hash.new