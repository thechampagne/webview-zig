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
    objectFile.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++14"}});
    objectFile.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            objectFile.addIncludePath(std.build.LazyPath.relative("external/libs/Microsoft.Web.WebView2.1.0.2365.46/build/native/include/"));
            objectFile.linkSystemLibrary("ole32");
            objectFile.linkSystemLibrary("shlwapi");
            objectFile.linkSystemLibrary("version");
        },
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
    staticLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++14"}});
    staticLib.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            staticLib.addIncludePath(std.build.LazyPath.relative("external/libs/Microsoft.Web.WebView2.1.0.2365.46/build/native/include/"));
            staticLib.linkSystemLibrary("ole32");
            staticLib.linkSystemLibrary("shlwapi");
            staticLib.linkSystemLibrary("version");
        },
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
    sharedLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++14"}});
    sharedLib.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            sharedLib.addIncludePath(std.build.LazyPath.relative("external/libs/Microsoft.Web.WebView2.1.0.2365.46/build/native/include/"));
            sharedLib.linkSystemLibrary("ole32");
            sharedLib.linkSystemLibrary("shlwapi");
            sharedLib.linkSystemLibrary("version");
        },
        .macos => sharedLib.linkFramework("WebKit"),
        else => {
            sharedLib.linkSystemLibrary("gtk+-3.0");
            sharedLib.linkSystemLibrary("webkit2gtk-4.0");
        }
    }
    b.installArtifact(sharedLib);
}
