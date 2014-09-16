class Test
  name: ->
    console.log("hello")
    "John"

  bind: ->
    handler = -> console.log("hi")
    $('#hello').on('blur', handler)
