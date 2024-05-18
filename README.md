# ztictactoe

A simple tictactoe game in Zig.

## how to compile ?

Simply execute this command:
`zig build-exe -O ReleaseSmall tictactoe.zig`.

## how to play ?

Your goal is to align 3 `X` (if you are player 1) or `O` (if you are player 2), either horizontally/vertically/diagonally.

For example:
```
    +---+---+---+
    | O | O | X |
    +---+---+---+
    | 4 | X | 6 |
    +---+---+---+
    | X | 8 | 9 |
    +---+---+---+

```
> The player 'X' win in this case
