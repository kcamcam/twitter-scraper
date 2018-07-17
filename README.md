## INFO
The following is a guide and script for a twitter scraper using the The Twitter API, Twurl, and Node. After scouring the internet for an easy solution and many failed attempts I decided to make one. The script will scrape through a twitter user's profile and store them in 20.json files, each file holding a json object of up to 200 tweets. You can then write a simple scrip in JavaScript to extract the tweets from the JSON objects. The example below extracts the last 3200 tweets from [@realDonaldTrump](https://twitter.com/realDonaldTrump).  
**Note**: The API only allows for the [last 3200 tweets](https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-user_timeline) from a users timeline.

See the [Twitter API Docs](https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-user_timeline) for more information.  
The full [github repo](https://github.com/kcamcam/twitter-scraper).

> **PS**: If you're interested, the reason I created this was for a [web app](https://kcamel.com/twitter-author) I am making using [Brain.js](https://github.com/brainJS), a neural network written in javascript. I trained a neural network with tweets to verify if a tweet was writen by President Trump or Prime Minister Trudeau. I could only bare to copy and paste the last 50 tweets from each author and the results were good, but I wanted better. Thus, came the need for more data!
>
>[**Twiter-Author**](https://kcamel.com/twitter-author)  

## Required   
Linux or macOS  
[Twurl](https://github.com/twitter/twurl) `$ brew install twurl`  
[Node](https://nodejs.org/en/download/) `$ brew install node`  
[Twitter Dev Account](https://apps.twitter.com/new)


## Twurl  
Open up terminal run:  
`$ twurl authorize --consumer-key [KEY] --consumer-secret [SECRET]`  
Replace [KEY] and [SECRET ]with your consumer-key and consumer-secret respectively. Your *consumer-key* and *consumer-secret* can be found at [apps.twitter.com](https://apps.twitter.com/) under *Keys and Acces tokens*  

**NOTE:** keep your consumer secret **SECRET** never publish it anywhere, especially not online.  

You will then be prompted with a link to copy and paste into your browser. This is just to authenticate you into the twitter API.  
Copy and paste the given code into your terminal.   
👍 You should now be authenticated into twurl.

If you get stuck click [here](https://developer.twitter.com/en/docs/tutorials/using-twurl.html) for instructions on getting Twurl set up.


## Getting Started
Open up terminal
`cd into/the/directory/of your porject`  

``` bash
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
```  

🎈All done  
You should now have 20 json files each holding a json objects full of Donald Trump nonesense 🎉  


## Converting the Data
Create an `index,html` file to read through all of your trump/trudeau JS files which should be stored in `/json/dataN.js`.   

``` html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>
  </head>
  <body>
    <!-- Im sure there's an easier way to do this -->
    <script src="json/trudeau0.js"></script>
		...
    <script src="json/trudeau17.js"></script>
    <script src="json/trump0.js"></script>
		...
    <script src="json/trump17.js"></script>
    <script src="jsonify.js"></script>
  </body>
</html>
```
Create a `jsonify.js` file and leave it in the same directory as your index.html.

``` javascript
let trudeau = [];
let trump = [];

// get tweets from "trudeau" or "trump"
function getTweets(name){
  let i = 0;
  for (i ; i <= 17 ; i++) {
    let varName = eval(name+i);
    let j = 0;
    for (j = 0; j < varName.length ; j++){
      // normalize text to Extended ASCII 255, removing emojis
      let text = varName[j].text.replace(/[^\x00-\xFF]/g, "");
      //format the output to JSON notation [{input: "American President", output: {trump: 1}}, ...]
      let input = text;
      let output
      if (name == "trump"){
        output = {trump : 1};
      }else if(name == "trudeau"){
        output = {trudeau : 1};
      }
      let result = {input, output};
      //push the JSONafied text into the array
      eval(name).push(result);
    }
  }
}
getTweets("trudeau");
getTweets("trump");

let trumpString = JSON.stringify(trump);
console.log(trumpString);
let trudeauString = JSON.stringify(trump);
console.log(trudeauString);

```  

🎉 Open your index.html file in browser and you should have 2 beautiful looking JSON arrays holding your tweets, ready to be trained by [brain.js](https://github.com/brainJS).  

by [Kevin Camellini](https://kcamel.com)
