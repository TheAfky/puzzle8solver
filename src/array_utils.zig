const std = @import("std");

const BoardType = @import("board.zig").BoardType;

pub fn findZeroInArray(comptime size: usize, array: [size]BoardType) !usize {
    for (0..size) |i| {
        if (array[i] == 0) return i;
    }
    return error.ZeroNotFound;
}

pub fn switchItemsInArray(comptime size: usize, array: *[size]BoardType, from_i: usize, to_i: usize) !void {
    if (from_i >= size or to_i >= size) {
        return error.IndexOutOfBounds;
    }
    std.mem.swap(BoardType, &array[from_i], &array[to_i]);
}

pub fn isArrayEqual(comptime size: usize, a: *const [size]BoardType, b: *const [size]BoardType) bool {
    return std.mem.eql(BoardType, a, b);
}
