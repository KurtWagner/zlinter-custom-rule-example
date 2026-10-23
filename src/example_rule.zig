//! Example rule for playing around with zlinter and zigs AST

const std = @import("std");
const zlinter = @import("zlinter");

pub const Config = struct {
    severity: zlinter.rules.LintProblemSeverity = .@"error",
};

pub fn buildRule(options: zlinter.rules.RuleOptions) zlinter.rules.LintRule {
    _ = options;

    return zlinter.rules.LintRule{
        .rule_id = "example_rule",
        .run = &run,
    };
}

fn run(
    rule: zlinter.rules.LintRule,
    session: *zlinter.session.LintSession,
    doc: *const zlinter.session.LintDocument,
    options: zlinter.rules.RunOptions,
) zlinter.rules.RunError!?zlinter.results.LintResult {
    const config = options.getConfig(Config);

    const session_arena = session.runtime.sessionArena();

    var lint_problems = std.ArrayList(zlinter.results.LintProblem).empty;

    const tree = doc.tree(session);
    var token: std.zig.Ast.TokenIndex = 0;
    while (token < tree.tokens.len) : (token += 1) {
        if (tree.tokens.items(.tag)[token] == .string_literal) {
            const name = tree.tokenSlice(token);
            if (std.ascii.findIgnoreCase(name, "Hello") != null) {
                try lint_problems.append(session_arena, .{
                    .rule_id = rule.rule_id,
                    .severity = config.severity,
                    .start = .startOfToken(tree, token),
                    .end = .endOfToken(tree, token),
                    .message = try session_arena.dupe(u8, "No hello!"),
                });
            }
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(
            doc.file_id,
            try lint_problems.toOwnedSlice(session_arena),
        )
    else
        null;
}
