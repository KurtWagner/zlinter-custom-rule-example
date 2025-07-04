//! Example rule for playing around with zlinter and zigs AST

const std = @import("std");
const zlinter = @import("zlinter");

pub const Config = struct {
    severity: zlinter.LintProblemSeverity = .warning,
};

pub fn buildRule(options: zlinter.LintRuleOptions) zlinter.LintRule {
    _ = options;

    return zlinter.LintRule{
        .rule_id = "example_rule",
        .run = &run,
    };
}

fn run(
    rule: zlinter.LintRule,
    _: zlinter.LintContext,
    doc: zlinter.LintDocument,
    allocator: std.mem.Allocator,
    options: zlinter.LintOptions,
) error{OutOfMemory}!?zlinter.LintResult {
    const config = options.getConfig(Config);

    var lint_problems = std.ArrayListUnmanaged(zlinter.LintProblem).empty;
    defer lint_problems.deinit(allocator);

    const tree = doc.handle.tree;
    var token: std.zig.Ast.TokenIndex = 0;
    while (token < tree.tokens.len) : (token += 1) {
        if (tree.tokens.items(.tag)[token] == .string_literal) {
            const name = tree.tokenSlice(token);
            if (std.ascii.indexOfIgnoreCase(name, "Hello") != null) {
                try lint_problems.append(allocator, .{
                    .rule_id = rule.rule_id,
                    .severity = config.severity,
                    .start = .startOfToken(tree, token),
                    .end = .endOfToken(tree, token),
                    .message = try allocator.dupe(u8, "No hello!"),
                });
            }
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.LintResult.init(
            allocator,
            doc.path,
            try lint_problems.toOwnedSlice(allocator),
        )
    else
        null;
}
