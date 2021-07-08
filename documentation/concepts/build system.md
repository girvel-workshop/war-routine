war-routine$ game tests
run tests
if errors
	show them
return !errors



war-routine$ game run
if game tests
	ask for exit
run game



war-routine$ game release
if !game tests
	stop
update version
game commit "Release $VERSION"
>>> release text (in micro)
create release w/ release text, windows & linux executables



war-routine$ game commit <message>
if !game tests
	ask for exit
construct binaries
git add .
git commit -m "<message>"
git push origin master
