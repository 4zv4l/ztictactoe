const std = @import("std");
const print = std.debug.print;

// try to read a u8 from user input
fn readUInt() !u8 {
    var stdin = std.io.getStdIn().reader();
    var buff: [5]u8 = undefined;
    const len = try stdin.read(&buff);
    if (len == buff.len and buff[len - 1] != '\n') {
        while (try stdin.readByte() != '\n') {}
        return error.InputTooLong;
    }
    return try std.fmt.parseUnsigned(u8, buff[0 .. len - 1], 10);
}

// check if there is a winner horizontally, vertically or diagonally
fn winner(board: [9]u8) bool {
    return board[0] == board[1] and board[1] == board[2] or
        board[3] == board[4] and board[4] == board[5] or
        board[6] == board[7] and board[7] == board[8] or
        board[0] == board[3] and board[3] == board[6] or
        board[1] == board[4] and board[4] == board[7] or
        board[2] == board[5] and board[5] == board[8] or
        board[0] == board[4] and board[4] == board[8] or
        board[2] == board[4] and board[4] == board[6];
}

// draw the board and clear the screen using ANSI escape sequence
fn draw(board: [9]u8) void {
    print("\x1bc" ++
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
        board[0], board[1], board[2],
        board[3], board[4], board[5],
        board[6], board[7], board[8],
    });
}

// play a round, loop until the user chooses a valid case
fn play(board: *[9]u8, current_player: u8) void {
    while (true) {
        print("Player '{c}': ", .{current_player});
        const choice = readUInt() catch {
            print("Please enter a valid number between 1-9\n", .{});
            continue;
        };

        if (choice == 0 or choice > 9) {
            print("Please enter a number between 1-9\n", .{});
            continue;
        }

        if (board[choice - 1] != std.fmt.digitToChar(choice, .lower)) {
            print("This case is already played, try another one\n", .{});
            continue;
        }

        board[choice - 1] = current_player;
        break;
    }
}

pub fn main() void {
    const players = [2]u8{ 'X', 'O' };
    var board = [9]u8{
        '1', '2', '3',
        '4', '5', '6',
        '7', '8', '9',
    };
    var round: u8 = 0;

    while (round < 9) : (round += 1) {
        const current_player = players[round % 2];
        draw(board);
        play(&board, current_player);
        if (winner(board)) {
            draw(board);
            print("Congrats to '{c}' !\n", .{current_player});
            break;
        }
    } else print("No one win..\n", .{});
}
