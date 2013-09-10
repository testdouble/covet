describe 'covet', ->

  afterEach (done) ->
    del "covet/routes", -> done()


  describe "stubbing", ->
    BUNNY =
      id: 3
      name: "Frank"
      age: 12

    describe "static GET route", ->
      beforeEach (done) ->
        post 'covet/routes',
          verb: 'get'
          path: '/bunnies/3'
          response:
            json: BUNNY
        , (body, res) ->
          done()

      it 'gets the bunny', (done) ->
        get "bunnies/3", (body) ->
          expect(body).to.deep.equal(BUNNY)
          done()

    describe "tearing down the previous example group", ->
      it "successfully tears down to prevent test pollution", (done) ->
        get "bunnies/3", (body, res) ->
          expect(res.statusCode).to.equal(404)
          done()

    describe "dynamic, conditional GET route", ->
      context "with an ID", ->
        beforeEach (done) ->
          post 'covet/routes',
            verb: 'get'
            path: '/bunnies/:id'
            request:
              params:
                id: 3
            response:
              json: BUNNY
          , (body, res) ->
            done()

        it 'satisfied stubbing gets bunny', (done) ->
          get "bunnies/3", (body) ->
            expect(body).to.deep.equal(BUNNY)
            done()

        it 'unsatisfied stubbings get nothing', (done) ->
          get "bunnies/2", (body, res) ->
            expect(res.statusCode).to.equal(400)
            done()

      context "with an ID and an Age", ->
        beforeEach (done) ->
          post 'covet/routes',
            verb: 'get'
            path: '/bunnies/:id/:age'
            request:
              params:
                id: 3
                age: 12
            response:
              json: BUNNY
          , (body, res) ->
            done()

        it 'satisfied stubbing gets bunny', (done) ->
          get "bunnies/3/12", (body, res) ->
            expect(body).to.deep.equal(BUNNY)
            expect(res.statusCode).to.equal(200)
            done()

        it 'unsatisfied stubbings get nothing', (done) ->
          get "bunnies/3/11", (body, res) ->
            expect(res.statusCode).to.equal(400)
            done()


    describe "dynamic, conditional POST route", ->
      context "with an ID and an Age", ->
        beforeEach (done) ->
          post 'covet/routes',
            verb: 'post'
            path: '/bunnies'
            request:
              body:
                id: 3
                age: 12
            response:
              json: BUNNY
              statusCode: 201
          , (body, res) ->
            done()

        it 'satisfied stubbing gets bunny', (done) ->
          post "bunnies", {id: 3, age: 12}, (body, res) ->
            expect(body).to.deep.equal(BUNNY)
            expect(res.statusCode).to.equal(201)
            done()

        it 'unsatisfied stubbings get nothing', (done) ->
          post "bunnies", {id: 3, age: 11}, (body, res) ->
            expect(res.statusCode).to.equal(400)
            done()

    describe "dynamic, conditional PUT route", ->
      context "with an ID and an Age", ->
        beforeEach (done) ->
          post 'covet/routes',
            verb: 'put'
            path: '/bunnies/:id/:age'
            request:
              params:
                id: 3
                age: 12
            response:
              json: BUNNY
          , (body, res) ->
            done()

        it 'satisfied stubbing gets bunny', (done) ->
          put "bunnies/3/12", {id: 3, age: 12}, (body, res) ->
            expect(body).to.deep.equal(BUNNY)
            expect(res.statusCode).to.equal(200)
            done()

        it 'unsatisfied stubbings get nothing', (done) ->
          put "bunnies/3/11", {id: 3, age: 12}, (body, res) ->
            expect(res.statusCode).to.equal(400)
            done()

    describe "dynamic, conditional DELETE route", ->
      context "with an ID and an Age", ->
        beforeEach (done) ->
          post 'covet/routes',
            verb: 'del'
            path: '/bunnies/:id/:age'
            request:
              params:
                id: 3
                age: 12
            response:
              json: ''
              statusCode: 204
          , (body, res) ->
            done()

        it 'satisfied stubbing gets bunny', (done) ->
          del "bunnies/3/12", (body, res) ->
            expect(body).to.deep.equal('')
            expect(res.statusCode).to.equal(204)
            done()

        it 'unsatisfied stubbings get nothing', (done) ->
          del "bunnies/3/11", (body, res) ->
            expect(res.statusCode).to.equal(400)
            done()

