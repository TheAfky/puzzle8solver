const std = @import("std");

const Board = @import("board.zig").Board;

pub const Move = enum {
    Up,
    Down,
    Left,
    Right,
};

pub fn PuzzleState(comptime width: usize, comptime height: usize) type {
    return struct {
        const Self = @This();
        board: Board(width, height),
        zero_index: usize,
        parent: ?*Self,
        move: ?Move,
    };
}

pub const PuzzleSolution = struct {
    const Self = @This();
    allocator: std.mem.Allocator,
    moves: std.ArrayList(Move),
    number_of_nodes: usize,

    pub fn init(allocator: std.mem.Allocator, moves: std.ArrayList(Move), number_of_nodes: usize) !Self {
        var self: Self = undefined;
        self.allocator = allocator;
        self.moves = moves;
        self.number_of_nodes = number_of_nodes;

        return self;
    }

    pub fn deinit(self: *Self) void {
        self.moves.deinit(self.allocator);
    }
};

pub fn tracePuzzleStateMoves(allocator: std.mem.Allocator, comptime width: usize, comptime height: usize, correctPuzzleState: *PuzzleState(width, height)) !std.ArrayList(Move) {
    const State = PuzzleState(width, height);

    var result: std.ArrayList(Move) = .empty;
    var puzzle_state: ?*State = correctPuzzleState;

    while (puzzle_state) |state| {
        if (state.move) |move| {
            try result.append(allocator, move);
        }
        puzzle_state = state.parent;
    }

    std.mem.reverse(Move, result.items);
    return result;
}
