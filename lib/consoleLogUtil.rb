require 'date'

class ConsoleLogUtil
	def self.write(message)
		puts "#{DateTime.now.strftime "%d/%m/%Y %H:%M"} #{message}"
	end
end