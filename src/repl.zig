const std = @import("std");
const Token = @import("token.zig").Token;
const Lexer = @import("lexer.zig").Lexer;

const PROMPT = ">> ";

pub fn start(in: std.fs.File, out: std.fs.File) !void {
    const reader = in.reader();
    const stdout = out.writer();
    while (true) {
        try stdout.print("{s}", .{PROMPT});
        var buf: [1000]u8 = undefined;
        const user_input = try reader.readUntilDelimiterOrEof(buf[0..], '\n') orelse "";
        var lex = Lexer.init(user_input);

        while (true) {
            const tok = lex.next_token();
            if (tok == Token.EOF) {
                break;
            }
            try stdout.print("{}\n", .{tok});
        }
    }
}
