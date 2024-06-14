const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("webview", .{
        .root_source_file = b.path("src/webview.zig"),
        //.dependencies = &[_]std.Build.ModuleDependency{},
    });

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // const objectFile = b.addObject(.{
    //     .name = "webviewObject",
    //     .optimize = optimize,
    //     .target = target,
    // });
    // objectFile.defineCMacro("WEBVIEW_STATIC", null);
    // objectFile.linkLibCpp();
    // switch(target.os_tag orelse @import("builtin").os.tag) {
    //     .windows => {
    //         objectFile.addCSourceFile(.{ .file = b.path("external/webview/webview.cc") .flags = &.{"-std=c++14"}});
    //         objectFile.addIncludePath(std.build.LazyPath.relative("external/WebView2/"));
    //         objectFile.linkSystemLibrary("ole32");
    //         objectFile.linkSystemLibrary("shlwapi");
    //         objectFile.linkSystemLibrary("version");
    //         objectFile.linkSystemLibrary("advapi32");
    //         objectFile.linkSystemLibrary("shell32");
    //         objectFile.linkSystemLibrary("user32");
    //     },
    //     .macos => {
    //         objectFile.addCSourceFile(.{ .file = b.path("external/webview/webview.cc") .flags = &.{"-std=c++11"}});
    //         objectFile.linkFramework("WebKit");
    //     },
    //     else => {
    //         objectFile.addCSourceFile(.{ .file = b.path("external/webview/webview.cc") .flags = &.{"-std=c++11"}});
    //         objectFile.linkSystemLibrary("gtk+-3.0");
    //         objectFile.linkSystemLibrary("webkit2gtk-4.0");
    //     }
    // }

    const staticLib = b.addStaticLibrary(.{
        .name = "webviewStatic",
        .optimize = optimize,
        .target = target,
    });
    staticLib.defineCMacro("WEBVIEW_STATIC", null);
    staticLib.linkLibCpp();
    switch (target.query.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            staticLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++14"} });
            staticLib.addIncludePath(b.path("external/WebView2/"));
            staticLib.linkSystemLibrary("ole32");
            staticLib.linkSystemLibrary("shlwapi");
            staticLib.linkSystemLibrary("version");
            staticLib.linkSystemLibrary("advapi32");
            staticLib.linkSystemLibrary("shell32");
            staticLib.linkSystemLibrary("user32");
        },
        .macos => {
            staticLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++11"} });
            staticLib.linkFramework("WebKit");
        },
        .freebsd => {
            staticLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++11"} });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/cairo/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/gtk-3.0/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/glib-2.0/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/lib/glib-2.0/include/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/webkitgtk-4.0/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/pango-1.0/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/harfbuzz/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/gdk-pixbuf-2.0/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/atk-1.0/" });
            staticLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/libsoup-3.0/" });
            staticLib.linkSystemLibrary("gtk-3");
            staticLib.linkSystemLibrary("webkit2gtk-4.0");
        },
        else => {
            staticLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++11"} });
            staticLib.linkSystemLibrary("gtk+-3.0");
            staticLib.linkSystemLibrary("webkit2gtk-4.0");
        },
    }
    b.installArtifact(staticLib);

    const sharedLib = b.addSharedLibrary(.{
        .name = "webviewShared",
        .optimize = optimize,
        .target = target,
    });
    sharedLib.defineCMacro("WEBVIEW_BUILD_SHARED", null);
    sharedLib.linkLibCpp();
    switch (target.query.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            sharedLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++14"} });
            sharedLib.addIncludePath(b.path("external/WebView2/"));
            sharedLib.linkSystemLibrary("ole32");
            sharedLib.linkSystemLibrary("shlwapi");
            sharedLib.linkSystemLibrary("version");
            sharedLib.linkSystemLibrary("advapi32");
            sharedLib.linkSystemLibrary("shell32");
            sharedLib.linkSystemLibrary("user32");
        },
        .macos => {
            sharedLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++11"} });
            sharedLib.linkFramework("WebKit");
        },
        .freebsd => {
            sharedLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++11"} });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/cairo/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/gtk-3.0/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/glib-2.0/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/lib/glib-2.0/include/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/webkitgtk-4.0/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/pango-1.0/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/harfbuzz/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/gdk-pixbuf-2.0/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/atk-1.0/" });
            sharedLib.addIncludePath(.{ .cwd_relative = "/usr/local/include/libsoup-3.0/" });
            sharedLib.linkSystemLibrary("gtk-3");
            sharedLib.linkSystemLibrary("webkit2gtk-4.0");
        },
        else => {
            sharedLib.addCSourceFile(.{ .file = b.path("external/webview/webview.cc"), .flags = &.{"-std=c++11"} });
            sharedLib.linkSystemLibrary("gtk+-3.0");
            sharedLib.linkSystemLibrary("webkit2gtk-4.0");
        },
    }
    b.installArtifact(sharedLib);
}
