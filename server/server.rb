#!/usr/bin/ruby

#main program needs to open configuration and spawn relevant servers
#
#functionality:
# => Sinatra server
# 	Allow requests for specific image name: ie. GET /nsfw/goatse will result in an HTTP/302 to redirect the client to a temporary path to evade caching on WoS
# 	Allow for HTTP logins for pure text-based WoS
# => SMTP Server
# 	Accepts all logins for pure text-based WoS
# => POP3 Server
# 	Accepts all logins for pure text-based WoS

require 'sinatra/base'
require 'digest'

class WoSTHTTPServer < Sinatra::Base
	#this needs to be defined for all images to serve
	get '/goatse' do
		#need to add a temporary route for Goatse image (to avoid caching on WoS)
		token = Digest::SHA256.hexdigest("goatse"+Time.now.to_s)
		puts "[DEBUG] Adding route to goatse.jpg as \"/#{token}\""
		WoSTHTTPServer.get "/#{token}" do
			send_file('img/nsfw/goatse.jpg', :filename => token)
		end
		redirect "/#{token}"
	end

	run! if app_file == $0
end
