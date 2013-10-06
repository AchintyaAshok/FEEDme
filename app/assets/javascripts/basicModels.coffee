jQuery ->


	class User extends Backbone.Model
		initialize: ->
			console.log 'initialized user'
			@attributes = {
				'client_id': 1437
				'scope': 'access_profile,make_payments'
				'response_type': 'code'
			}
			endpointURL = @generate_endpoint_url(@attributes)
			#console.log 'endpoint url->', endpointURL

		generate_endpoint_url: ->
			@endpointURL = "https://api.venmo.com/oauth/authorize"
			console.log 'generate_e_url::attr->', @attributes
			prefix = "?"
			$.each @attributes, (key, value)=>
				#console.log 'key,value', key, value
				@endpointURL = @endpointURL + prefix + key + "=" + value
				prefix = "&"
				#console.log 'updated url->', @endpointURL
			
			return @endpointURL

		complete_authorization:(code) ->
			console.log 'completing authorization...', code
			@accessURL = "https://api.venmo.com/oauth/access_token"
			@accessAttrs = {
				'client_id': 1437
				'code': code
				'client_secret': 'a6fNZeFvmMRWevAsQNScRcwFu6Rut6zA'
			}
			# prefix = '?'
			# $.each @accessAttrs, (key, value)=>
			# 	@accessURL += prefix + key + "=" + value
			# 	prefix = "&"

			$.post @accessURL, @accessAttrs, (data, status)=>
				console.log('success!', data, status)
				@set data
				window.App.vent.trigger('user-loaded', @toJSON())



	class AppRouter extends Backbone.Router

		routes:
			'' : 'home'
			'find_table' : 'table_view'
			'select_items': 'menu_view'


		# Basically a constructor for the AppRouter, this method retrieves the collection
		# of all events (without any filters) and the list of categories. 
		initialize: ->
			@currentView = null
			window.App.VenmoUser = new User
			window.App.vent.bind('table-selection', @table_view)


		show_view:(newView) =>
			if @currentView is not null then @currentView.close()
			@currentView = newView
			$('#container-main').html(@currentView.render().el)


		home: ->
			console.log 'in home!'
			view = new MainView
			@show_view(view)

		table_view: =>
			console.log 'in table view'
			@navigate('makeMyTable')
			view = new TableView
			@show_view(view)

		menu_view:(id) =>
			console.log('get_menu', id)
			menuView = new MenuView
				id: id
			@navigate('select_items/' + id)
			@show_view(menuView)


	class MainView extends Backbone.View

		tagName:'div'

		initialize: ->
			params = {}
			window.location.search.replace /[?&]+([^=&]+)=([^&]*)/gi, (str,key,value)=>
				params[key] = value

			console.log 'code->', params
			if params.code?
				alert(params.code)
				window.App.VenmoUser.complete_authorization(params.code)

			window.App.vent.bind('user-loaded', @update_view)

		render: ->
			template = """
				<div class="jumbotron">
					<h1>Welcome to Feed Me!</h1>
					<p class="lead">Here, you can easily find your favorite restaurants, look up the menus, select your food and share the bill with friends!</p>
					<p><a class="btn btn-lg btn-info" id='venmo-login-button' href="<%= venmo_login %>">Login with Venmo</a></p>
				</div>
			"""

			$(@el).html(_.template(template, {'venmo_login': window.App.VenmoUser.generate_endpoint_url()}))
			return @

		update_view:(userData)=>
			$('jumbotron').remove()

			template = """
				<div class="jumbotron">
					<h1>Welcome, <%= firstname %>!</h1>
					<p class="lead">Here, you can easily find your favorite restaurants, look up the menus, select your food and share the bill with friends!</p>
					<p><a class="btn btn-lg btn-success" id='restaurant-search-button'>Search for Food</a></p>
				</div>
			"""

			$(@el).html(_.template(template, userData['user']))

			$('#restaurant-search-button').on 'click', (ev)=>
				window.App.vent.trigger('table-selection')

		close: ->
			@remove()


	# this view primarily shows what all items have been ordered for the table. The user
	# will be able to see item names, item prices, quantity and total price. 
	# the cart will show up as a modal, where items are matched up with their price, etc.
	# the user can then choose to play for a certain selection of items.
	class CartView extends Backbone.View


	# This view allows a user to pick between creating a new table at a restaurant or choosing to join existing tables.
	# If the user chooses to create a new table, they are showing a menu of items available at the restaurant.
	class TableView extends Backbone.View
		
		tagName: 'div'
		className: 'table-view col-md-12'

		initialize:(options) ->
			console.log 'initializing menu view'

		render: ->
			template = """
			<div class="col-md-12 page-header center">
				<div>
					<h1>Food <small>we all want some.</small></h1>
				</div>
			</div>
			"""
			$(@el).append(_.template(template))

			$(@el).append("<div class='col-md-2 padding'></div>")
			@searchView = new RestaurantSearchView
			$(@el).append(@searchView.render().el)
			$(@el).append("<div class='col-md-2 padding'></div>")

			window.App.vent.bind('chosen_restaurant', @load_table_options)

			return @

		load_table_options:(attributes) =>
			@venueName = attributes.name
			@venueID = attributes.id
			@searchView.remove()
			template = """
				<div class="jumbotron center" style='background-color:white;'>
					<div class='row'>
						<h2><%= name %></h2>
					</div>
					<div class='row'>
						<p class='lead help-text'>Create a new table OR Join friends at an existing table.</p>
					</div>
					<div class='col-md-6 table-button'><a class="btn btn-lg btn-success btn-block" id='create-table'>Create Table</a></div>
					<div class='col-md-6 table-button'><a class="btn btn-lg btn-primary btn-block" id='join-table'>Join Table</a></div>
				</div>
			"""
			$(@el).append(_.template(template, attributes))
			return @

		events:
			'click #create-table': 'create_new_table'
			'click #join-table': 'join_table'


		create_new_table:(ev) =>
			console.log 'create a new table'
			$('.help-text').fadeOut 'fast', ->
				$(this).remove()
			$('.table-button').each (index)->
				$(this).fadeOut 'fast', (ev)->
					$(this).remove()

			template = """
				<form role='form' id='restaurant-search-form'>
					<div class='col-md-2 padding'></div>
					<div class='form-group col-md-8'>
						<input class="form-control input-lg" id='new-table-name' type="text" placeholder="Name your table. Eg. John's Table">
						<button class='btn btn-success btn-lg btn-block' id='create-new-table'>Submit</button>
					</div>
					<div class='col-md-2 padding'></div>
				</form>
			"""

			$(@el).append(_.template(template))

			$('#create-new-table').on 'click', (ev)=>
				ev.preventDefault()
				newTableName = $('#new-table-name').val()
				console.log 'create the new table with name->', newTableName
				userID = window.App.VenmoUser.get('user')['id']
				$.post '/tables', {'name': newTableName, 'venue_locu_id':@venueID, 'user_id':userID}, (data, response)=>
					console.log('success!', data, response)
					@attributes = data['data']['table']
					$('form').remove()
					@load_menu()


			return @


		join_table:(ev) =>
			console.log 'joining a table'

		load_menu: ->
			console.log 'table-view table model -> ', @attributes
			@menu = new MenuView
				id: @venueID
			$(@el).append(@menu.render().el)
			window.App.vent.bind('add-item', @add_item)
			return @

		add_item:(attributes) =>
			console.log 'item attributes -> ', attributes
			$.post '/tableitems', {'table_item': {'table_id':@attributes.id, 'item_name':attributes.name, 'quantity':1, 'price':attributes.price}}, (data, response)=>
				console.log 'adding item post->', response, data


		close: ->
			console.log 'TableView::closing()'
			@searchView.remove()
			@remove()


	# This view presents the user with a search bar which allows them to 
	# find restaurants by name. Consequently, once a search is performed, 
	# the view loads all the options of restaurants that they can choose from.
	class RestaurantSearchView extends Backbone.View

		tagName: 'div'
		className: 'col-md-8'
		idName: 'restaurant-search-view'

		initialize: ->
			console.log 'initializing RestaurantSearchView'

		render: ->
			template = """
				<form role='form' id='restaurant-search-form'>
					<div class='form-group'>
						<input class="form-control input-lg" id='restaurant-search-query' type="text" placeholder="Enter a name of a restaurant. Eg. Olive Garden">
						<button class='btn btn-info btn-lg btn-block' id='query-submit-button' type='submit'>Find Places</button>
					</div>
				</form>
			"""

			$(@el).html(_.template(template))
			return @

		events:
			'submit #restaurant-search-form' : 'handle_submit'
			'mouseover .list-group-item' : 'handle_mouseover'
			'click .list-group-item' : 'choose_venue'

		handle_submit:(ev) =>
			ev.preventDefault()

			name = $('#restaurant-search-query').val()
			results = new Venue
				name: name
			results.fetch
				async: false
				success:()=>
					@render_results(results)
				error:(response)=>
					console.log('restaurant-search-error -> ', response)


		render_results:(results) ->
			console.log 'these are the returned results ->', results.toJSON()
			
			$('form').remove()

			if results.toJSON()['data']['venue']['objects'].length == 0
				template = """
					<div id='sorry'>
						<p class='lead'>Oh No! We couldn't find anything :(</p>
						<button class='btn btn-warning btn-lg btn-block' id='search-again'>Search Again</button>
					</div>
				"""
				$(@el).append(_.template(template))

				$('#search-again').on 'click', (ev)=>
					$('#sorry').remove()
					@render()

				return @
			

			template = """
				<div class="col-md-12 list-group pull-left">
				<% for(var i=0; i < data['venue']['objects'].length; i++) { 
					var element = data['venue']['objects'][i];
				%>
					<li class="list-group-item col-md-12">			
					    <p class='lead'><%= element['name'] %></p>
					    <address>
					    	<%= element['street_address'] %><br>
					    	<%= element['locality'] %>, <%= element['region'] %> <%= element['postal_code'] %><br>
					    	<abbr P:</abbr> <%= element['phone'] %>
					    </address>
					    <input type='hidden' name='name' value="<%= element['name'] %>">
					    <input type='hidden' name='id' value="<%= element['id'] %>">			
					</li>
				<% } %>
				</div>
			"""

			$(@el).append(_.template(template, results.toJSON()))
			return @


		choose_venue:(ev) ->
			elem = $(ev.currentTarget)
			values = $(ev.currentTarget).children('input')
			attributes = {}
			$(ev.currentTarget).children('input').each (index, object)->
				attributes[String(object.name)] = String(object.value)

			window.App.vent.trigger('chosen_restaurant', attributes)


		handle_mouseover:(ev) ->
			$('.list-group-item').removeClass('active')
			$(ev.currentTarget).addClass('active')
			$(ev.currentTarget).on 'mouseleave', (ev)->
				$(this).removeClass('active')


	class Venue extends Backbone.Model

		url: '/venues'

		initialize:(options) ->
			console.log('initializing a venue, options->', options)
			if options? and options.name? then @modify_url(options.name)

		modify_url:(name) ->
			@url = @url + "?name=" + encodeURIComponent(name)
			console.log('modifying venue url -> ', @url)
			return @url


	# This view shows user the entire menu pertaining to the restaurant.
	class MenuView extends Backbone.View

		tagName: 'div'
		className: 'container col-md-12'
		idName: 'menu-view'

		initialize:(options) ->
			@model = new Menu
				id: options.id # pass in the id of the restaurant to retrieve its menu
			@model.fetch
				async: false
				success:(ev) =>
				error:(response) =>
					console.log 'unable to fetch menu -> ', response

		events:
			'mouseover .list-group-item' : 'handle_mouseover'
			'click #add-item-button': 'add_item'

		render: ->
			console.log('MenuView::render -> model', @model.toJSON())
			template = """
				<% for(var i=0; i<data['menu'][0]['sections'].length; i++) { 
					var element = data['menu'][0]['sections'][i];
				%>
				<div class='panel panel-default'>
					<div class='panel-heading clearfix'>
						<h3 class='panel-title'><%= element['section_name'] %></h3>
					</div>
					<div class="list-group">
						<% for(var j=0; j<element['subsections'][0]['contents'].length; j++){ 
							var menuItem = element['subsections'][0]['contents'][j];
						%>
						<% if (menuItem['type'] == 'SECTION_TEXT'){ %>
						<div class=' well text-warning'><%= menuItem['text'] %></div>
						<% } else if(menuItem['price'] != undefined){ %>
						<div class='list-group-item container'>
							<div class='col-md-10'>
								<p><%= menuItem['name'] %></p>
								<p class='text-muted'><%= menuItem['description'] %></p>
							</div>
							<div class='col-md-2' style='text-align:right;'>
								<p><%= menuItem['price'] %></p>
								<button class='btn btn-sm btn-success' id='add-item-button'>Add Item</button>
								<input type='hidden' class='item-info' name='name' value="<%= menuItem['name'] %>">
								<input type='hidden' class='item-info' name='price' value="<%= menuItem['price'] %>">
							</div>
						<% } %>
						</div>
						<% } %>
					</div>
				</div>
				<% } %>
			"""

			$(@el).append(_.template(template, @model.toJSON()))
			return @

		handle_mouseover:(ev) ->
			$('.list-group-item').removeClass('active')
			$(ev.currentTarget).addClass('active')
			$(ev.currentTarget).on 'mouseleave', (ev)->
				$(this).removeClass('active')

		add_item:(ev) =>
			console.log("menu-view::add_item current target", $(ev.currentTarget).parent())
			attributes = {}
			$(ev.currentTarget).parent().children('.item-info').each (index, object)->
				attributes[String(object.name)] = String(object.value)
			$(ev.currentTarget).remove()
			$(ev.currentTarget).parent().addClass('success')
			window.App.vent.trigger('add-item', attributes)

		close: ->
			@remove()


	class Menu extends Backbone.Model

		url: '/menus'

		initialize:(options) ->
			@url = @url + '/' + options.id


	# Exports
	window.App =
		"AppRouter": AppRouter
		"vent": _.extend({}, Backbone.Events)
		'VenmoUser': User
