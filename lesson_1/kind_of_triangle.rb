print "First side count? "
a = gets.chomp.to_i 
print "Second side count? "
b = gets.chomp.to_i 
print "Third side count? "
c = gets.chomp.to_i 


def rectangular?(a, b, c)
  return true if a ** 2 == b ** 2 + c ** 2
  return true if b ** 2 == a ** 2 + c ** 2
  return true if c ** 2 == b ** 2 + a ** 2
end

if a == b || a == c || b == c
  if a == b && a == c
    puts "Это равносторонний треугольник"
  else
    if rectangular?(a,b,c)
      puts "Это равнобедренный и прямоугольный треугольник"
    else
      puts "Это равнобедренный треугольник"
    end
  end
else
  if rectangular?(a,b,c)
    puts "Это прямоугольный треугольник"
  else
    puts "Это произвольный треугольник"
  end
end
