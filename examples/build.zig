const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const webview = b.dependency("webview", .{});
    
    const basic = b.addExecutable(.{
        .name = "basic",
        .root_module = b.addModule("basic", .{
            .root_source_file = b.path("basic.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    basic.root_module.addImport("webview", webview.module("webview"));
    basic.linkLibC();
    basic.linkSystemLibrary("webview");
    b.installArtifact(basic);
    const bind = b.addExecutable(.{
        .name = "bind",
        .root_module = b.addModule("bind", .{
            .root_source_file = b.path("bind.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    bind.root_module.addImport("webview", webview.module("webview"));
    bind.linkLibC();
    bind.linkSystemLibrary("webview");
    b.installArtifact(bind);
    const eval = b.addExecutable(.{
        .name = "eval",
        .root_module = b.addModule("eval", .{
            .root_source_file = b.path("eval.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    eval.root_module.addImport("webview", webview.module("webview"));
    eval.linkLibC();
    eval.linkSystemLibrary("webview");
    b.installArtifact(eval);

    const dispatch = b.addExecutable(.{
        .name = "dispatch",
        .root_module = b.addModule("dispatch", .{
            .root_source_file = b.path("dispatch.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    dispatch.root_module.addImport("webview", webview.module("webview"));
    dispatch.linkLibC();
    dispatch.linkSystemLibrary("webview");
    b.installArtifact(dispatch);
    const basic_cmd = b.addRunArtifact(basic);
    const bind_cmd = b.addRunArtifact(bind);
    const eval_cmd = b.addRunArtifact(eval);
    const dispatch_cmd = b.addRunArtifact(dispatch);
    basic_cmd.step.dependOn(b.getInstallStep());
    bind_cmd.step.dependOn(b.getInstallStep());
    eval_cmd.step.dependOn(b.getInstallStep());
    dispatch_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        basic_cmd.addArgs(args);
        bind_cmd.addArgs(args);
        eval_cmd.addArgs(args);
        dispatch_cmd.addArgs(args);
    }
    const basic_step = b.step("basic", "Run the app");
    const bind_step = b.step("bind", "Run the app");
    const eval_step = b.step("eval", "Run the app");
    const dispatch_step = b.step("dispatch", "Run the app");
    basic_step.dependOn(&basic_cmd.step);
    bind_step.dependOn(&bind_cmd.step);
    eval_step.dependOn(&eval_cmd.step);
    dispatch_step.dependOn(&dispatch_cmd.step);
}
