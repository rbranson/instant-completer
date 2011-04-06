require "sinatra"
require "algorithms"

DICTIONARY_FILE = "/usr/share/dict/words"
MAX_RESULTS     = 25
LATENCY         = 0.15

get "/" do
  redirect to("/index.html")
end

get "/search" do
  @query    = params[:query].downcase.gsub(/[^a-zA-Z]/, "")
  @results  = []
  
  if @query.size > 1
    @results = $search.wildcard("#{@query}..............................")[0, MAX_RESULTS]
    sleep LATENCY
  end
  
  erb :search
end

$search = Containers::Trie.new

File.open(DICTIONARY_FILE) do |f|
  puts "Loading words from #{DICTIONARY_FILE}..."
  
  while s = f.gets do
    word = s.chop.downcase
    $search.push(word, 1) if word.size > 1
  end
  
  puts "Finished loading dictionary."
end

run Sinatra::Application