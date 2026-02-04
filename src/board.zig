const Move = @import("puzzle_state.zig").Move;
const array = @import("array_utils.zig");

pub const BoardType = u4;

pub fn Board(comptime width: usize, comptime height: usize) type {
    return [width * height]BoardType;
}

pub fn applyMoveToBoard(comptime width: usize, comptime height: usize, array_board: *Board(width, height), move: Move) !void {
    const zero_i = try array.findZeroInArray(width * height, array_board.*);
    const to_i = nextBoardZeroIndex(width, height, zero_i, move) orelse return error.InvalidMove;
    try array.switchItemsInArray(width * height, array_board, zero_i, to_i);
}

pub fn nextBoardZeroIndex(comptime width: usize, comptime height: usize, zero_i: usize, move: Move) ?usize {
    return switch (move) {
        .Up => if (zero_i >= width) zero_i - width else null,
        .Down => if (zero_i + width < width * height) zero_i + width else null,
        .Left => if (zero_i % width != 0) zero_i - 1 else null,
        .Right => if (zero_i % width != width - 1) zero_i + 1 else null,
    };
}

pub fn applyMovesToBoard(
    comptime width: usize,
    comptime height: usize,
    array_board: *Board(width, height),
    moves: []const Move,
) !void {
    for (moves) |move| {
        try applyMoveToBoard(width, height, array_board, move);
    }
}
