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

    pub fn lookupIdent(ident: []const u8) Token {
        if (std.mem.eql(u8, ident, "let")) {
            return .LET;
        } else if (std.mem.eql(u8, ident, "fn")) {
            return .FUNCTION;
        }

        return .{ .IDENT = ident };
    }
};
