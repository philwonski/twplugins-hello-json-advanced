# HelloJson-Advanced

HelloJson-Advanced is a template for creating [TiddlyWiki](https://tiddlywiki.com) plugins, building on the basic concepts of the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo.

Both repos represent the same opinionated workflow for developing TiddlyWiki plugins. It's just a *file structure* with 3 levels and some style conventions. 

You can see a demo of the adanced plugin in action [here](https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover). Jump to the [Examples](#examples) section below to see some of the cool possibilities.

# Why?

This setup serves me well whenever I'm building alternative user interfaces for tools like Salesforce, Airtable, Quickbooks, and Wordpress.

Please see the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo for a more detailed explanation of the motivation behind this approach. The Advanced repo you're in now is intended to get you right into hard examples.

# How?

Refer again to the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo for a brief explanation of how I leverage ChatGPT and NPM packages to supercharge my own development of all kinds of plugins using this structure.

Over time I will add examples to this and related repos so folks can have working demos to get started.

In short, the basic structure starts with just 3 files:

1. `hj.js` - the main plugin file that's (almost) straight from the TiddlyWiki plugin boilerplate 
2. `classHeyJson.js` - required inside the `hj.js` file, it has the cool methods like `fetch(url)`
3. `helper-fetcher.js` - our first helper file, which abstracts a GET request and keeps the class file clean

# This Repo

This repo is intended to house various examples of bringing cool helpers and libraries into TiddlyWiki to do different stuff. 

In comparing it to the basic repo, a good place to start is the "hangover" command featured in the both repos. See it in action [in the basic repo here](https://philwonski.github.io/twplugins-hello-json/#heyJay-test) vs [in this advanced repo here](https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover). 

Back in the code, note some new stuff the Hangover command has here in the advanced repo:

1. **THE BUTTON:** The actions of the `hangover` command no longer live in the EXECUTE function block of the main plugin file `hj.js`. Instead, the hangover steps live inside the INVOKE block, meaning the steps get invoked on an action in the frontend... In this case the frontend action is a button you can click when viewing the `test-hangover` tiddler in the demo. 

2. **THE PARAMS:** The `hangover` command accepts two different days as params now, `<$hellojson command="hangover" day1="20200101" day2="20230101"/>`, allowing you to compare the number of views for the Hangover wikipedia page on two different days.

3. **THE STYLE:** The code running the `hangover` command in `hj.js` is much shorter now: that's because we've abstracted the code for doing that little routine into a method of the HeyJson class called `runFetchHangoverCompare`. That's the idea here: A) keep the main plugin file clean and simple by abstracting business logic to the class file; B) keep the class file neat and human-readable by abstracting harder stuff into helper files required in the class file (and by using coffeescript).

4. **THE MAGIC:** Open `files/classHeyJson.coffee`. Note how elegantly the `runFetchHangoverCompare` method calls another method in the class called `twMakeTid`. This is where things really start to get interesting: instead of just displaying text like the basic hello-json widget, now we are actually calling upon TiddlyWiki functionality and creating a tiddler in our wiki. **This opens up a world of possibilities for ingesting remote data into TiddlyWiki and doing things with it.** 

# Setup & Usage

I set up my dev environment exactly like the instructions here: 

[https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub](https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub)

It may seem like a bunch of steps, but the build process is very logical once you get the hang of it. It can be boiled down to this:

1. Make a folder on your computer called TWdev (or whatever you want). This is where you will keep all your plugins that you work on.

2. Inside the new directory, install a local copy of TW5 with `git clone https://github.com/Jermolene/TiddlyWiki5.git TW5`.

3. Now you can see the TW5 directory has two important folders: `/editions` and `/plugins`. All we are doing is:
    1. Adding our own plugin code under plugins.
    2. Picking an edition, like `TW5/editions/empty`, and adding a quick reference to our plugin in the `tiddlywiki.info` file.
    3. Running a single command *in the TW5 folder* to build that particular edition with our plugin included, like `node ./tiddlywiki.js editions/empty --build index`... this will create a static html version of the wiki you can view and share. Find the static file in the the `output` folder under the edition you just built.

So the top of my file `TWdev/TW5/editions/empty/tiddlywiki.info` now looks like this:

```
{
	"description": "Empty edition",
	"plugins": [
		"philwonski/twplugins-hello-json-advanced"
	],

```

And I can generate a static html version of the wiki, with my plugin included, by running this command in the TW5 folder: `node ./tiddlywiki.js editions/empty --build index` and then opening the file `...TWdev/TW5/editions/empty/output/index.html#test-hangover` in my browser.

If you modify the class file, remember to compile the updated javascript file with `coffee -c classHeyJson.coffee` from the /files folder.

## Coffeescript

Make fun of me all you want, I get a ton of mileage out of Coffeescript for all types of javascript dev. I use VSCode and the "CoffeeScript Preview" plugin by Drew Barrett. I just write my code in Coffeescript and then compile it to javascript with a single command `coffee -c classHeyJson.coffee` from the /files folder.

# EXAMPLES

## 1. Hangover

*Purpose*

Compare the number of views for the Hangover wikipedia page on two different days. This is a simple example that builds on the basic [HelloJson](https://github.com/philwonski/twplugins-hello-json) plugin upon which this repo is based.

*Usage*

`<$hellojson command="hangover" day1="20200101" day2="20230101"/>`

*Demo*

[https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover](https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover)

## 2. WPAPI (aka Wordpress Remote)

*Purpose*

Interact with a remote Wordpress site using the built-in Wordpress REST API (no Wordpress plugins needed). This concept is forked and expanded upon in [TW5-Wordpress-Remote](https://github.com/philwonski/TW5-Wordpress-Remote)

*Usage*

You can put most any wordpress site in the `wpsite` param, but the site must have the Wordpress REST API enabled.

`<$hellojson command="wpapi" wpaction="getposts" wpsite="mydigitalmark.com"/>`

*Demo*

[https://philwonski.github.io/twplugins-hello-json-advanced/#test-wpapi](https://philwonski.github.io/twplugins-hello-json-advanced/#test-wpapi)

*More Info*

This example greatly reduces the code required to interact with a Wordpress site and database. It gives you the ability to build alternative backends for Wordpress sites using TiddlyWiki; or, on the other hand, you could also use it to build backends for *TiddlyWiki* sites using headless Wordpress. 🤯

Getting posts in the main plugin file is as simple as calling a special method in the class file: `runFetchWpPosts()`. That method is pre-set to grab 5 posts from page 1 and load each post into your wiki as a tiddler. Nice.

```
// from the main plugin file hj.js

if (ACTION == "getposts") {
        var heyJson = new HeyJson();
        await heyJson.runFetchWpPosts(WPsite);
        var msg = "got posts, check for new tiddlers with post id in title";
      }
```

The HeyJson class file and its `runFetchWpPosts` method just *require*, *initiate* and *await* the minified [WPAPI NPM library](https://www.npmjs.com/package/wpapi). This way, all the NPM library methods are available to you in the class file and you can do things like this:

```
posts = await site.post().perPage( 5 ).page( 1 ).get()
```

BOOM!

## 3. SendTids

*Purpose*

For sending JSON tids out to a remote endpoint. 

*Usage*

`<$hellojson command="sendtids" endpoint="https://myendpoint.com" filter="[tag[example]]"/>`

*Demo*

[https://philwonski.github.io/twplugins-hello-json-advanced/#test-sendtids](https://philwonski.github.io/twplugins-hello-json-advanced/#test-sendtids)

*More Info*

Inspired by [OokTech](https://github.com/OokTech), this example grabs tiddlers by the user-provided filter, and sends them out as JSON to your URL. Importantly, it also updates the tiddlers that were sent, marking the field "SENTyn" to "yes." 

Thanks to OokTech I have been using this approach successfully for 2 years to POST data out of TiddlyWiki to remote servers... usually I just use a single-file js macro a la [this gist](https://gist.github.com/philwonski/1a015b555ac8b858c2949d7940ca8880) ... I have slapped it into the HelloJson repo for convenience. 

Note that if you send a shadow tiddler with your filter (as I have with my filter `[tag[example]]`, which are all shadows), you won't see the update to the tiddler's SENTyn field. You may not notice this since you have to open the tiddler (and thus make it non-shadow) to add your own endpoint. 

## 3. AI-Reply (OpenAI)

*Purpose*

For sending a simple ask-reply request to an OpenAI model. 

*Usage*

`<$hellojson command="ai-reply" prompt="prompt1" creds="creds1"/>`

- Where `prompt1` is the name of a tiddler containing the prompt, model, and optional system message.
- Where `creds1` is the name of a tiddler containing your OpenAI API key.

*Demo*

[https://philwonski.github.io/twplugins-hello-json-advanced/#test-openai](https://philwonski.github.io/twplugins-hello-json-advanced/#test-openai)

*More Info*

This is a simple POC I will use to demonstrate other OpenAI tie-ins to TiddlyWiki. In this case, the widget only handles a single call and a single response -- but the Chat Completions API can easily handle an array of prompts instead, such as from a conversation. In TiddlyWiki, we can handle this array in the frontend Wikitext using the "Journal" tiddlers concept. This makes a full chatbot experience possible in TiddlyWiki. 

// LangchainWiki // 

Personally I am less interested in TiddlyWiki as a Chat-GPT clone, and more interested in ingesting and processing data with TiddlyWiki. In this way, we can use the built-in TiddlyWiki tools for storing, retrieving and manipulating data to create Langchain-style operations, meaning making successive calls to the AI and processing the results.

