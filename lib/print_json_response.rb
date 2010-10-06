require 'net/http'
require 'optparse'
require 'uri'

require 'json'

class PrintJsonResponse

  VERSION = '1.0.1'

  DEFAULT_HOST = 'http://127.0.0.1:3000'

  CONFIG_PATH = File.expand_path '~/.pjr'

  def self.process_args argv
    options = {}

    op = OptionParser.new do |opts|
      opts.program_name = 'pjr'
      opts.version = VERSION
      opts.banner = <<-BANNER
Usage: pjr [options] URL [PATH ...]

PATH is a path of keys in the JSON document you wish to descend.  Given a JSON
document like:

  { "a": { "b": ["c", "d"] } }

`pjr http://example/json a b` will print ["c", "d"]

      BANNER

      opts.on '--[no-]irb', 'Dump the results into @response in IRB' do |value|
        options[:irb] = value
      end
    end

    op.parse! argv

    abort op.to_s if argv.empty?

    url = argv.shift

    options[:path] = argv

    return url, options
  end

  def self.run argv = ARGV
    url, options = process_args argv

    pjr = new url, options

    pjr.run
  end

  def initialize url, options
    unless url =~ /\Ahttp/i then
      url = '/' + url unless url.start_with? '/'
      url = default_host + url
    end

    @url = URI.parse url

    @irb  = options[:irb]
    @path = options[:path]
  end

  def default_host
    if File.exist? CONFIG_PATH and
       File.read(CONFIG_PATH) =~ /default_host:(.+)/i then
      $1.strip
    else
      DEFAULT_HOST
    end
  end

  def run
    $stderr.puts "Retrieving #{@url}:" if $stdout.tty?

    resp = Net::HTTP.get_response @url
    json = JSON.parse resp.body

    json = @path.inject json do |data, item| data[item] end

    if @irb then
      require 'irb'
      @response = json
      puts "Loading IRB."
      puts "JSON response is in @response"
      IRB.start
    else
      require 'pp'
      puts json.pretty_inspect
    end
  end

end

