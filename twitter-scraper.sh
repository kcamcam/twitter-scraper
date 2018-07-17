#!/bin/sh
# Run thse first 6 lines to get the initial value of the max tweet id.
# Their functionality ia explained in the for loop.
printf "var trudeau0 = " >> json/trudeau0.js;
twurl "/1.1/statuses/user_timeline.json?screen_name=justinTrudeau&include_rts=false&count=200" >> json/trudeau0.js;
printf ";" >> json/trudeau0.js;
printf "\n" >> json/trudeau0.js;
printf "console.log( ( trudeau0[ trudeau0.length - 1].id) - 1 );" >> json/trudeau0.js;
MAXID="$(node json/trudeau0)";

# Loop 20 times, usually only need 15+/- though
for i in {1..20}
do
	# 	Print a JavaScript variable
	printf "var trudeau$i = " >> json/trudeau$i.js;

	# 	Twitter API call using twurl
	# 	Variables in the request are:
	#		screen_name= the screen name of the user (no @)
	#		include_rts= include retweets (true/false)
	#		count= tweets to request (200 max, including retweets) if only 151 get returned, that means there were 49 retweets
	#		max_id= return only tweets up to a max tweet_id  stored in the $MAXID variable
	twurl "/1.1/statuses/user_timeline.json?screen_name=justinTrudeau&include_rts=false&count=200&max_id=$MAXID" >> json/trudeau$i.js;

	# 	close the variable
	printf ";" >> json/trudeau$i.js;

	# 	skip a line
	printf "\n" >> json/trudeau$i.js;

	# 	write a console.log so that when you run node app later, it will display the ID of the last tweet minus 1
	printf "console.log( trudeau$i[trudeau$i.length-1].id - 1);" >> json/trudeau$i.js;

	#	store the value of the last tweet minus 1 in a variable for the next call
	MAXID="$(node json/trudeau$i)";
done
