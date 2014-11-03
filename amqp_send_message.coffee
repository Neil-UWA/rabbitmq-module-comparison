AMQPQueue = require './amqp_queue'

queue = new AMQPQueue()

queue.queueJob 'nada',  'world', ()->
  console.log 'message has been sent'
