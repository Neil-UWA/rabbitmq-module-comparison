RabbitQueue = require './rabbit_queue'

queuer = new RabbitQueue()

queuer.onProcess 'nada', console.log
