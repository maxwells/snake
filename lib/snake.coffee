SnakeView = require './snake-view'

module.exports =
  snakeView: null

  activate: (state) ->
    @snakeView = new SnakeView(state.snakeViewState)

  deactivate: ->
    @snakeView.destroy()

  serialize: ->
    snakeViewState: @snakeView.serialize()
