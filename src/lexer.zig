const std = @import("std");
const Token = @import("token.zig").Token;

pub const Lexer = struct {
    const Self = @This();
    input: []const u8,
    position: usize = 0,
    read_position: usize = 0,
    ch: u8 = 0,

    pub fn init(input: []const u8) Self {
        var lex = Self{ .input = input };

        lex.readChar();

        return lex;
    }

    pub fn next_token(self: *Self) Token {
        self.skipWhitespace();

        var tok: Token = switch (self.ch) {
            '=' => Token.ASSIGN,
            ';' => Token.SEMICOLON,
            '(' => Token.LPAREN,
            ')' => Token.RPAREN,
            ',' => Token.COMMA,
            '+' => Token.PLUS,
            '{' => Token.LBRACE,
            '}' => Token.RBRACE,
            '!' => Token.BANG,
            '-' => Token.MINUS,
            '/' => Token.SLASH,
            '*' => Token.ASTERISK,
            '<' => Token.LT,
            '>' => Token.GT,
            0 => Token.EOF,
            'a'...'z', 'A'...'Z', '_' => {
                const ident = self.readIdentifier();
                var tok = Token.lookupIdent(ident);
                return tok;
            },
            '0'...'9' => {
                const int = self.readInteger();

                return Token{ .INT = int };
            },
            else => Token.ILLEGAL,
        };
        self.readChar();
        return tok;
    }

    fn skipWhitespace(self: *Self) void {
        while (self.ch == ' ' or self.ch == '\t' or self.ch == '\n' or self.ch == '\r') {
            self.readChar();
        }
    }

    fn readChar(self: *Self) void {
        // std.log.warn("position: {}, char: {u}", .{ self.position, self.ch });

        if (self.read_position >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.read_position];
        }
        self.position = self.read_position;
        self.read_position += 1;
    }

    fn readIdentifier(self: *Self) []const u8 {
        var position = self.position;

        while (isLetter(self.ch)) {
            self.readChar();
        }

        return self.input[position..self.position];
    }

    fn readInteger(self: *Self) []const u8 {
        var position = self.position;

        while (isInteger(self.ch)) {
            self.readChar();
        }

        return self.input[position..self.position];
    }

    fn isLetter(ch: u8) bool {
        return ('a' <= ch and ch <= 'z') or ('A' <= ch and ch <= 'Z') or (ch == '_');
    }

    fn isInteger(ch: u8) bool {
        return '0' <= ch and ch <= '9';
    }
};

const expectEqualDeep = std.testing.expectEqualDeep;

test "Basic Input" {
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

test "Multi-line Input" {
    const input =
        \\    let five = 5;
        \\    let ten = 10;
        \\    let add = fn(x, y) {
        \\        x + y;
        \\    };
        \\    let result = add(five, ten);
    ;

    var lex = Lexer.init(input);

    const expected_tokens = [_]Token{
        .LET,
        .{ .IDENT = "five" },
        .ASSIGN,
        .{ .INT = "5" },
        .SEMICOLON,
        .LET,
        .{ .IDENT = "ten" },
        .ASSIGN,
        .{ .INT = "10" },
        .SEMICOLON,
        .LET,
        .{ .IDENT = "add" },
        .ASSIGN,
        .FUNCTION,
        .LPAREN,
        .{ .IDENT = "x" },
        .COMMA,
        .{ .IDENT = "y" },
        .RPAREN,
        .LBRACE,
        .{ .IDENT = "x" },
        .PLUS,
        .{ .IDENT = "y" },
        .SEMICOLON,
        .RBRACE,
        .SEMICOLON,
        .LET,
        .{ .IDENT = "result" },
        .ASSIGN,
        .{ .IDENT = "add" },
        .LPAREN,
        .{ .IDENT = "five" },
        .COMMA,
        .{ .IDENT = "ten" },
        .RPAREN,
        .SEMICOLON,
        .EOF,
    };

    // // uncomment to print out Token.Tag fields
    // std.log.warn("Token.Tag fields:", .{});
    // inline for (std.meta.fields(Token)) |f| {
    //     std.log.warn("{s}", .{f.name});
    // }

    for (expected_tokens) |expected_token| {
        const tok = lex.next_token();

        // std.log.warn("token: {}, position: {}, char: {u}", .{ tok, lex.position, lex.ch });

        try expectEqualDeep(expected_token, tok);
    }
}

test "Extending the lexer" {
    const input =
        \\    let five = 5;
        \\    
        \\    let ten = 10;
        \\    
        \\    let add = fn(x, y) {
        \\        x + y;
        \\    };
        \\
        \\    let result = add(five, ten);
        \\    !-/*5;
        \\    5 < 10 > 5;
        \\
        \\    if (5 < 10) {
        \\        return true;
        \\    } else {
        \\        return false;
        \\    }
    ;

    var lex = Lexer.init(input);

    const expected_tokens = [_]Token{
        .LET,
        .{ .IDENT = "five" },
        .ASSIGN,
        .{ .INT = "5" },
        .SEMICOLON,
        .LET,
        .{ .IDENT = "ten" },
        .ASSIGN,
        .{ .INT = "10" },
        .SEMICOLON,
        .LET,
        .{ .IDENT = "add" },
        .ASSIGN,
        .FUNCTION,
        .LPAREN,
        .{ .IDENT = "x" },
        .COMMA,
        .{ .IDENT = "y" },
        .RPAREN,
        .LBRACE,
        .{ .IDENT = "x" },
        .PLUS,
        .{ .IDENT = "y" },
        .SEMICOLON,
        .RBRACE,
        .SEMICOLON,
        .LET,
        .{ .IDENT = "result" },
        .ASSIGN,
        .{ .IDENT = "add" },
        .LPAREN,
        .{ .IDENT = "five" },
        .COMMA,
        .{ .IDENT = "ten" },
        .RPAREN,
        .SEMICOLON,
        .BANG,
        .MINUS,
        .SLASH,
        .ASTERISK,
        .{ .INT = "5" },
        .SEMICOLON,
        .{ .INT = "5" },
        .LT,
        .{ .INT = "10" },
        .GT,
        .{ .INT = "5" },
        .SEMICOLON,

        .IF,
        .LPAREN,
        .{ .INT = "5" },
        .LT,
        .{ .INT = "10" },
        .RPAREN,
        .LBRACE,
        .RETURN,
        .TRUE,
        .SEMICOLON,
        .RBRACE,
        .ELSE,
        .LBRACE,
        .RETURN,
        .FALSE,
        .SEMICOLON,
        .RBRACE,

        // .{ .INT = "10" },
        // .EQUAL,
        // .{ .INT = "10" },
        // .SEMICOLON,
        // .{ .INT = "10" },
        // .NOT_EQUAL,
        // .{ .INT = "9" },
        // .SEMICOLON,

        .EOF,
    };

    for (expected_tokens) |expected_token| {
        const tok = lex.next_token();

        // std.log.warn("token: {}, position: {}, char: {u}", .{ tok, lex.position, lex.ch });

        try expectEqualDeep(expected_token, tok);
    }
}
