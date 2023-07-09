fetchJson = require('./helper-fetcher.js')
WPAPI = require('./helper-wpapi.js')

class HeyJson
    constructor: (@hey = {}) ->

    runName: =>
        @hey
    # PINNED HANGOVER EXAMPLE
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
            # per HelloJson guidelines, this request should really be via a promise from a helper file
            # but i had the below handy from @Ooktech so I'm using it for now
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
    
    getAIreply: (creds_tid, msg_tid) =>
        
        # grab the api key from the creds tiddler
        creds_obj = $tw.wiki.getTiddler(creds_tid)
        apikey = creds_obj.fields.apikey
        # console.log(apikey)
        
        # grab the message from the msg tiddler
        # prepare the payload like OpenAI wants it
        msg_obj = $tw.wiki.getTiddler(msg_tid)
        msg = msg_obj.fields.msg
        msg_payload = {}
        msg_payload["role"] = "user"
        msg_payload["content"] = msg

        sysmsg = msg_obj.fields.sysmsg
        sysmsg_payload = {}
        sysmsg_payload["role"] = "system"
        sysmsg_payload["content"] = sysmsg

        model = msg_obj.fields.model
        # msg = "hello there"
        url = "https://api.openai.com/v1/chat/completions"

        msgs = [sysmsg_payload, msg_payload]

        pl = {}
        pl.model = model
        pl.messages = msgs
        payload = JSON.stringify(pl)
        auth = "Bearer " + apikey

        # now send the request to OpenAI
        try
            # per HelloJson guidelines, this request should really be via a promise from a helper file
            # but i had the below handy from @Ooktech so I'm using it for now
            formRequest = new XMLHttpRequest
            formRequest.open 'POST', url, true
            formRequest.setRequestHeader 'content-type', 'application/json'
            formRequest.setRequestHeader 'Authorization', auth
            formRequest.send payload

            formRequest.onreadystatechange = ->
                if formRequest.readyState == 4 && formRequest.status == 200
                    response = JSON.parse(formRequest.responseText)
                    console.dir(response)
                    reply = response.choices[0].message.content
                    $tw.wiki.setText msg_tid, "reply", "", reply
                    return reply
                else
                    $tw.wiki.setText msg_tid, "reply", "", "it didn\'t work"
                    return "error getting AI reply (maybe from remote, check nw console) in getAIreply method"
        catch e
            console.log(e)
            return "error getting AI reply in getAIreply method"

    zrunMsg: =>
        # just a test method
        msg = "hello there"
        return msg


module.exports = HeyJson