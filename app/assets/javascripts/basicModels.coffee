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
				<div class='padding col-md-12'><br></div>
				<div class='col-md-6'>
					<a class='btn btn-primary btn-lg'>Create Table</a>
				</div>
				<div class='col-md-6'>
					<a class='btn btn-primary btn-lg'>Join Table</a>
				</div>
			"""

			$(@el).append(_.template(template))
			return @

		close: ->
			console.log 'TableView::closing()'
			@remove()


	# This view shows user the entire menu pertaining to the restaurant.
	class MenuView extends Backbone.View

		tagName: 'div'
		className: 'container col-md-12'
		idName: 'menu-view'

		initialize:(options) ->
			console.log 'initializing menu view'
			console.log('loading with options->', options)

			@model = new Menu
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
				<div class='panel panel-default'>
					<% for(var i=0; i<data['menu']['sections'].length; i++) {
						var element = data['menu']['sections'][i];
					%>
					<div class='panel-heading lead'><%= element['section_name'] %></div>
					<ul class="list-group">
						<% for(var j=0; j<element['subsections'][0]['contents'].length; j++){ 
							var menuItem = element['subsections'][0]['contents'][j];
						%>
						<li class='list-group-item'><a><%= menuItem['name'] %></a></li>
						<% } %>
					</ul>
					<br>
					<% } %>
				</div>
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
