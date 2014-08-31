#!/usr/bin/env ruby
require 'net/http'
require 'uri'

SFW = {
	LOLFACE: "http://f.st-hatena.com/images/fotolife/c/caramell/20111203/20111203235427.png"
}

MEME = {
	DOGE: "http://media.moddb.com/images/groups/1/4/3099/203320_v0_600x.1.jpg"
}

NSFW = {
	GOATSE: "http://goatse.info/hello.jpg",
	LEMON_PARTY: "",
	TUBGIRL: "http://tubgirl.ca/tubgirl.jpg"
}

def troll_sauce(src)
	loop do
		path = src+"?foobar=#{rand(10**256)}"
		puts "[DEBUG] Getting #{path}"
		conn = Net::HTTP.get(URI.parse(path))
		sleep(5)
	end
end

if $0 == __FILE__
	troll_sauce(SFW[:LOLFACE])
end
