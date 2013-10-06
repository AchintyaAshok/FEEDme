class MenusController < ActionController::Base
	respond_to :json

	def index
		venue_locu_id = params[:id]
		url = 'http://api.locu.com/v1_0/venue/' + venue_locu_id + '/?api_key=c441cb7b1b3f83a2644a6bc573dd8ebf3e9a1afb' 
		menu = HTTParty.get(url)
		#Get venue from frontend
		#Get menu for venue from Locu
		#Send menu
		menu_json = JSON.parse(menu.body)
		if menu
					render :status => 200,
					:json => { :success => true,
						:info => "",
						:data => { :menu => menu_json["objects"][0]["menus"]
						 } 
					} 
		end
	end
end