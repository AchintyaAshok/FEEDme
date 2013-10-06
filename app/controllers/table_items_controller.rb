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
		@table_item = TableItem.create!(table_item_params)
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

	def update_quantity
		@table_item = TableItem.find(params[:id])
		@table_item.quantity = params[:quantity]
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

	def destroy
		@table_item = TableItem.find(params[:id])
		if @table_item.destroy
			render :status => 200,
			:json => { :success => true,
				:info => "Item deleted",
				:data => {} 
			} 
		else
			render :status => :unprocessable_entity,
			:json => { :success => false,
				:info => "Cannot delete",
				:data => {:errors => @table_item.errors} 
			}
		end
	end

	private

	def table_item_params
		params.require(:table_item).permit(:table_id, :item_name, :quantity, :price)
	end
end
