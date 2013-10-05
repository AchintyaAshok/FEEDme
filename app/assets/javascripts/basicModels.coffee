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

		select_items:(options) ->
			menuView = new MenuView
				options: options
			show_view(menuView)


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
			console.log 'loading with options->' options

			@myMenu = new Menu
			@myMenu.fetch (ev)->
				async: false
				success:
					console.log 'fetched menu!'
				error:
					console.log 'unable to fetch menu'

		render: ->
			template = """

			"""


	class Menu extends Backbone.Model

		url: '/menu'


	# Exports
	window.App =
		"AppRouter": AppRouter
		"vent": _.extend({}, Backbone.Events)
