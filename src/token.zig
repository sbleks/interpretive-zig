const std = @import("std");

pub const Token = union(enum) {
    ILLEGAL,
    EOF,
    IDENT: []const u8,
    INT: []const u8,
    ASSIGN,
    PLUS,
    COMMA,
    SEMICOLON,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,
    FUNCTION,
    LET,
    BANG,
    MINUS,
    SLASH,
    ASTERISK,
    LT,
    GT,
    TRUE,
    FALSE,
    IF,
    ELSE,
    RETURN,
    EQUAL,
    NOT_EQUAL,

    pub fn lookupIdent(ident: []const u8) Token {
        if (std.mem.eql(u8, ident, "let")) {
            return .LET;
        } else if (std.mem.eql(u8, ident, "fn")) {
            return .FUNCTION;
        } else if (std.mem.eql(u8, ident, "fn")) {
            return .FUNCTION;
        } else if (std.mem.eql(u8, ident, "true")) {
            return .TRUE;
        } else if (std.mem.eql(u8, ident, "false")) {
            return .FALSE;
        } else if (std.mem.eql(u8, ident, "if")) {
            return .IF;
        } else if (std.mem.eql(u8, ident, "else")) {
            return .ELSE;
        } else if (std.mem.eql(u8, ident, "return")) {
            return .RETURN;
        }

        return .{ .IDENT = ident };
    }

    pub fn print(self: Token, writer: anytype) !void {
        switch (self) {
            .IDENT => try writer.print("{}{{ .{s} = \"{s}\" }})\n", .{ @TypeOf(self), @tagName(self), self.IDENT }),
            .INT => try writer.print("{}{{ .{s} = \"{s}\" }})\n", .{ @TypeOf(self), @tagName(self), self.INT }),
            inline else => try writer.print("{}\n", .{self}),
        }
    }
};
