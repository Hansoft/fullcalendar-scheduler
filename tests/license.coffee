
describe 'schedulerLicenseKey', ->

	beforeEach ->
		$.fullCalendar.mockSchedulerReleaseDate = '2011-06-06'

	afterEach ->
		delete $.fullCalendar.mockSchedulerReleaseDate

	# FYI: eventAfterAllRender guarantees that view's skeleton has been rendered and sized

	defineTests = ->

		it 'is invalid when crap text', (done) ->
			initCalendar
				schedulerLicenseKey: '<%= versionReleaseDate %>'
				eventAfterAllRender: ->
					expectIsValid(false)
					done()

		it 'is invalid when purchased more than a year ago', (done) ->
			initCalendar
				schedulerLicenseKey: '1234567890-fcs-1273017600' # purchased on 2010-05-05
				eventAfterAllRender: ->
					expectIsValid(false)
					done()

		it 'is valid when purchased less than a year ago', (done) ->
			initCalendar
				schedulerLicenseKey: '1234567890-fcs-1275868800' # purchased on 2010-06-07
				eventAfterAllRender: ->
					expectIsValid(true)
					done()

		it 'is invalid when not 10 digits in random ID', (done) ->
			initCalendar
				schedulerLicenseKey: '123456789-fcs-1275868800' # purchased on 2010-06-07
				eventAfterAllRender: ->
					expectIsValid(false)
					done()

		it 'is valid when Creative Commons', (done) ->
			initCalendar
				schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives'
				eventAfterAllRender: ->
					expectIsValid(true)
					done()

		it 'is valid when GPL', (done) ->
			initCalendar
				schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source'
				eventAfterAllRender: ->
					expectIsValid(true)
					done()

	expectIsValid = (bool) ->
		expect(!$('.fc-license-message').is(':visible')).toBe(bool)


	describe 'when in a timeline view with resource', ->
		pushOptions
			defaultView: 'timeline'
			resources: [ { id: 'a', title: 'Resource A' } ]
		defineTests()

	describe 'when in a timeline view no resource', ->
		pushOptions
			defaultView: 'timeline'
			resource: false
		defineTests()

	describe 'when in a month view', ->
		pushOptions
			defaultView: 'month'
		defineTests()