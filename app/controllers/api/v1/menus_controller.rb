class API::V1::MenusController < ActionController::Base
	respond_to :json

	def index

		menu = HTTParty.get('http://api.locu.com/v1_0/venue/b307b08674481c3cef22/?api_key=c441cb7b1b3f83a2644a6bc573dd8ebf3e9a1afb
')
		#Get venue from frontend
		#Get menu for venue from Locu
		#Send menu
		menu_json = JSON.parse(menu.body)
		if menu
					render :status => 200,
					:json => { :success => true,
						:info => "",
						:data => { :menu => menu_json["menu"]["objects"] } 
					} 
		end
	end
end