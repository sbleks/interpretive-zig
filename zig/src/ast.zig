const Token = @import("token.zig").Token;

const Node = struct { tokenLiteral: programTokenLiteral() };

const Statement = struct {
    Node: Node,
    fn statementNode() Node {}
};

const Expression = struct {
    Node: Node,
    fn expressionNode() Node {}
};

pub const Program = struct {
    Statements: []Statement,
};

fn programTokenLiteral(p: *Program) []const u8 {
    if (p.Statements.len > 0) {
        return p.Statements[0].Node.tokenLiteral();
    } else {
        return "";
    }
}

const LetStatement = struct {
    Token: Token,
    Name: Identifier,
    Value: Expression,
};

fn letTokenLiteral(ls: LetStatement) []const u8 {
    return ls.Token;
}

const Identifier = struct {
    Token: Token,
    Value: []const u8,
};
