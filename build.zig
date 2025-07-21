pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    // zig build run

    const module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = module,
    });
    const run_step = b.step("run", "Run main");
    const run_exe = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_exe.addArgs(args);
    }
    run_step.dependOn(&run_exe.step);

    // zig build lint

    const lint_cmd = b.step("lint", "Run linter");
    lint_cmd.dependOn(step: {
        var builder = zlinter.builder(b, .{ .target = target, .optimize = optimize });
        builder.addPaths(.{ .exclude = &.{b.path("src/example_rule.zig")} });
        builder.addRule(
            .{
                .custom = .{
                    .name = "example_rule",
                    .path = "src/example_rule.zig",
                },
            },
            // Config for custom rule:
            .{ .severity = .@"error" },
        );
        break :step builder.build();
    });
}

const std = @import("std");
const zlinter = @import("zlinter");
