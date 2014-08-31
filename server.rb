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
require 'find'
require 'json'

class WoSTHTTPServer < Sinatra::Base
	images = {}
	routes = []

	#build file listing
	Find.find(Dir.pwd+'/img') do |path|
		if FileTest.directory?(path)
			if File.basename(path)[0] == ?.
				Find.prune
			else
				next
			end
		else
			key = File.basename(path,".*")
			unless images[key].nil?
				puts "[WARNING] Had a name collision on #{key}!\n\tFile 1: #{images[key][:path]}\n\tFile 2: #{path}" if $DEBUG
				next
			end

			ext_detected = File.extname(path)

			extension = ext_detected.match(/^\.(jpg|jpeg|png|gif)$/i)
			next if extension.nil?
			extension = extension[0]
			extension.downcase!
			extension.gsub!(".","")

			sfw = path.match(/\/nsfw\//i).nil?
			puts "[DEBUG] Found SFW?(#{sfw}) image named \"#{key}\" of type #{extension} at #{path}" if $DEBUG

			images[key] = {:extension => extension, :path => path, :sfw? => sfw}
		end
	end
	
	images.keys.each do |key|
		sfw_ness = "nsfw"
		sfw_ness = "sfw" if images[key][:sfw?]

		routes << "/#{sfw_ness}/#{key}"

		puts "[DEBUG] Adding static route for /#{sfw_ness}/#{key}" if $DEBUG
		#this needs to be defined for all images to serve
		get "/#{sfw_ness}/#{key}" do
			#need to add a temporary route for Goatse image (to avoid caching on WoS)
			token = Digest::SHA256.hexdigest(key+Time.now.to_s)
			puts "[DEBUG] Adding dynamic route to #{key} as \"/#{token}\"" if $DEBUG
			WoSTHTTPServer.get "/#{token}" do
				send_file(images[key][:path], :filename => token, :disposition => :inline)
			end
			redirect "/#{token}"
		end
	end

	get "/" do
		routes.to_json
	end

	run! if app_file == $0
end
