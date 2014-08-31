#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'


def troll_sauce(src)
	loop do
		path = src+"?foobar=#{rand(10**256)}"
		puts "[DEBUG] Getting #{path}"
		conn = Net::HTTP.get(URI.parse(path))
		sleep(5)
	end
end

if $0 == __FILE__
	images = JSON.parse(File.open('images.json','r').read)
	troll_sauce(images["sfw"]["awesome_face"])
end
