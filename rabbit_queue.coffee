rabbit = require 'rabbit.js'

class RabbitQueue

  constructor: ->
    @ctx = rabbit.createContext('amqp://localhost')

    @ctx.on 'error', (err)-> console.error err

    @ctx.on 'ready', ->
      console.log 'connection has been established'

    # pub/sub, when an exchange received an message
    # all subs that connected to it will be notified
    @sub = @ctx.socket 'SUB', routing: 'topic'
    @pub = @ctx.socket 'PUB', routing: 'topic'

    # pull/push use round-robin strategy
    @pull = @ctx.socket 'PULL'
    @push = @ctx.socket 'PUSH', persistent: true

    # when using push/worker, after a worker done processing,
    # worker must call #ack
    @worker = @ctx.socket 'WORKER', persistent: true

    @req = @ctx.socket 'REQ'
    @rep = @ctx.socket 'REP'

  queueJob: (provider , job, callback)->
    return callback Error 'Provider not specificed' unless provider? and provider isnt ''

    @push.connect provider, (callback)=>
      @push.write job, 'utf8'

  onProcess: (provider, callback)->
    @worker.connect provider
    @worker.on 'data', (data)=>
      console.log data
      @worker.ack()

module.exports = RabbitQueue

