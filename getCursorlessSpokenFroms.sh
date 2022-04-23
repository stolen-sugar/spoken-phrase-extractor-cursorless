# restart Talon
osascript -e 'quit app "Talon"'
open -a "Talon"


# create a copy of user folder to hold temporarily
rm -fr ~/.talon/user-copy
cp -r ~/.talon/user user-copy

# remove cursorless from user
rm -fr ~/.talon/user/cursorless-talon
rm -fr ~/.talon/user/ron_talon/cursorless-settings
rm -fr ~/.talon/user/cursorless-settings

# clone cursorless-talon
git clone https://github.com/cursorless-dev/cursorless-talon.git cursorless-talon

# ruby magic
ruby getCursorlessDefaults.rb


# bring back the user folder
rm -fr user
mv user-copy user 


# restart Talon
osascript -e 'quit app "Talon"'
open -a "Talon"
