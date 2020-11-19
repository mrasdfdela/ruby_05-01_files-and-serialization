require "byebug"
require "csv"

puts "EventManager Initialized!"

def zip_code_converter(code)
  # code = "" if code.nil?
  # code = code[0..4] if code.length > 5
  # until code.length == 5
  #   code = "0" + code
  # end
  # return code
  code.to_s.rjust(5,"0")[0..4] #Coercion over questions
end

if File.exist? "event_attendees.csv"
  contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
  contents.each do |row|
    name = row[:first_name]
    zipcode = zip_code_converter(row[:zipcode])

    puts "#{name}, #{zipcode}"
  end
end