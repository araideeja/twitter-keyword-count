require 'twitter'
require_relative 'consoleLogUtil'

class TwitterClient
	@@NUM_RESULT=10
	@@MAX_ATTEMPT=1
	@@RESULT_TYPE='recent' #Options are "mixed", "recent", and "popular". The current default is "mixed."
	@@config = {
	  consumer_key:    "",
	  consumer_secret: "",
	  bearer_token: ""
	}
	
	def initialize
		ConsoleLogUtil.write "Preparing Twitter Connection"
		@connection = Twitter::REST::Client.new(@@config)
		ConsoleLogUtil.write "Twitter Connection is ready"
	end

	def count (keyword)
		ConsoleLogUtil.write "Counting for #{keyword} with #{@@MAX_ATTEMPT} attempt and #{@@NUM_RESULT} result per request"
		num_attempt=0
		last_id=-99
		count=0
		begin
			while(num_attempt<@@MAX_ATTEMPT) do
				num_attempt += 1
				if(last_id == -99) 
					@connection.search(keyword, result_type: "#{@@RESULT_TYPE}").take(@@NUM_RESULT).each do |tweet|
						last_id = tweet.id
						count += 1
					end
				else 
					@connection.search(keyword, result_type: "#{@@RESULT_TYPE}", since_id: last_id-1).take(@@NUM_RESULT).each do |tweet|
						last_id = tweet.id
						count += 1
					end
				end
				ConsoleLogUtil.write "Attempt # #{num_attempt} count #{count}"
			end
		rescue Twitter::Error::TooManyRequests => error
			if(num_attempt<=@@MAX_ATTEMPT)
				wait_time = error.rate_limit.reset_in + 1
				ConsoleLogUtil.write "Rate limit exceed for attempt #{num_attempt} current count = #{count}. Please wait for #{wait_time}"
				num_attempt = num_attempt -1
				sleep wait_time
				ConsoleLogUtil.write "Hi. I am back"
				retry
			end
		end
		ConsoleLogUtil.write "Done for #{keyword}. Count tweets = #{count}"
	end
end
