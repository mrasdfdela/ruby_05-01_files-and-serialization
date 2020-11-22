require 'byebug'

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody'])
    legislators = legislators.officials
    legislator_names = legislators.map(&:name).join(", ")
  rescue
    "You can find your represenatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
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
  "(#{area_cd})#{exc_cd}-#{subscriber}"
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"
  filename = "output/thanks_#{id}.html"
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end
puts "EventManager initialized."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phone = clean_phone_number(row[:homephone])
  # puts "#{name}, #{zipcode}: #{legislators}"
  # personal_letter = template_letter.gsub!('FIRST_NAME', name)
  # personal_letter = template_letter.gsub!('LEGISLATORS', name)
  # puts personal_letter
  form_letter = erb_template.result(binding)
  save_thank_you_letter(id,form_letter)
end