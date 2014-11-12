amqp = require 'amqp'

class AMQPQueue

  constructor: ->
    @connection = amqp.createConnection()

    @connection.on 'error', (err)-> console.error err

  onProcess: (provider, callback)->
    @connection.on 'ready', =>
      @connection.queue provider, {autoDelete: false, durable: true}, (queue)->
        console.log 'Queue name: ' + queue.name
        queue.subscribe((message, headers, deliveryInfo, messageObject)->
          console.log message.data.toString()
          callback()
        )

  queueJob: (provider, job, callback)->
    @connection.on 'ready', =>
      @connection.publish provider,  job, {autoDelete: false, durable: true},->
        callback()

module.exports = AMQPQueue
