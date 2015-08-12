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
    
    @pass = []
    @["this"] = null
    
    @conditional = null
    @error = null
  
  config: (vars) ->
    if typeof vars isnt 'object'
      throw new Error "You didn't give an object."
    
    for property of vars
      constructor = vars[property].constructor
      
      # Test to make sure config vars are valid
      switch property
        when "fired"
          return false
        when "callback"
          if constructor isnt Function
            return false
        when "conditional"
          if constructor isnt Function
            return false
        when "error"
          if constructor isnt Function
            return false
        when "cancelled"
          if constructor isnt Boolean
            return false
        when "pass"
          if constructor isnt Array
            return false 
      
      if @.hasOwnProperty property
        @[property] = vars[property]
      
    return @
    
  cancel: (arg=false) ->
    if arg is false
      @cancelled = true
    return @
  
  catch: (callback) ->
    return if not callback
    
    @error = callback
    return @

@Callback = Callback