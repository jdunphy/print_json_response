pjr (print_json_response)
==================

A simple script to grab json from a URI and view it in a readable manner.

usage
-----

        $ pjr "http://someplace.com/someurl.json"
        Retrieving http://someplace.com/someurl.json:
        {
          "what":"oh hey look some pretty-printed json"
        }

        You can also drop the hostname nonsense when hitting localhost

        $ pjr "/someurl.json"
        Retrieving http://127.0.0.1:3000/someurl.json:
        {
          "what":"oh hey look some pretty-printed json"
        }

        Override the base default host of localhost:3000 with a .pjr file.

        $ cat /Users/jdunphy/.pjr 
        default_host:http://localhost:7000

installation
------------
I just stick this file in some place that happens to be in my load path.
I use ~/bin/pjr.
