class RestaurantTablesController < ApplicationController
	skip_before_filter :verify_authenticity_token, only: :create	
	respond_to :json

	def index
		# Show a list of all tables for a venue
		@tables = RestaurantTable.where(venue_locu_id: params[:venue_locu_id])
		if @tables
			render :status => 200,
			:json => { :success => true,
				:info => "",
				:data => { :tables => @tables
				} 
			} 
		else
			render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => "No tables for venue_locu_id: #{params[:venue_locu_id]}",
                        :data => {} }
		end
	end

	def create
		#Create a table. Still needs a venue_id + a name
		@table = RestaurantTable.create!(venue_locu_id: params[:venue_locu_id], name: params[:name])
		@user = User.find_by_venmo_user_id(params[:user_id])
		if @user == nil
			@user = User.create!(venmo_user_id: params[:user_id])
		end
		if @table && @user
			@table.users << @user
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
		@user = User.find_by_venmo_user_id(params[:user_id])
		if @user == nil
			@user = User.create!(venmo_user_id: params[:user_id])
		end
		@table.users << @user
		#HACK FIX THIS ASAP
		render :status => 200,
		:json => { :success => true,
			:info => "",
			:data => { :table => @table
			} 
		}
	end

	def destroy
		# Deactivate table
	end

end
