describe 'covet', ->

  describe "a super simple stubbing", ->
    beforeEach (done) ->
      post 'covet/routes',
        verb: 'get'
        path: '/bunnies/3'
        response:
          id: 3
          name: "Frank"
          age: 12
      , (body, res) ->
        done()

    it 'gets the bunny', (done) ->
      get "bunnies/3", (body) ->
        expect(body).to.deep.equal
          id: 3
          name: "Frank"
          age: 12
        done()
