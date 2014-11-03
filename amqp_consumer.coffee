AMQPQueue = require './amqp_queue'

queue = new AMQPQueue()

queue.onProcess 'nada', ->
  console.log 'message has been processed'
