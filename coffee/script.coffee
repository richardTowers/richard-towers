# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

# **script** contains just the calls necessary to set things up.

window.require [
    "jquery",
    "libs/modernizr-2.5.3-respond-1.1.0.min",
    "libs/bootstrap.min",
    "libs/prettify"
  ],
  ($, modern, boot, pretty) ->
    "strict mode"
    # Just in case one of the other scripts we've included has been naughty
    $ = jQuery
    
    # On the DOM ready event
    $ ->
      # **Todo**: Once using [require.js](http://requirejs.org/) most of these should only happen on pages that require them.
      
      # Set up prettyprint for any source that might be on the page.
      window.prettyPrint()
      # Set up [bootstrap tooltips](http://twitter.github.com/bootstrap/javascript.html#tooltips).
      $('[rel=tooltip]').tooltip({placement:'right'})
      $('[rel=popover]').popover({placement:'top',html:true})