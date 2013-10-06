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

		show_view:(newView) =>
			if @currentView is not null then @currentView.close()
			@currentView = newView
			$('#container-main').append(@currentView.render().el)


		home: ->
			console.log 'in home!'

		table_view: ->
			console.log 'in table view'
			view = new TableView
			@show_view(view)

		menu_view:(options) ->
			console.log('in select_items', options)
			menuView = new MenuView
				options: options
			@show_view(menuView)


	class MainView extends Backbone.View

		el: $('#container-main')

		initialize: ->
			console.log 'initializing main view'


	# This view allows a user to pick between creating a new table at a restaurant or choosing to join existing tables.
	# If the user chooses to create a new table, they are showing a menu of items available at the restaurant.
	class TableView extends Backbone.View
		
		tagName: 'div'
		className: 'table-view col-md-12 center'

		initialize: ->
			console.log 'initializing menu view'

		render: ->
			template = """
			<div class="col-md-12 page-header">
				<div>
					<h1>Some Title <small>subtext about the title</small></h1>
				</div>
			"""
			$(@el).append(_.template(template))

			$(@el).append("<div class='col-md-2 padding'></div>")
			searchElement = new RestaurantSearchView
			$(@el).append(searchElement.render().el)
			$(@el).append("<div class='col-md-2 padding'></div>")

			return @

		load_table_options: ->
			template = """
				<div class='padding col-md-12'><br></div>
				<div class='col-md-6'>
					<a class='btn btn-primary btn-lg'>Create Table</a>
				</div>
				<div class='col-md-6'>
					<a class='btn btn-primary btn-lg'>Join Table</a>
				</div>
			"""

		close: ->
			console.log 'TableView::closing()'
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
				<form role='form'>
					<div class='form-group'>
						<input class="form-control input-lg" id='restaurant-search-query' type="text" placeholder="Enter a name of a restaurant. Eg. Olive Garden">
						<button class='btn btn-info btn-lg btn-block' id='query-submit-button'>Find Places</button>
					</div>
				</form>
			"""

			$(@el).html(_.template(template))
			return @

		events:
			'click #query-submit-button' : 'handle_submit'
			'mouseover .list-group-item' : 'handle_mouseover'

		handle_submit:(options) ->
			console.log('submitted! options ->', options)
			results = new Venue
				options: options
			results.fetch
				async: false
				success:()=>
					@render_results(results)
				error:(response)=>
					console.log('restaurant-search-error -> ', response)


		render_results:(results) ->
			console.log 'these are the returned results ->', results.toJSON()
			$('form').remove()

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
					</li>
				<% } %>
				</div>
			"""

			$(@el).append(_.template(template, results.toJSON()))
			return @


		handle_mouseover:(ev) ->
			$('.list-group-item').removeClass('active')
			$(ev.currentTarget).addClass('active')
			$(ev.currentTarget).on 'mouseleave', (ev)->
				$(this).removeClass('active')



	class Venue extends Backbone.Model

		url: '/venues'

		initialize:(options) ->
			if options.name? then @modify_url(options.name)


		modify_url:(name) ->
			@url = @url + "?name=" + encodeURIComponent(name)
			return @url


	# This view shows user the entire menu pertaining to the restaurant.
	class MenuView extends Backbone.View

		tagName: 'div'
		className: 'container col-md-12'
		idName: 'menu-view'

		initialize:(options) ->
			console.log 'initializing menu view'
			console.log('loading with options->', options)

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
				<% for(var i=0; i<data['menu']['sections'].length; i++) { 
					var element = data['menu']['sections'][i];
				%>
				<div class='panel panel-default'>
					<div class='panel-heading clearfix'>
						<h3 class='panel-title'><%= element['section_name'] %></h3>
					</div>
					<ul class="list-group">
						<% for(var j=0; j<element['subsections'][0]['contents'].length; j++){ 
							var menuItem = element['subsections'][0]['contents'][j];
						%>
						<% if (menuItem['type'] == 'SECTION_TEXT'){ %>
						<div class=' well text-warning'><%= menuItem['text'] %></div>
						<% } else{ %>
						<li class='list-group-item'>
							<a><%= menuItem['name'] %></a>
							<p class='text-muted'><%= menuItem['description'] %></p>
							<% } %>
						</li>
						<% } %>
					</ul>
				</div>
				<% } %>
			"""

			stuff = """
			<ul class="nav nav-pills">
				<% for(var j=0; j<element['contents'].length; j++){ %>
				<p>blah</p>
				<% } %>
			</ul>
				<li><a><%= element['contents'][i]['name']</a></li>
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

		url: '/menu'


	# Exports
	window.App =
		"AppRouter": AppRouter
		"vent": _.extend({}, Backbone.Events)
