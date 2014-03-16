# Snake atom package

Snake game for Github's Atom text editor. Just a weekend project - no real plans to make it awesome.

### Installing

Use the Atom package manager, which can be found in the Settings view or run apm install snake from the command line.

### Configuration

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

### Running it

Default keybindings are:

- `'cmd-alt-shift-s': 'snake:toggle'` - to start/stop
- `'cmd-alt-shift-r': 'snake:reset'` - to reset after game over

### In action

![Screenshot](https://raw.github.com/maxwells/snake/master/snake.gif)

### Issues

Submit any issues [here](https://github.com/maxwells/snake/issues)

### To dos

- Increase code quality/maintainability
- Write specs

### Version History

`0.1.0` - first working version

### License

MIT
