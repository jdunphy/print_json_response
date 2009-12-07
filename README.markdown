print_json_response
==================

A simple script to grab json from a URI and view it in a readable manner.

usage
-----

        $ print_json_response "http://someplace.com/someurl.json"
        Retrieving http://someplace.com/someurl.json:
        {
          "what":"oh hey look some pretty-printed json"
        }

        $ print_json_response
        Interactive mode.  Enter a uri.
        http://someplace.com/someurl.json
        Retrieving http://someplace.com/someurl.json:
        {
           "what":"oh hey look some pretty-printed json"
        }

installation
------------
I just stick this file in some place that happens to be in my load path.
I use ~/bin/print_json_reponse, and then alias it to pjr in .bashrc.
