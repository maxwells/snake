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

  onReset: =>
    @initializeBoard()

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

  destroy: ->
    @game.deactivate()
    @game.removeAllListeners 'update'
    @stopListening()
    @toggleOnEditor()

  resetKeyBinding: ->
    keyBinding = atom.keymap.keyBindingsForCommand('snake:reset')
    keyBinding? and keyBinding[0]? and keyBinding[0].keystroke

  onGameOver: =>
    @display.html " game over, man; score: #{@game.getScore()} <br/>"
    keyBinding = @resetKeyBinding()
    @display.append " reset with #{keyBinding} <br />" if keyBinding?
    @display.append @game.getBoard()
    atom.workspaceView.command 'snake:reset', @onReset

  initializeBoard: ->
    width = atom.config.get('snake.width') or 20
    height = atom.config.get('snake.height') or 20
    @game = new SnakeGame(width, height)
    @game.on 'update', @updateDisplay
    @game.on 'died', @onGameOver
    @game.activate()
    atom.workspaceView.off 'snake:reset'

  toggle: ->
    if @hasParent()
      @detach()
      @destroy()
    else
      atom.workspaceView.appendToRight(this)
      @listenForEvents()
      @toggleOnEditor()
      @initializeBoard()
