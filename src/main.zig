const std = @import("std");

pub fn main() !void {
    const input =
        \\let five = 5; let ten = 10;
        \\let add = fn(x, y) { x + y;
        \\};
        \\let result = add(five, ten);
    ;
    _ = input;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
