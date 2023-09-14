const std = @import("std");
const ast = @import("ast.zig");
const lexer = @import("lexer.zig");
const token = @import("token.zig");

const Parser = struct {
    const Self = @This();
    l: lexer.Lexer,
    cur_token: ?token.Token,
    peek_token: ?token.Token,

    pub fn nextToken(self: *Self) void {
        self.cur_token = self.peek_token;
        self.peek_token = self.l.next_token();
    }

    pub fn parseProgram(self: *Self) []u8 {
        _ = self;
        return [_]u8{ 1, 2 };
    }

    pub fn new(l: lexer.Lexer) Self {
        const p = Parser{ .l = l, .cur_token = null, .peek_token = null };

        p.nextToken();
        p.nextToken();

        return p;
    }
};

test "Parse let statements" {
    const input =
        \\let x = 5;
        \\let y = 10;
        \\let foobar = 838383;
    ;

    var l = lexer.Lexer.init(input);
    var p = Parser.new(l);
    var program = p.parseProgram();
    if (program.len == 0) {
        std.log.err("parseProgram() returned null", .{});
    }

    if (program.Statements.len != 3) {
        std.log.err("program.Statements does not contain 3 statements, got={d}", program.Statements.len);
    }
}
