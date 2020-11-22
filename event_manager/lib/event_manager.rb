require "byebug"
require "csv"

require "date"
require "time"

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

def clean_phone_number(phone)
  phone = phone.to_s.split('')
  phone.delete_if { |char| false if Float(char) rescue true }
  phone.shift if phone[0] == 1.to_s

  phone.length == 10 ? format_phone(phone.join('')) : 'Invalid phone number'
end
def format_phone(phone)
  area_cd = "#{phone[0..2]}"
  exc_cd = "#{phone[3..5]}"
  subscriber = "#{phone[6..9]}"
  "(#{area_cd}) #{exc_cd}-#{subscriber}"
end

def hour_counter(count, date)
  count[date.hour] ? count[date.hour] += 1 : count[date.hour] = 1
end

def dow_counter(count, date)
  count[date.wday] ? count[date.wday] += 1 : count[date.wday] = 1
end

if File.exist? "event_attendees.csv"
  contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
  hour_count = {}
  dow_count = {}
  contents.each do |row|
    name = row[:first_name]
    zipcode = zip_code_converter(row[:zipcode])
    phone_number = clean_phone_number(row[:homephone])
    reg_date = DateTime.strptime(row[:regdate], '%m/%d/%y %k: %M')

    hour_counter(hour_count, reg_date)
    dow_counter(dow_count, reg_date)

    puts "#{name}, #{zipcode}, #{phone_number}, #{reg_date.hour}"
  end
  puts hour_count.sort_by{ |k,v| -v}.to_h
  puts dow_count.sort_by{ |k,v| -v}.to_h
end