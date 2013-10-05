class WeatherController < ApplicationController
	
	def getWeatherForCity
		city = params["city"]
		state = params["state"]
	end
end
