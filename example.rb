require 'formerly'
require 'rubygems'
require 'fastercsv'
require 'ap'

lines = File.readlines("attiny2313_datasheet.txt")
form_array = Formerly.parse(lines, :tab_size => 4)
ap form_array
FasterCSV.open("output.csv", "w") do |csv|
  form_array.each do |form|
    form.each do |row|
      csv << row
    end
  end
end
