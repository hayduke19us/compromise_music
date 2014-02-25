# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Sync.TrackRow extends Sync.View

  beforeInsert: ($el) ->
    $el.hide()
    @insert($el)

  afterInsert: ->
    @$el.fadeIn('slow')

  beforeRemove: ->
    @$el.fadeOut 'slow', => @remove()

#tags

