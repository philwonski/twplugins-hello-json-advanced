# HelloJson-Advanced

HelloJson-Advanced is a template for building TiddlyWiki plugins, building on the basic concepts of the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo.

Both repos represent the same opinionated workflow for developing TiddlyWiki plugins. It's just a *file structure* with 3 levels and some style conventions. 

This setup serves me well whenever I'm building alternative user interfaces for tools like Salesforce, Airtable, Quickbooks, and Wordpress.

# Why?

Please see the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo for a more detailed explanation of the motivation behind this approach. This Advanced repo is intended to get you right into hard examples.

# How?

Refer again to the [HelloJson](https://github.com/philwonski/twplugins-hello-json) repo for a brief explanation of how to leverage ChatGPT to supercharge your own development of plugins in this style.

In short, the basic structure starts with just 3 files:

1. `hj.js` - the main plugin file that's (almost) straight from the TiddlyWiki plugin boilerplate 
2. `classHeyJson.js` - required inside the `hj.js` file, it has the cool methods like `fetch(url)`
3. `fetcher.js` - our first helper file, which abstracts a GET request and keeps the class file clean

# This Repo

This repo is intended to house various examples of bringing cool helpers and libraries into TiddlyWiki to do different stuff. 

In comparing it to the basic repo, a good place to start is the "hangover" command used in the basic repo. Note how in this repo:

1. The `hangover` command no longer lives in the EXECUTE function block of the main plugin file `hj.js`. Instead, it lives in the INVOKE block, meaning it gets invoked on an action in the frontend... In this case the frontend action is a button you can click when viewing the `test-hangover` tiddler. 

2. The `hangover` command accepts two different days as params, allowing you to compare the number of views for the Hangover wikipedia page on two different days.

3. The code for calling the `hangover` command in `hj.js` is much shorter now: we've abstracted the code for calling the hangover command into a method called `runFetchHangoverCompare` in our class file, `classHeyJson.js`. 

4. **DO YOU BELIEVE IN MAGIC?** Note how the `runFetchHangoverCompare` method calls another method in the class called `twMakeTid`. This is where things really start to get interesting: instead of just displaying text like the basic hello-json widget, now we are actually calling upon TiddlyWiki functionality and creating a tiddler. This opens up a world of possibilities for ingesting remote data into TiddlyWiki and doing things with it. 

# Usage

I set up my dev environment exactly like the instructions here: 

[https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub](https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub)

It may seem like a bunch of steps but the process can be boiled down to this:

1. Make a folder on your computer called TWdev (or whatever you want). This is where you will keep all your plugins you work on.

2. Inside the new directory, install a local copy of TW5 with `git clone https://github.com/Jermolene/TiddlyWiki5.git TW5`.

3. Now you can see the TW5 has two important folders: `editions` and `plugins`. All we are doing is:
    1. Adding our own plugin code under plugins
    2. Picking an edition, like `TW5/editions/empty` and adding a quick reference to our plugin in the `tiddlywiki.info` file
    3. Running a single command in the TW5 folder to build that edition with our plugin included, like `node ./tiddlywiki.js editions/empty --build index`... this will create a static html version of the wiki you can view and share.

So the top of my file `TWdev/TW5/editions/empty/tiddlywiki.info` now looks like this:

```
{
	"description": "Empty edition",
	"plugins": [
		"philwonski/twplugins-hello-json"
	],
    
```

And I can generate a static html version of the wiki with my plugin included by running this command in the TW5 folder: `node ./tiddlywiki.js editions/empty --build index` and then opening the file `TWdev/TW5/editions/empty/output/index.html#heyJay-test` in my browser.