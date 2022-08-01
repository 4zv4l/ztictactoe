// Program:     tictactoe
// Made by:     4zv4l
// Description:
//      Basic tictactoe game
//      User as to put 3 'O' or 'X' in a row
//      For ex:
//          +---+---+---+
//          | O | 2 | X |
//          +---+---+---+
//          | 0 | X | 6 |
//          +---+---+---+
//          | X | 8 | 9 |
//          +---+---+---+
//
//      The player 'X' win

const std = @import("std");
const print = std.debug.print;

/// print the board on the screen
pub fn show(board: [3][3]u8) void {
    print(
        \\
        \\+---+---+---+
        \\| {c} | {c} | {c} |
        \\+---+---+---+ 
        \\| {c} | {c} | {c} |
        \\+---+---+---+ 
        \\| {c} | {c} | {c} |
        \\+---+---+---+
        \\
        \\
    , .{
        board[0][0], board[0][1], board[0][2],
        board[1][0], board[1][1], board[1][2],
        board[2][0], board[2][1], board[2][2],
    });
}

/// check columns, lines and diagonales
pub fn check_winner(board: [3][3]u8) bool {
    const X: u16 = 'X' * 3;
    const O: u16 = 'O' * 3;

    // check lines
    var l1: u16 = @as(u16, board[0][0]) + @as(u16, board[0][1]) + @as(u16, board[0][2]);
    var l2: u16 = @as(u16, board[1][0]) + @as(u16, board[1][1]) + @as(u16, board[1][2]);
    var l3: u16 = @as(u16, board[2][0]) + @as(u16, board[2][1]) + @as(u16, board[2][2]);
    if (l1 == X or l1 == O) return true;
    if (l2 == X or l2 == O) return true;
    if (l3 == X or l3 == O) return true;

    // check columns
    var c1: u16 = @as(u16, board[0][0]) + @as(u16, board[1][0]) + @as(u16, board[2][0]);
    var c2: u16 = @as(u16, board[0][1]) + @as(u16, board[1][1]) + @as(u16, board[2][1]);
    var c3: u16 = @as(u16, board[0][2]) + @as(u16, board[1][2]) + @as(u16, board[2][2]);
    if (c1 == X or c1 == O) return true;
    if (c2 == X or c2 == O) return true;
    if (c3 == X or c3 == O) return true;

    // check diagonales
    var d1: u16 = @as(u16, board[0][0]) + @as(u16, board[1][1]) + @as(u16, board[2][2]);
    var d2: u16 = @as(u16, board[0][2]) + @as(u16, board[1][1]) + @as(u16, board[2][0]);
    if (d1 == X or d1 == O) return true;
    if (d2 == X or d2 == O) return true;

    return false;
}

/// ask user to choose a case
pub fn getInput(player: u8) !u8 {
    var input: u8 = 0;

    // when leaving
    defer flush();
    errdefer print("Not a right input :)\n", .{});

    // prompt user
    print("player {c}: ", .{player});

    // get input
    input = try std.io.getStdIn().reader().readByte();

    // not 0 plz (out of bound)
    if (input == '0') return error.NotZeroPlz;

    // translate char to the actual number
    input = try std.fmt.charToDigit(input, 10);

    return input;
}

/// check if case already used
pub fn check(num: u8, board: [3][3]u8) ![2]u8 {
    errdefer print("case already used..\n", .{});

    // translate board number into (x,y)
    var i: u8 = (num - 1) / 3;
    var j: u8 = (num - 1) % 3;
    var case: u8 = board[i][j];

    if (case == 'X' or case == 'O') return error.AlreadyUsed;

    return [2]u8{ i, j };
}

/// round for a player
pub fn play(player: u8, board: *[3][3]u8) void {
    var input: u8 = 0;
    var coord: [2]u8 = undefined;

    // get the input
    while (true) {
        input = getInput(player) catch continue;
        coord = check(input, board.*) catch continue;
        break;
    }

    // put the player on the board
    board[coord[0]][coord[1]] = player;
    return;
}

/// flush stdin
pub fn flush() void {
    const reader = std.io.getStdIn().reader();
    while ((reader.readByte() catch return) != '\n') {}
}

pub fn main() void {
    // init the board
    var board = [3][3]u8{
        .{ '1', '2', '3' },
        .{ '4', '5', '6' },
        .{ '7', '8', '9' },
    };

    // init players
    var players = [2]u8{ 'X', 'O' };

    // main loop
    var round: u8 = 0;
    var winner: bool = false;
    while (winner == false) : (round += 1) {
        show(board);
        play(players[round % 2], &board);
        winner = check_winner(board);
        if (round == 8 and winner == false) break;
    }

    // show winner if any
    show(board);
    if (winner) {
        print("Player {c} WIN !!!\n", .{players[(round - 1) % 2]});
    } else {
        print("No Winner...\n", .{});
    }
}
