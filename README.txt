= pjr (print_json_response)

* http://github.com/jdunphy/print_json_response

== DESCRIPTION

A simple script to grab JSON from a URI and view it in a readable manner.
Also, diff the JSON result of two URIs.

== SYNOPSIS:

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

pjr can jump into irb, instead of printing json

  $ pjr -i someurl.json
  Retrieving http://127.0.0.1:3000/someurl.json:
  Loading IRB.
  JSON response is in $response
  irb(main):001:0> $response['what']
  => "oh hey look some pretty-printed json"

djr can diff two JSON results:

  $ djr http://one.example/some/path http://two.example/some/path

pjr and djr can walk the JSON tree for more specific results:

  $ pjr http://one.example/some/path a b c
  $ djr http://one.example/some/path http://two.example/some/path a b c

== INSTALL:

* gem install print_json_response

