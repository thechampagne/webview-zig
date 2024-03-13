const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("webview", .{
        .source_file = .{ .path = "src/webview.zig" },
        .dependencies = &[_]std.Build.ModuleDependency{},
    });

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const objectFile = b.addObject(.{
        .name = "webviewObject",
        .optimize = optimize,
        .target = target,
    });
    objectFile.defineCMacro("WEBVIEW_STATIC", null);
    objectFile.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
    objectFile.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => @compileError("Not supported platform"),
        .macos => objectFile.linkFramework("WebKit"),
        else => {
            objectFile.linkSystemLibrary("gtk+-3.0");
            objectFile.linkSystemLibrary("webkit2gtk-4.0");
        }
    }

    const staticLib = b.addStaticLibrary(.{
        .name = "webviewStatic",
        .optimize = optimize,
        .target = target,
    });
    staticLib.defineCMacro("WEBVIEW_STATIC", null);
    staticLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
    staticLib.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => @compileError("Not supported platform"),
        .macos => staticLib.linkFramework("WebKit"),
        else => {
            staticLib.linkSystemLibrary("gtk+-3.0");
            staticLib.linkSystemLibrary("webkit2gtk-4.0");
        }
    }
    b.installArtifact(staticLib);

    const sharedLib = b.addSharedLibrary(.{
        .name = "webviewShared",
        .optimize = optimize,
        .target = target,
    });
    sharedLib.defineCMacro("WEBVIEW_BUILD_SHARED", null);
    sharedLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
    sharedLib.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => @compileError("Not supported platform"),
        .macos => sharedLib.linkFramework("WebKit"),
        else => {
            sharedLib.linkSystemLibrary("gtk+-3.0");
            sharedLib.linkSystemLibrary("webkit2gtk-4.0");
        }
    }
    b.installArtifact(sharedLib);
}
