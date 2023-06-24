fetchJson = require('./fetcher.js')

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
    
    twFilter: (filter) =>
        try
            f = await $tw.wiki.filterTiddlers(filter)
            return f
        catch e
            console.log(e)
            return "error filtering tiddlers in twFilter method"
    
    twAddtid: (tid) =>
        try
            await $tw.wiki.addTiddler(tid)
            return "added tiddler"
        catch e
            console.log(e)
            return "error adding tiddler in twAddtid method"
    
    
    runMsg: =>
        msg = "hello there"
        return msg


module.exports = HeyJson
