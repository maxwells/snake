Events = require('events')

module.exports =
class SnakeGame extends Events
  @LEFT = x: -1, y: 0
  @RIGHT = x: 1, y: 0
  @UP = x: 0, y: -1
  @DOWN = x: 0, y: 1

  constructor: (@width, @height) ->
    @startPos =
      x: Math.floor(@width / 2)
      y: Math.floor(@height / 2)
    @snake = [new SnakeComponent(@startPos.x, @startPos.y)]
    @initializeBoard()
    @moveRight()

  activate: () ->
    @currentInterval ?= atom.config.get('snake.startingInterval') or 200
    @interval = setInterval @moveCurrentDir, @currentInterval

  deactivate: ->
    clearInterval @interval

  increaseSpeed: ->
    @deactivate()
    @currentInterval *= atom.config.get('snake.intervalMultiplier') or 0.95
    @activate()

  # Create the game board
  initializeBoard: ->
    @board = [] # x => y
    for i in [0..@width - 1]
      @board[i] = []
      for j in [0..@height - 1]
        @board[i][j] = new BoardComponent(BoardComponent.EMPTY)
    @addFood(atom.config.get('snake.numFood') or 1)

  addFood: (numFood = 1) ->
    for i in [0..numFood - 1]
      pos = @randPos()
      pos = @randPos() while @board[pos.x][pos.y].type != BoardComponent.EMPTY
      @board[pos.x][pos.y] = new BoardComponent(BoardComponent.FOOD)

  randPos: ->
    x: Math.floor(Math.random() * @width), y: Math.floor(Math.random() * @height)

  cloneBoard: ->
    clone = []
    clone.push yArray.slice(0) for yArray in @board
    clone

  getScore: ->
    @snake.length - 2

  getBoard: ->
    output = ""

    clone = @cloneBoard()

    for snakeComponent in @snake
      if @isInBounds snakeComponent.x, snakeComponent.y
        clone[snakeComponent.x][snakeComponent.y] = snakeComponent

    output += @border()

    for i in [0..@height-1]
      for j in [0..@width-1]
        output += clone[j][i].toString()
      output += "<br />"

    output += @border()

    output

  border: ->
    output = ""
    output += "-" for i in [0..@width - 1]
    output + "<br />"

  handleFoodCollision: ->
    head = @snake[0]
    if @board[head.x][head.y].type == BoardComponent.FOOD
      @board[head.x][head.y].type = BoardComponent.EMPTY
      @addFood()
      @increaseSpeed()
      return true
    false

  hasDeathCollision: ->
    head = @snake[0]

    for component in @snake.slice(1)
      return true if component.x == head.x and component.y == head.y
    return !@isInBounds(head.x, head.y)

  isInBounds: (x, y) ->
    x < @board.length && x >= 0 && y < @board[0].length && y >= 0

  die: ->
    @deactivate()
    @emit 'died'

  move: (delX, delY) ->
    head = @snake[0]

    # Add one to the front of the snake
    @snake.unshift new SnakeComponent(head.x + delX, head.y + delY)

    return @die() if @hasDeathCollision()

    # remove one from the back unless has eaten food
    @snake.pop() unless @handleFoodCollision()

    @emit 'update'

  moveLeft: ->
    @currentDir = SnakeGame.LEFT unless @lastDir? && @lastDir == SnakeGame.RIGHT

  moveRight: ->
    @currentDir = SnakeGame.RIGHT unless @lastDir? && @lastDir == SnakeGame.LEFT

  moveUp: ->
    @currentDir = SnakeGame.UP unless @lastDir? && @lastDir == SnakeGame.DOWN

  moveDown: ->
    @currentDir = SnakeGame.DOWN unless @lastDir? && @lastDir == SnakeGame.UP

  moveCurrentDir: =>
    @move @currentDir.x, @currentDir.y
    @lastDir = @currentDir


class BoardComponent

  @EMPTY =
    value: 0
    display: '&nbsp;'

  @FOOD =
    value: 1
    display: '*'

  constructor: (@type) ->

  toString: ->
    @type.display

class SnakeComponent
  constructor: (@x, @y) ->

  toString: ->
    'o'
