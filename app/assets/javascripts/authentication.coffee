jQuery ->

	class User extends Backbone.Model

		initialize: ->
			attributes = {
				'client_id': 1437
				'scope': 'access_profile,make_payments'
				'response_type': 'code'
			}
			endpointURL = @generate_endpoint_url(attributes)
			console.log 'endpoint url->', endpointURL

		generate_endpoint_url:(attributes) ->
			@endpointURL = "https://api.venmo.com/oauth/authorize"
			console.log 'generate_e_url::attr->', attributes
			prefix = "?"
			$.each attributes, (key, value)=>
				console.log 'key,value', key, value
				@endpointURL = @endpointURL + prefix + key + "=" + value
				prefix = "&"
				console.log 'updated url->', @endpointURL
			
			return @endpointURL

		events:
			'click #venmo-login-button': 'login_venmo'

		login_venmo: =>
			console.log('in login_venmo')
			window.location.href = @endpointURL
			window.location.reload()


	window.Social =
		"Venmo": User
