RabbitQueue = require './rabbit_queue'

queuer = new RabbitQueue()

job = 'hello world'

queuer.queueJob 'nada', job, console.log for i in [0..4]
