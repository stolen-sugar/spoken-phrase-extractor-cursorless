require 'csv'
require 'json'

file = "cursorless-settings/actions99.csv"

begin
  actions = CSV.read(file);  

  actions = actions.slice(1, actions.size)

  puts actions
rescue Errno::ENOENT
  puts "file: #{file} not found"
end

# cd ~/.talon/user
# git clone https://github.com/cursorless-dev/cursorless-talon.git cursorless-talon