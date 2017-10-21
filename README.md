# [UNMAINTAINED] CallbackJS

*A useful event library.*

## Maintenance Notice
This project exists because of its historical significance. It's the second project I wrote while teaching myself to code.

Hide your eyes and move along.

## Features

What's so cool about CallbackJS?
Here we go:

- Pretty callback syntax
- Abstractified event assignments
- Promises
- Callback cancelling
- Callback *renewal*
- Those last two can be event-driven
- Simpler error handling
- Conditional invocations
- Full control over what arguments are passed
- Full control over "this" value
- Custom, globally accessible events (say whaaaaat?)

Phew! Too many words. Let's look at an example.

```
new Callback( function(args) {
    // Do something
})
.when(button, 'click')
.when('My custom event')
.unless(15000)
```

Here we defined a new callback to be invoked when either of
two events fire, the button click or the custom event (we'll cover
custom events later). But what about "unless"? Unless tells
CallbackJS not to execute your callback if some event fired.
The argument we gave of 15000 is an event. It means
your callback will be cancelled in **15000 milliseconds**
(15 seconds).

> `unless` can take any event `when` can. We'll cover more events
here in a second...

Let's look at another example...

```
new Callback( function(arg) {
    // Do something else
})
.when(5000, true)
.if( function() {
    return (this.fired.length < 2)
})
```

Okay, we've got a new method here named "if".
If defines a function. That function will be called before
your callback, and if it returns a truthy value, your
callback is invoked.

One more thing: say you want your timer to repeat, just pass in
true after the milliseconds.

Suppose you only want your callback to respond to an event
after another event has happened. CallbackJS has your back.

```
new Callback(you know the drill)
.cancel()
.renew(request, 'load')
.when(button, 'click')
```

Okay, so what does that mean?
Let's step through it:

- Create a new callback
- *Cancel* that callback, so it won't execute until you re-enable
it
- Then **renew** your callback at some future event, in this case,
when your request loads
- Bind your callback to a click event

This means that your callback will *only* execute the click
event after your request comes through.
Feeling the power yet?

> Side note: when attaching a load handler, CallbackJS checks
to see if the target has *already loaded*.

Hang tight: things are about to get tricky. CallbackJS gives
you full control over how your callback is invoked, and
allows advanced (optional) configuration through the "config"
method.

```
...
.config({
    // set the value of the "this" keyword
    "this": whateverYouWant
    
    // Overwrite the default event
    //  arguments with your own.
    pass: args
    
    // You could also use "cancel()"
    cancelled: true
    
    // A handler to call in case
    //  the main one fails.
    // We'll cover this more in a second...
    error: handler
    
    // If you wanted to set
    //  the callback this way,
    //  you could.
    callback: callback
    
    // Same thing as "if"
    conditional: function...
})
```

As you can see, there are a few ways to do things with
CallbackJS. I would generally recommend using the methods
to set your handlers or conditionals for clarity,
but the method is there if you need it.

## Errors

What happens if you callback fails miserably? CallbackJS will
try to die as gracefully as possible by calling your error method
and passing the error event object.
Here's how you define one:

```
...
.catch( function(error) {
    // Sob quitely
})
```

That's it! You now have an error handler.

## Custom events

Okay, so to me this is the most important piece of CallbackJS.
If something event-like happens in your code, you might want
an event-like action. Since JavaScript is event-oriented,
events should be super easy... right?

Well, they aren't.

JavaScript has one or two sparsely supported event
registration/dispatching techniques,
but they only apply to DOM elements and are clunky to deal with.
This makes it hard to declare rich, semantic events.

### Creating your own

So how do you define an event? Easy! just use it. Here's what that
looks like...

```
new Callback(function() {})
.when( "name your event here" )
```

That's it! Your event has been created, and you can use it with
as many callbacks as you'd like. It also plays nicely with
`unless("event")` and
`renew("event")`.

### Firing custom events

Watch closely:

`Callback.fire("event name")`

Okay, maybe that was too easy. Want to give an argument to every
callback? Pass them in after your event name:

```
Callback.fire("event", arg1, arg2, arg3...)
```

> Keep in mind that callbacks can override your arguments
with `config()`.

*Warning: event names are case sensitive.*

## Summary

Lists are great. Let's make a list of the methods you can use.

- new Callback(function)
- config(optional object)
- when(event fires)
- cancel()
- unless(required event)
- renew(optional event)
- if(function)
- catch(handler)
- invoke(optional args)

**Pro tip**: use callback.invoke() to manually invoke your function.
Invoke takes optional arguments, pays respect to your configuration
variables, and also checks your conditional before firing.

Well, there you have it! That's just about everything there is to know
about CallbackJS. If you have any questions or issues, lemme know -
I'd love to hear from you!

Seriously, if you have issues, let me know.
This library was built in 4 hours and probably has some bugs.
