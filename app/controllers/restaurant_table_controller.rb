class RestaurantTableController < ApplicationController
	respond_to :json

	def index
		# Show a list of all tables for a venue
		@tables = RestaurantTable.find_by_venue_locu_id(params[:venue_locu_id])
		if @tables
			render :status => 200,
			:json => { :success => true,
				:info => "",
				:data => { :tables => @tables
				} 
			} 
		end
	end

	def create
		#Create a table. Still needs a venue_id + a name
		@table = RestaurantTable.create!(venue_locu_id: params[:venue_locu_id], name: params[:name])
		if @table
			render :status => 200,
			:json => { :success => true,
				:info => "",
				:data => { :table => @table
				} 
			} 
		end
	end

	def update
		@table = RestaurantTable.find(params[:id])
		@user = User.find(params[:user_id])
		@table.users << @user
		
	end

	def destroy
		# Deactivate table
	end

end
