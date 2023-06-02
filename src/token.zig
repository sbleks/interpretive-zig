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
};

pub const Lexer = struct {
    const Self = @This();
    input: []const u8,
    position: usize = 0,
    read_position: usize = 0,
    ch: u8 = 0,

    pub fn init(input: []const u8) Self {
        var lex = Self{ .input = input };

        lex.read_char();

        return lex;
    }

    fn read_char(self: *Self) void {
        if (self.read_position >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.read_position];
        }
        self.position = self.read_position;
        self.read_position += 1;
    }

    pub fn next_token(self: *Self) Token {
        var tok: Token = switch (self.ch) {
            '=' => Token.ASSIGN,
            '+' => Token.PLUS,
            '(' => Token.LPAREN,
            ')' => Token.RPAREN,
            '{' => Token.LBRACE,
            '}' => Token.RBRACE,
            ',' => Token.COMMA,
            ';' => Token.SEMICOLON,
            0 => Token.EOF,
            else => Token.ILLEGAL,
        };
        self.read_char();
        return tok;
    }
};

const expectEqualDeep = std.testing.expectEqualDeep;
test "TestNextToken" {
    const input = "=+(){},;";
    var lex = Lexer.init(input);

    var tokens = [_]Token{
        .ASSIGN,
        .PLUS,
        .LPAREN,
        .RPAREN,
        .LBRACE,
        .RBRACE,
        .COMMA,
        .SEMICOLON,
        .EOF,
    };

    for (tokens) |token| {
        const tok = lex.next_token();

        try expectEqualDeep(token, tok);
    }
}
