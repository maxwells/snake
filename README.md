# Snake atom package

Snake game for Github's Atom text editor.

Supports the following configuration options (in your global Config file):

```cson
'snake':
  # width of the game board
  # -> defaults to 20
  'width': 40
  # height of the game board
  # -> defaults to 20
  'height': 10
  # interval in ms between snake movements
  # -> defaults to 200
  'startingInterval': 150
  # interval multiplier upon eating food
  # -> higher means slower speed increase
  # -> defaults to 0.95
  'intervalMultiplier': 0.93
  # number of food pieces on the board at any point in time.
  # -> defaults to 1
  'numFood': 2
```

Default keybindings are:

- `cmd-alt-shift-s` to start/stop
- `cmd-alt-shift-r` to reset after game over

![Screenshot](https://raw.github.com/maxwells/snake/master/snake.gif)
