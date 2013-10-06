jQuery ->


	class AppRouter extends Backbone.Router

		routes:
			'' : 'home'
			'find_table' : 'table_view'
			'select_items': 'menu_view'


		# Basically a constructor for the AppRouter, this method retrieves the collection
		# of all events (without any filters) and the list of categories. 
		initialize: ->
			@currentView = null
			#window.App.vent.bind('chosen_restaurant', @menu_view)

		show_view:(newView) =>
			if @currentView is not null then @currentView.close()
			@currentView = newView
			$('#container-main').html(@currentView.render().el)


		home: ->
			console.log 'in home!'
			view = new MainView
			@show_view(view)

		table_view: ->
			console.log 'in table view'
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
			console.log 'initializing main view'


	# This view allows a user to pick between creating a new table at a restaurant or choosing to join existing tables.
	# If the user chooses to create a new table, they are showing a menu of items available at the restaurant.
	class TableView extends Backbone.View
		
		tagName: 'div'
		className: 'table-view col-md-12 center'

		initialize:(options) ->
			console.log 'initializing menu view'

		render: ->
			template = """
			<div class="col-md-12 page-header">
				<div>
					<h1>Food <small>we all want some.</small></h1>
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
			@searchView.remove()
			template = """
				<div class="jumbotron" style='background-color:white;'>
					<div class='row'>
						<h2><%= name %></h2>
					</div>
					<div class='row'>
						<p class='lead'>Create a new table OR Join friends at an existing table.</p>
					</div>
					<div class='col-md-6'><a class="btn btn-lg btn-success btn-block" id='create-table' href="#">Create Table</a></div>
					<div class='col-md-6'><a class="btn btn-lg btn-primary btn-block" id='join-table' href="#">Join Table</a></div>
				</div>
			"""
			$(@el).append(_.template(template, attributes))
			return @

		events:
			'click #create-table': 'create_new_table'
			'click #join-table': 'join_table'


		create_new_table:(ev) =>
			console.log 'create a new table'
			

		join_table:(ev) =>
			console.log 'joining a table'

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

			console.log('our hidden inputs', attributes)
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
			console.log 'initializing menu view'
			console.log('loading with id->', options.id)

			@model = new Menu
				id: options.id # pass in the id of the restaurant to retrieve its menu
			@model.fetch
				async: false
				success:(ev) =>
					console.log 'fetched menu!'
				error:(ev) =>
					console.log 'unable to fetch menu'

		events:
			'mouseover .list-group-item' : 'handle_mouseover'

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
							<div class='col-md-2 pull-right'>
								<p><%= menuItem['price'] %></p>
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
