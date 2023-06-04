const std = @import("std");
const repl = @import("repl.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut();
    const reader = std.io.getStdIn();

    try repl.start(reader, stdout);
}
