# App.activity = App.cable.subscriptions.create "ActivityChannel",
#   connected: ->
#     console.log('teste1')
#     # Called when the subscription is ready for use on the server
 
#   disconnected: ->
#     console.log('teste2')
#     # Called when the subscription has been terminated by the server
 
#   received: (event) ->
#     console.log(event.notice)
#     # Called when there's incoming data on the websocket for this channel
#     $('.page-container').pgNotification({
#         style: 'bar',
#         message: event.notice.message,
#         position: 'top',
#         timeout: 0,
#         type: 'info'
#     }).show();

#     #$('#events').prepend "<div class='event'>#{message}</div>"