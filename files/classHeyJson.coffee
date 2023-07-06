fetchJson = require('./helper-fetcher.js')
WPAPI = require('./helper-wpapi.js')

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

    tidsByFilter: (filter) =>
        $tw.wiki.filterTiddlers(TEST_TIDDLER_FILTER);
        
        try
            tids = $tw.wiki.filterTiddlers(filter)
            return tids
        catch e
            console.log(e)
            return "error getting tiddlers by filter in tidsByFilter method"
    
    sendTidsByFilter: (url, tids) =>
        these_tids = tids
        
        # funtion to access tid object by title from these_tids
        access_tid = (tid) ->
            console.log 'accessing tid ' + tid + ' ...'
            tidobj_big = $tw.wiki.getTiddler(tid)
            # console.log(JSON.stringify(tidobj_big));
            tidobj = tidobj_big.fields
            #console.dir(tidobj);
            return tidobj
        
        tid_objs = these_tids.map(access_tid);
        payload = JSON.stringify(tid_objs)

        url = url
        try
            formRequest = new XMLHttpRequest
            formRequest.open 'POST', url, true
            formRequest.setRequestHeader 'content-type', 'application/json'
            formRequest.setRequestHeader 'X-API-Key', '123456'
            formRequest.send payload

            formRequest.onreadystatechange = ->
                if formRequest.readyState == 4 && formRequest.status == 200
                    for tid in these_tids
                        $tw.wiki.setText tid, "SENTyn", "", "yes"
                else
                    for tid in these_tids
                        $tw.wiki.setText tid, "SENTyn", "", "no"
                return
        catch e
            console.log(e)
            return "error sending tiddlers by filter in sendTidsByFilter method"
    
    runMsg: =>
        # just a test method
        msg = "hello there"
        return msg


module.exports = HeyJson