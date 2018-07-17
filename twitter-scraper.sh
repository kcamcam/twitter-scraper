#!/bin/sh
# Run thse first 6 lines to get the initial value of the max tweet id.
# Their functionality ia explained in the for loop.
printf "var trump0 = " >> json/trump0.js;
twurl "/1.1/statuses/user_timeline.json?screen_name=realDonaldTrump&include_rts=false&count=200" >> json/trump0.js;
printf ";" >> json/trump0.js;
printf "\n" >> json/trump0.js;
printf "console.log( ( trump0[ trump0.length - 1].id) - 1 );" >> json/trump0.js;
MAXID="$(node json/trump0)";

# Loop 20 times, usually only need 15+/- though
for i in {1..20}
do
	# 	Print a JavaScript variable
	printf "var trump$i = " >> json/trump$i.js;

	# 	Twitter API call using twurl
	# 	Variables in the request are:
	#		screen_name= the screen name of the user (no @)
	#		include_rts= include retweets (true/false)
	#		count= tweets to request (200 max, including retweets) if only 151 get returned, that means there were 49 retweets
	#		max_id= return only tweets up to a max tweet_id  stored in the $MAXID variable
	twurl "/1.1/statuses/user_timeline.json?screen_name=realDonaldTrump&include_rts=false&count=200&max_id=$MAXID" >> json/trump$i.js;

	# 	close the variable
	printf ";" >> json/trump$i.js;

	# 	skip a line
	printf "\n" >> json/trump$i.js;

	# 	write a console.log so that when you run node app later, it will display the ID of the last tweet minus 1
	printf "console.log( trump$i[trump$i.length-1].id - 1);" >> json/trump$i.js;

	#	store the value of the last tweet minus 1 in a variable for the next call
	MAXID="$(node json/trump$i)";
done
