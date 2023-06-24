/*\
/*\
title: philwonski/twplugins-hello-json/hj.js
type: application/javascript
module-type: widget
helloJson widget
\*/

// Hello Json widget
// use like <$hellojson command="hangover"/>

(function() {

  /*jslint node: true, browser: true */
  /*global $tw: false */
  "use strict";
  
  var Widget = require("$:/core/modules/widgets/widget.js").widget;

  /* Import the HeyJson class with all the cool methods */
  const HeyJson = require("$:/plugins/philwonski/twplugins-hello-json-advanced/classHeyJson.js");

  var MyWidget = function(parseTreeNode, options) {
      this.initialise(parseTreeNode, options);
      this.reply = '';
  };
  
  /*
  Inherit from the base widget class
  */
  MyWidget.prototype = new Widget();
  
  /*
  Render this widget into the DOM
  */
  MyWidget.prototype.render = async function(parent, nextSibling) {

      this.parentDomNode = parent;
      this.computeAttributes();
      // var reply = this.execute();
      var reply = await this.execute();
      var textNode = this.document.createTextNode(reply);
      parent.insertBefore(textNode, nextSibling);
      this.domNodes.push(textNode);
  };

  /*
  Do execution of logic
  */

  MyWidget.prototype.execute = async function() { 
      // get the command the user provided in the frontend widget invocation
      this.COMMAND = this.getAttribute("command");

      // now collect params for the various commands

      if (this.COMMAND == "hangover") {
        // command="hangover" params: day1, day2
        this.day1 = this.getAttribute("day1");
        this.day2 = this.getAttribute("day2");
        var instructions = `testing ${this.COMMAND} command...`;
      }
      
      return instructions;
};
  
  /*
  Refresh if the attribute value changed since render
  */
  MyWidget.prototype.refresh = function(changedTiddlers) {
      // Find which attributes have changed
      var changedAttributes = this.computeAttributes();
      if (changedAttributes.message) {
          this.refreshSelf();
          return true;
      } else {
          return false;
      }
  };

  MyWidget.prototype.invokeAction = async function(triggeringWidget,event) {
      var COMMAND = this.COMMAND;
    // ******************************************************************************** //
      //  EXAMPLE- HANGOVER: get Json from wikipedia and return some info from inside it
      // ******************************************************************************** //
      if (COMMAND == "hangover") {
        // Find out how many people looked at the english wikipedia page for Hangover on a given day
        // use in your wiki like <$hellojson command="hangover"/>
        // We only need one method of the HeyJson class to get this info:
        // 1. runFetch() - this is a wrapper for the fetch() method to go get the json from the url

        // first assign the HeyJson class to a variable
        var heyJson = new HeyJson();

        // now let's set up our wikipedia query (thanks wikipedia!)
        // let's see how many people visited the wikipedia page for "Hangover" on New Year's Day 2023
        var day1 = this.day1;
        var day2 = this.day2;

        // HERE'S THE MAGIC
        // this is where we use the HeyJson class to get the json from both urls
        // it automatically creates a new tiddler called "HangoverCompare" with the results
        var createTid = await heyJson.runFetchHangoverCompare(day1, day2);

      return createTid;

  } else if (COMMAND == "test" || COMMAND == "hello" || COMMAND == undefined || COMMAND == "") {
    var reply = "Hello, World! The plugin is installed.";
    return reply;
  } 
  
  };
  
  
  exports.hellojson = MyWidget;
  
  })();