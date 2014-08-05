#!/usr/bin/env ruby
require 'net/http'
require 'uri'

LEMON_PARTY = URI.parse("")

def troll_sauce(src)
	loop do
		conn = Net::HTTP.get(URI.parse(src+"?#{rand(10**256)}"))
		sleep(5)
	end
end

if $0 == __FILE__
	troll_sauce(LEMON_PARTY)
end
