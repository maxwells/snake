module.exports =
class SnakeGame
  constructor: (@width, @height) ->
    @startPos =
      x: Math.floor(@width / 2)
      y: Math.floor(@height / 2)
    @snake = [new SnakeComponent(@startPos.x, @startPos.y)]
    @initializeBoard()

  initializeBoard: ->
    @board = [] # x => y
    for i in [0..@width - 1]
      @board[i] = []
      for j in [0..@height - 1]
        @board[i][j] = new BoardComponent(BoardComponent.EMPTY)
    @addFood()

  addFood: ->
    pos = @randPos()
    pos = @randPos() while @board[pos.x][pos.y].type != BoardComponent.EMPTY
    @board[pos.x][pos.y] = new BoardComponent(BoardComponent.FOOD)

  randPos: ->
    x: Math.floor(Math.random() * @width), y: Math.floor(Math.random() * @height)

  cloneBoard: ->
    clone = []
    clone.push yArray.slice(0) for yArray in @board
    clone

  getBoard: ->
    output = ""

    clone = @cloneBoard()

    for snakeComponent in @snake
      clone[snakeComponent.x][snakeComponent.y] = snakeComponent

    for yArray, i in clone
      for boardComponent, j in yArray
        output += clone[j][i].toString()
      output += "<br />"

    console.log output

    output

  move: (delX, delY) ->
    head = @snake[0]
    @snake.unshift new SnakeComponent(head.x + delX, head.y + delY)
    @snake.pop()

  moveLeft: ->
    @move -1, 0

  moveRight: ->
    @move 1, 0

  moveUp: ->
    @move 0, -1

  moveDown: ->
    @move 0, 1

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
