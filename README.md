# HelloJson-Advanced

HelloJson-Advanced is a template for creating TiddlyWiki plugins, building on the basic concepts of the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo.

Both repos represent the same opinionated workflow for developing TiddlyWiki plugins. It's just a *file structure* with 3 levels and some style conventions. 

You can see a demo of the adanced plugin in action [here](https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover).

# Why?

This setup serves me well whenever I'm building alternative user interfaces for tools like Salesforce, Airtable, Quickbooks, and Wordpress.

Please see the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo for a more detailed explanation of the motivation behind this approach. This Advanced repo is intended to get you right into hard examples.

# How?

Refer again to the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo for a brief explanation of how to I leverage ChatGPT and NPM packages to supercharge my own development of all kinds of plugins using this structure.

Over time I will add examples to this and related repos so folks can have working demos to get started.

In short, the basic structure starts with just 3 files:

1. `hj.js` - the main plugin file that's (almost) straight from the TiddlyWiki plugin boilerplate 
2. `classHeyJson.js` - required inside the `hj.js` file, it has the cool methods like `fetch(url)`
3. `fetcher.js` - our first helper file, which abstracts a GET request and keeps the class file clean

# This Repo

This repo is intended to house various examples of bringing cool helpers and libraries into TiddlyWiki to do different stuff. 

In comparing it to the basic repo, a good place to start is the "hangover" command featured in the basic repo. See it in action [in the basic repo here](https://philwonski.github.io/twplugins-hello-json/#heyJay-test) vs [in this advanced repo here](https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover). 

Back in the code, note some new stuff here in the advanced repo:

1. **THE BUTTON:** The actions of the `hangover` command no longer live in the EXECUTE function block of the main plugin file `hj.js`. Instead, the hangover steps live in the INVOKE block, meaning the steps get invoked on an action in the frontend... In this case the frontend action is a button you can click when viewing the `test-hangover` tiddler in the demo. 

2. **THE PARAMS:** The `hangover` command accepts two different days as params now, `<$hellojson command="hangover" day1="20200101" day2="20230101"/>`, allowing you to compare the number of views for the Hangover wikipedia page on two different days.

3. **THE STYLE:** The code running the `hangover` command in `hj.js` is much shorter now: that's because we've abstracted the code for doing that little routine into a method of the HeyJson class called `runFetchHangoverCompare`. That's the idea here: A) keep the main plugin file clean and simple by abstracting business logic to the class file; B) keep the class file neat and human-readable by using coffeescript and by abstracting harder stuff into helper files required by the class.

4. **THE MAGIC:** Open `files/classHeyJson.coffee`. Note how elegantly the `runFetchHangoverCompare` method calls another method in the class called `twMakeTid`. This is where things really start to get interesting: instead of just displaying text like the basic hello-json widget, now we are actually calling upon TiddlyWiki functionality and creating a tiddler in our wiki. **This opens up a world of possibilities for ingesting remote data into TiddlyWiki and doing things with it.** 

# Usage

I set up my dev environment exactly like the instructions here: 

[https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub](https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub)

It may seem like a bunch of steps, but the build process is very logical once you get the hang of it. It can be boiled down to this:

1. Make a folder on your computer called TWdev (or whatever you want). This is where you will keep all your plugins that you work on.

2. Inside the new directory, install a local copy of TW5 with `git clone https://github.com/Jermolene/TiddlyWiki5.git TW5`.

3. Now you can see the TW5 directory has two important folders: `editions` and `plugins`. All we are doing is:
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

## Coffeescript

Make fun of me all you want, I get a ton of mileage out of Coffeescript for all types of javascript dev. I use VSCode and the "CoffeeScript Preview" plugin by Drew Barrett. I just write my code in Coffeescript and then compile it to javascript with a single command `coffee -c classHeyJson.coffee` from the /files folder.

# EXAMPLES

## 1. Hangover

*Purpose*

Compare the number of views for the Hangover wikipedia page on two different days.

*Usage*

`<$hellojson command="hangover" day1="20200101" day2="20230101"/>`

*Demo*

[https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover](https://philwonski.github.io/twplugins-hello-json-advanced/#test-hangover)

## 2. WPAPI (aka Wordpress Remote)

*Purpose*

Interact with a remote Wordpress site using the built-in Wordpress REST API (no Wordpress plugins needed). 

This example greatly reduces the code required to interact with a Wordpress site and database, giving you the ability to build alternative backends for Wordpress sites using TiddlyWiki; or, alternatively, to build alternative backends for TiddlyWiki sites using headless Wordpress!

Getting posts in the main plugin file is as simple as calling a special method in the class file: `runFetchWpPosts()`.

```
if (ACTION == "getposts") {
        var heyJson = new HeyJson();
        await heyJson.runFetchWpPosts(WPsite);
        var msg = "got posts, check for new tiddlers with post id in title";
      }
```

In the heyJson class file, the `runFetchWpPosts` method just *requires*, *initiates* and *awaits* the minified [WPAPI NPM library](https://www.npmjs.com/package/wpapi).

```
posts = await site.post().perPage( 5 ).page( 1 ).get() // BOOM
```

*Usage*

`<$hellojson command="wpapi" wpaction="getposts" wpsite="mydigitalmark.com"/>`

*Demo*

[https://philwonski.github.io/twplugins-hello-json-advanced/#test-wpapi](https://philwonski.github.io/twplugins-hello-json-advanced/#test-wpapi)