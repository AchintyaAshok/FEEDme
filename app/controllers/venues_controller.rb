class VenuesController < ActionController::Base
	
	#Search endpoint. Input: a restaurant name, 
	def index
		search_term = params["venue"].tr(" ", "+")
		url = "http://api.locu.com/v1_0/venue/search/?name=#{search_term}&has_menu=true&category=restaurant&locality=Boston&api_key=c441cb7b1b3f83a2644a6bc573dd8ebf3e9a1afb"
		venue = HTTParty.get(url)
		if venue
			render :status => 200,
			:json => { :success => true,
				:info => "",
				:data => { :venue => venue
				} 
			} 
		end
	end
end