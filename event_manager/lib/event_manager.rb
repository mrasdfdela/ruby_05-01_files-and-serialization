puts "EventManager Initialized!"

if File.exist? "event_attendees.csv"
  # contents = File.read "event_attendees.csv"
  # puts contents

  lines = File.readlines "event_attendees.csv"
  lines.each_with_index do |line, idx|
    next if idx == 0
    columns = line.split(",")
    # puts line
    name = columns[2]
    puts name
  end
end