class TableItemsController < ActionController::Base
	skip_before_filter :verify_authenticity_token, only: [:create, :update]
	respond_to :json
	
	def index
		#Return a list of all table items for a table_id.
		@table_items = TableItem.where(table_id: params[:table_id])
		if @table_items
			render :status => 200,
			:json => { :success => true,
				:info => "",
				:data => { :table_items => @table_items
				} 
			} 
		else
			render :status => :unprocessable_entity,
			:json => { :success => false,
				:info => "No table items found",
				:data => {} 
			}
		end

	end

	def create
		@table_item = TableItem.create!{params[:table_item]}
		if @table_item.save
			render :status => 200,
			:json => { :success => true,
				:info => "",
				:data => { :tables => @table_item
				} 
			} 
		else
			render :status => :unprocessable_entity,
			:json => { :success => false,
				:info => "Not created",
				:data => {:errors => @table_item.errors} 
			}
		end
	end

	def update
		#Update a sepecific item
	end

	def delete
		#Delete an item
	end
end
