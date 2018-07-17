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
console.log("\n")
console.log("Total tweets from Trudeau 🇨🇦: " + trudeau.length);
console.log("Most Recent: " + trudeau0[0].text);
console.log("Tweeted on:" +trudeau0[0].created_at);
console.log("Oldest: " + trudeau17[0].text);
console.log("Tweeted on:" +trudeau17[0].created_at);

getTweets("trump");
console.log("\n")
console.log("Total tweets from Trump 🇺🇸: " + trump.length);
console.log("Most Recent: " + trump0[0].text);
console.log("Tweeted on:" +trump0[0].created_at);
console.log("Oldest: " + trump17[0].text);
console.log("Tweeted on:" +trump17[0].created_at);

let trumpString = JSON.stringify(trump);
console.log(trumpString);
let trudeauString = JSON.stringify(trudeau);
console.log(trudeauString);
