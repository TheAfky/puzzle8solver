const std = @import("std");

const queue = @import("queue.zig");
const array_utils = @import("array_utils.zig");
const board = @import("board.zig");
const state = @import("puzzle_state.zig");
const bfs = @import("solvers/bfs.zig");

pub const Move = state.Move;
pub const PuzzleSolution = state.PuzzleSolution;
pub const applyMoveToBoard = board.applyMoveToBoard;
pub const Board = board.Board;
pub const BoardType = board.BoardType;
pub const solvePuzzleBFS = bfs.solvePuzzleBFS;

fn BFSTestHelper(comptime width: usize, comptime height: usize, start: *Board(width, height), goal: Board(width, height)) !void {
    const allocator = std.testing.allocator;

    var solution = try solvePuzzleBFS(
        allocator,
        width,
        height,
        start,
        &goal,
    );
    defer solution.deinit(allocator);

    std.debug.print("{}x{} BFS test\n", .{width, height});
    for (solution.items) |step| {
        std.debug.print("Step: {}\n", .{step});
    }

    try board.applyMovesToBoard(width, height, start, solution.items);

    try std.testing.expect(std.mem.eql(BoardType, start, &goal));
}

// solution right
test "BFS 3x3 1 move test" {
    var start = Board(3, 3){ 1, 2, 3, 4, 5, 6, 7, 0, 8 };
    const goal = Board(3, 3){ 1, 2, 3, 4, 5, 6, 7, 8, 0 };
    try BFSTestHelper(3, 3, &start, goal);
}

// solution down right down
test "BFS 3x3 4 move test" {
    var start = Board(3, 3){ 1, 0, 3, 4, 2, 5, 7, 8, 6 };
    const goal = Board(3, 3){ 1, 2, 3, 4, 5, 6, 7, 8, 0 };
    try BFSTestHelper(3, 3, &start, goal);
}

test "BFS 3x3 random test" {
    var start = Board(3, 3){ 3, 4, 1, 0, 7, 2, 6, 5, 8 };
    const goal = Board(3, 3){ 1, 2, 3, 4, 5, 6, 7, 8, 0 };
    try BFSTestHelper(3, 3, &start, goal);
}

// solution right
test "BFS 4x4 1 move test" {
    var start = Board(4, 4){ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0, 15 };
    const goal = Board(4, 4){ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0 };
    try BFSTestHelper(4, 4, &start, goal);
}

// test "4x4 random test" {
//     var start = Board(4, 4){ 1, 15, 9, 14, 5, 6, 11, 8, 3, 10, 7, 12, 13, 4, 0, 2 };
//     const goal = Board(4, 4){ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0 };
//     try BFSTestHelper(4, 4, &start, goal);
// }
