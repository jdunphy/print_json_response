require 'net/http'
require 'optparse'
require 'uri'

require 'json'

class PrintJsonResponse

  VERSION = '2.0'

  DEFAULT_HOST = 'http://127.0.0.1:3000'

  CONFIG_PATH = File.expand_path '~/.pjr'

  def self.process_args program_name, argv
    options = {}
    options[:diff_opts] = '-u'

    djr = program_name =~ /djr$/

    op = OptionParser.new do |opts|
      opts.program_name = program_name
      opts.version = VERSION
      opts.banner = if djr then
                      "Usage: #{program_name} [options] URL URL [PATH ...]"
                    else
                      "Usage: #{program_name} [options] URL [PATH ...]"
                    end

      opts.banner << <<-BANNER

PATH is a path of keys in the JSON document you wish to descend.  Given a JSON
document like:

  { "a": { "b": ["c", "d"] } }

`pjr http://example/json a b` will print ["c", "d"]

      BANNER

      opts.on '--diff-opts=DIFF_OPTS', 'Options for diff' do |value|
        options[:diff_opts] = value
      end if djr

      opts.on '--[no-]irb', 'Dump the results into $response in IRB' do |value|
        options[:irb] = value
      end
    end

    op.parse! argv

    abort op.to_s if argv.empty?

    urls = argv.shift(djr ? 2 : 1)

    options[:path] = argv.dup

    argv.clear

    return urls, options
  end

  def self.run program_name, argv = ARGV
    urls, options = process_args program_name, argv

    pjr = new urls, options

    pjr.run
  end

  def initialize urls, options
    @urls = urls.map do |url|
      unless url =~ /\Ahttp/i then
        url = '/' + url unless url.start_with? '/'
        url = default_host + url
      end

      URI.parse url
    end

    @diff_opts = options[:diff_opts]
    @irb       = options[:irb]
    @path      = options[:path]
  end

  def default_host
    if File.exist? CONFIG_PATH and
       File.read(CONFIG_PATH) =~ /default_host:(.+)/i then
      $1.strip
    else
      DEFAULT_HOST
    end
  end

  def diff results
    require 'pp'
    require 'tempfile'
    require 'enumerator'

    tempfiles = []

    results.each_with_index do |result, i|
      io = Tempfile.open "url_#{i}_"
      io.puts result.pretty_inspect
      io.flush

      tempfiles << io
    end

    system "diff #{@diff_opts} #{tempfiles.map { |io| io.path}.join ' '}"
  end

  def fetch url
    $stderr.puts "Retrieving #{url}:" if $stdout.tty?

    resp = Net::HTTP.get_response url
    json = JSON.parse resp.body

    json = @path.inject json do |data, item| data[item] end
  end

  def irb json
    require 'irb'
    $response = json
    puts "JSON response is in $response"
    IRB.start
  end

  def run
    results = @urls.map do |url|
      fetch url
    end

    if results.length == 2 then
      diff results
    elsif @irb then
      irb results.first
    else
      require 'pp'
      puts results.first.pretty_inspect
    end
  end

end

