# homework 1
months = {
	january: 31,
	february: 28,
	march: 31,
	april: 30,
	may: 31,
	june: 30,
	july: 31,
	august: 31,
	september: 30,
	october: 31,
	november: 30,
	december: 31
}
months.each {|m, days| puts "In #{m} - #{days} days" if days == 30}

# # homework 2

# my_array = []
# for i in 10..100
# 	my_array.push(i) if i % 5 == 0
# end

# # homework 3

# my_array = [0,1]
# while my_array.last <= 100
# 	my_array.push(my_array.last + my_array[-2])
# end

# # homework 4
# vowels_letters = 'aeiuy'
# my_hash = Hash.new
# letters = ('a'..'z').to_a
# for i in 0..25
# 	my_hash[letters[i].to_sym] = (i + 1).to_i if vowels_letters.include?(letters[i])
# end

# homework 5

def leap_year?(year) 
	if year % 4 == 0 
		if year % 100 == 0 
			if year % 400 == 0
				return true
			else
				return false
			end
		else
			return true
		end
	else
		return false
	end
end

puts "Введите день: "
day = gets.chomp.to_i
puts "Введите месяц: "
month = gets.chomp.to_i
puts "Введите год: "
year = gets.chomp.to_i

months[:february] = 29 if leap_year?(year)

what_the_day = day

days_in_month_array = months.values

(month - 1).times do |i|
	what_the_day = what_the_day + days_in_month_array[i]
end

puts "#{day}.#{month}.#{year} - это #{what_the_day}й день в году"
