custom = {}

class Callback
  constructor: (callback=null) ->
    if callback is null
      callback = ->
    if callback.constructor isnt Function
      throw new Error "That ain't no function, missy"
    
    @callback = callback
    @fired = []
    @cancelled = false
    
    @["this"] = null
    @pass = null
    
    @conditional = null
    @error = null
  
  config: (vars) ->
    return false if typeof vars isnt 'object'
    
    for property of vars
      
      if @.hasOwnProperty property
        @[property] = vars[property]
      
    return @
    
  cancel: (arg=null) ->
    if arg is null
      @cancelled = true
    else
      new Callback(=> @cancelled = true).when(arg)
    return @
  
  renew: (arg=null) ->
    if arg is null
      @cancelled = false
    else
      new Callback(=> @cancelled = false).when(arg)
    return @
  
  catch: (callback) ->
    return if not callback
    
    @error = callback
    return @
  
  when: (target, event) ->
    return if not target
    switch target.constructor
      when String
        if not custom[target]
          custom[target] = new Array()
        custom[target].push @
      when Number
        time = target
        repeat = event
      
        if repeat
          setInterval((=>
            @invoke()
            ), time)
        else
          setTimeout((=>
            @invoke()
            ), time)
      else
        if event.toLowerCase() is 'load'
          switch target.readyState
            when 'complete', 4
              @invoke target
        target.addEventListener? event, (event) =>
          @invoke event
    
    return @
  
  if: (conditional) ->
    return false if typeof conditional isnt 'function'
    @conditional = conditional
    
    return @
  
  invoke: (arg=null) ->
    return false if @cancelled
    if @conditional
      condition = @conditional()
      if not condition
        return condition
    try
      if @['this']? and @pass?
        @callback.call @['this'], @pass
      else if @['this']? and arg?
        @callback.call @['this'], arg
      else if @['this']? and not arg
        @callback.call @['this']
      else if @pass?
        @callback @pass
      else if arg?
        @callback arg
      else @callback()
      
      @fired.push new Date()
    catch error
      if @error
        @error error
      else
        throw error
    
    return @

Callback.fire = (event, args...) ->
  return if typeof event isnt 'string'
  return if not custom[event]
  
  for callback in custom[event]
    try
      if args.length
        callback.invoke args
      else callback.invoke()
  
  return custom[event]

@Callback = Callback