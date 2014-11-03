rabbit = require 'rabbit.js'

class RabbitQueue

  constructor: ->
    @ctx = rabbit.createContext()

    @ctx.on 'error', (err)-> console.error err

    @ctx.on 'ready', ->
      console.log 'connection has been established'

    # pub/sub, when an exchange received an message
    # all subs that connected to it will be notified
    @sub = @ctx.socket 'SUB', routing: 'topic'
    @pub = @ctx.socket 'PUB', routing: 'topic'

    # pull/push use round-robin strategy
    @pull = @ctx.socket 'PULL'
    @push = @ctx.socket 'PUSH'

    # when using push/worker, after a worker done processing,
    # worker must call #ack
    @worker = @ctx.socket 'WORKER'

    @req = @ctx.socket 'REQ'
    @rep = @ctx.socket 'REP'

  queueJob: (provider , job, callback)->
    return callback Error 'Provider not specificed' unless provider? and provider isnt ''

    @push.connect provider, (callback)=>
      @push.write job

  onProcess: (provider, callback)->
    @worker.setEncoding 'utf8'
    @worker.connect provider

    @worker.on 'data', (data)=>
      @worker.ack()
      callback data

module.exports = RabbitQueue

