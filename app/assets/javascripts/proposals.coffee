# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $(document).ready ->
#   $('div.nested-fields').on 'click', 'a.new_field', (event) ->
#     $(this).before($(this).data('fields'))
#     $(this).hide()

# $('form#settings').on 'click', 'a#remove-field', (event) ->
#   $(this).parents('tr.nested-fields').remove()

#   $('form#settings').on 'click', 'a#create-field', (event) ->
#     if (!$('input.new_field').val() )
#       $('form#settings').validator('validate')
#     else
#       object = $(this)
#       variable = $('input.new_field').val()
#       regexp = new RegExp('/variable/', 'g')
#       $('hr.create-field').before object.data('fields').replace(regexp, variable)
#       $('form#settings').validator('destroy')
#       event.preventDefault()
#     return
#   $('form#settings').on 'click', 'input.disabled#create-field', (event) ->
#     $('div.add-field').remove()
#     $('form#settings').submit()