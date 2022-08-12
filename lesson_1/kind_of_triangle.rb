print "First side count? "
a = gets.chomp.to_i 
print "Second side count? "
b = gets.chomp.to_i 
print "Third side count? "
c = gets.chomp.to_i 

def kind_of_triangle(a, b, c)
  if a > b && a > c 
    puts "Это прямоугольный труегольник" if a ** 2 == b ** 2 + c ** 2
    return 1
  elsif b > a && b > c 
    puts "Это прямоугольный труегольник" if b ** 2 == a ** 2 + c ** 2
    return 1
  else
    if c ** 2 == a ** 2 + b ** 2
      puts "Это прямоугольный труегольник" 
      return 1
    end
  end
end


if a == b || a == c || b == c
  if a == b && a == c
    puts "Это равносторонний треугольник"
  else
    puts "Это равнобедренный треугольник"
    kind_of_triangle(a, b, c)
  end
else
  puts "Это произвольный треугольник" unless kind_of_triangle(a, b, c)
end
