print "What's your name? "
name = gets.chomp
print "What's your height? "
height = gets.chomp.to_i

def ideal_weight(height) 
  ideal_weight = (height - 110) * 1.15
end

if ideal_weight(height) > 0
  puts "Hi, #{name}, your ideal weight is - #{ideal_weight(height)}"
else
  puts "#{name}, you are so cute, anyway ;)"
end