class Test
  name: ->
    debugger
    console.log "hello"
    "John"

  bind: ->
    handler = -> debugger; console.log("hi")
    $('#hello').on('blur', handler)
