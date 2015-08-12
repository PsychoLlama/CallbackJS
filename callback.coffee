custom = {}

class Callback
  constructor: (callback) ->
    return undefined if not callback
    
    if callback.constructor is String
      return console.log "Return a custom event"
    if callback.constructor isnt Function
      throw new Error "Not a function, bro"
    
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
  
  renew: ->
    @cancelled = false
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
        setTimeout((=>
          @invoke()
          ), target)
      else
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

Callback.fire = (event) ->
  return if typeof event isnt 'string'
  return if not custom[event]
  
  for callback in custom[event]
    try callback.invoke()
  
  return custom[event]

@Callback = Callback