const std = @import("std");

const state = @import("../puzzle_state.zig");
const board = @import("../board.zig");
const array_utils = @import("../array_utils.zig");

const Board = board.Board;
const Move = state.Move;
const PuzzleState = state.PuzzleState;
const PuzzleSolution = state.PuzzleSolution;
const Queue = @import("../queue.zig").Queue;

pub fn solvePuzzleBFS(
    allocator: std.mem.Allocator,
    comptime width: usize,
    comptime height: usize,
    start: *Board(width, height),
    goal: *const Board(width, height),
) !PuzzleSolution {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    const moves = [4]Move{ .Up, .Down, .Left, .Right };
    const State = PuzzleState(width, height);
    var nodes_count: usize = 1;

    var state_queue = Queue(*State).init(arena_alloc);
    defer state_queue.deinit();

    var visited = std.AutoHashMap(Board(width, height), void).init(arena_alloc);
    defer visited.deinit();

    const start_state = try arena_alloc.create(State);
    start_state.* = .{
        .board = start.*,
        .zero_index = try array_utils.findZeroInArray(width * height, start.*),
        .parent = null,
        .move = null,
    };    defer arena_alloc.destroy(start_state);


    try state_queue.enqueue(start_state);
    try visited.put(start_state.board, {});

    while (state_queue.dequeue()) |current| {
        if (array_utils.isArrayEqual(width * height, &current.board, goal))
            return .{ .moves = try state.tracePuzzleStateMoves(allocator, height, width, current), .number_of_nodes = nodes_count};

        for (moves) |move| {
            const new_zero_index = board.nextBoardZeroIndex(width, height, current.zero_index, move) orelse continue;

            var new_board = current.board;
            try array_utils.switchItemsInArray(width * height, &new_board, current.zero_index, new_zero_index);

            if (visited.contains(new_board)) continue;

            const child = try arena_alloc.create(State);
            child.* = .{
                .board = new_board,
                .zero_index = new_zero_index,
                .parent = current,
                .move = move,
            };

            try visited.put(new_board, {});
            try state_queue.enqueue(child);
            nodes_count += 1;
        }
    }

    return error.NoSolution;
}
