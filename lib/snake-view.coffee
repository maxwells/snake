{View} = require 'atom'
SnakeGame = require './snake-game'

module.exports =
class SnakeView extends View
  @content: ->
    @div class: 'snake display', =>
      @h1 "Snake"
      @div outlet: 'display'

  listenForEvents: ->
    atom.workspaceView.command 'snake:left', @onLeft
    atom.workspaceView.command 'snake:up', @onUp
    atom.workspaceView.command 'snake:right', @onRight
    atom.workspaceView.command 'snake:down', @onDown

  stopListening: ->
    atom.workspaceView.off 'snake:left'
    atom.workspaceView.off 'snake:up'
    atom.workspaceView.off 'snake:right'
    atom.workspaceView.off 'snake:down'

  initialize: (serializeState) ->
    atom.workspaceView.command "snake:toggle", => @toggle()

  onLeft: =>
    @game.moveLeft()

  onRight: =>
    @game.moveRight()

  onUp: =>
    @game.moveUp()

  onDown: =>
    @game.moveDown()

  updateDisplay: =>
    @display.html @game.getBoard()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggleOnEditor: ->
    atom.workspaceView.eachEditorView (editor) ->
      editor.toggleClass 'snake'

  reset: ->
    @game.deactivate()
    @game.removeAllListeners 'update'

  onGameOver: =>
    @display.html " game over, man <br/>#{@game.getBoard()}"

  initializeBoard: ->
    @game = new SnakeGame(20, 20)
    @game.on 'update', @updateDisplay
    @game.on 'died', @onGameOver
    @game.activate()

  toggle: ->
    if @hasParent()
      @detach()
      @stopListening()
      @toggleOnEditor()
      @reset()
    else
      atom.workspaceView.appendToRight(this)
      @listenForEvents()
      @toggleOnEditor()
      @initializeBoard()
