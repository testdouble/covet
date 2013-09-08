describe 'covet', ->
  it 'passes', (done) ->
    get "bunnies/3", (body) ->
      expect(body.name).to.equal("Frank")
      done()
