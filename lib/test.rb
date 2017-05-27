arr = []
File.readlines("dictionary.txt").each do |line|
  arr << line
end
puts arr
puts arr.class
puts arr[25211]
