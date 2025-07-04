pub fn main() !void {
    try std.io.getStdOut().writeAll("Hello world!\n");
}

const std = @import("std");
