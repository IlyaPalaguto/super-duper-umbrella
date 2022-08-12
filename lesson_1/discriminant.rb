puts "Введите три значения по порядку "
a = gets.chomp.to_i
b = gets.chomp.to_i
c = gets.chomp.to_i

d = b ** 2 - 4 * a * c 

if d >= 0 
  x1 = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)
  puts "Дискриминант равен #{d} \n x1 = #{x1}, \n x2 = #{x2}"
else
  puts "Дискриминант равен #{d}"
end