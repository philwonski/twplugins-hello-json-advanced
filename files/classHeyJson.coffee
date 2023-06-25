fetchJson = require('./fetcher.js')
WPAPI = require('./wpapi.js')

class HeyJson
    constructor: (@hey = {}) ->

    runName: =>
        @hey
    
    runFetchHangoverCompare: (day1, day2) =>    
        try
            wikipedia = (day) =>
                url = "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Philosophy/daily/" + day + "/" + day
                f = await fetchJson(url)
                json = JSON.parse(f)
                views = json.items[0].views;
                return views
            d1 = await wikipedia(day1)
            d2 = await wikipedia(day2)
            msg = "On " + day1 + " there were " + d1 + " views. On " + day2 + " there were " + d2 + " views. Interesting!"
            await @twMakeTid("HangoverCompare", msg)
            return "success"
        catch e
            console.log(e)
            return "error in runFetchHangoverCompare method"
    
    twMakeTid: (tid, text) =>
        console.log("running runMakeTid method");
        try  
            title = tid
            body = text
            return $tw.wiki.addTiddler({
                    title: title,
                    text: body,
                    tags: "test"
                  });
        catch e
            console.log(e)
            return "error making tiddler in runMakeTid method"
    
    runFetch: (url) =>
        try
            f = await fetchJson(url)
            return f
        catch e
            console.log(e)
            return "error fetching json in runFetch method"
    
    runFetchWpPosts: (wpsite) =>

        endpoint = "https://" + wpsite + "/wp-json/"
        namespace = 'wp/v2'
        postRoute = '/posts/(?P<id>)'
        site = new WPAPI({endpoint: endpoint})
        site.post = site.registerRoute(namespace, postRoute)

        try
            posts = await site.post().perPage( 5 ).page( 1 ).get()
            # console.log(JSON.stringify(posts))
            importer = (x) =>
                wptitle = "import-" + x.id
                wplink = x.link
                wptext = JSON.stringify(x)
                title = x.title.rendered
                body = x.content.rendered
                return $tw.wiki.addTiddler({
                    title: wptitle,
                    text: wptext,
                    type: "application/json",
                    tags: "wpPost",
                    wplink: wplink
                  })
            
            for post in posts
                await importer(post)

            return "got posts"
        catch e
            console.log(e)
            return "error fetching wp posts in runFetchWpPosts method"
    
    runMsg: =>
        msg = "hello there"
        return msg


module.exports = HeyJson