const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const webview = b.dependency("webview", .{});

    const webviewRaw = b.addTranslateC(.{
        .root_source_file = webview.path("core/include/webview/webview.h"),
        .optimize = optimize,
        .target = target,
    }).createModule();

    _ = b.addModule("webview", .{
        .root_source_file = b.path("src/webview.zig"),
        //.dependencies = &[_]std.Build.ModuleDependency{},
    }).addImport("webviewRaw", webviewRaw);

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
    const staticLib = b.addLibrary(.{
        .name = "webviewStatic",
        .root_module = b.addModule("webviewStatic", .{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = .static,
    });
    staticLib.addIncludePath(webview.path("core/include/webview/"));
    staticLib.root_module.addCMacro("WEBVIEW_STATIC", "");
    staticLib.linkLibCpp();
    switch (target.query.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            staticLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++14"} });
            staticLib.addIncludePath(b.path("external/WebView2/"));
            staticLib.linkSystemLibrary("ole32");
            staticLib.linkSystemLibrary("shlwapi");
            staticLib.linkSystemLibrary("version");
            staticLib.linkSystemLibrary("advapi32");
            staticLib.linkSystemLibrary("shell32");
            staticLib.linkSystemLibrary("user32");
        },
        .macos => {
            staticLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++11"} });
            staticLib.linkFramework("WebKit");
        },
        .freebsd => {
            staticLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++11"} });
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
            staticLib.linkSystemLibrary("webkit2gtk-4.1");
        },
        else => {
            staticLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++11"} });
            staticLib.linkSystemLibrary("gtk+-3.0");
            staticLib.linkSystemLibrary("webkit2gtk-4.1");
        },
    }
    b.installArtifact(staticLib);

    const sharedLib = b.addLibrary(.{
        .name = "webviewShared",
        .root_module = b.addModule("webviewShared", .{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = .dynamic,
    });
    sharedLib.addIncludePath(webview.path("core/include/webview/"));
    sharedLib.root_module.addCMacro("WEBVIEW_BUILD_SHARED", "");
    sharedLib.linkLibCpp();
    switch (target.query.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            sharedLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++14"} });
            sharedLib.addIncludePath(b.path("external/WebView2/"));
            sharedLib.linkSystemLibrary("ole32");
            sharedLib.linkSystemLibrary("shlwapi");
            sharedLib.linkSystemLibrary("version");
            sharedLib.linkSystemLibrary("advapi32");
            sharedLib.linkSystemLibrary("shell32");
            sharedLib.linkSystemLibrary("user32");
        },
        .macos => {
            sharedLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++11"} });
            sharedLib.linkFramework("WebKit");
        },
        .freebsd => {
            sharedLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++11"} });
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
            sharedLib.linkSystemLibrary("webkit2gtk-4.1");
        },
        else => {
            sharedLib.addCSourceFile(.{ .file = webview.path("core/src/webview.cc"), .flags = &.{"-std=c++11"} });
            sharedLib.linkSystemLibrary("gtk+-3.0");
            sharedLib.linkSystemLibrary("webkit2gtk-4.1");
        },
    }
    b.installArtifact(sharedLib);

    const unit_tests = b.addTest(.{
        .root_module = b.addModule(
            "webviewTest",
            .{
                .root_source_file = b.path("src/test.zig"),
                .target = target,
                .optimize = optimize,
            },
        ),
    });
    unit_tests.root_module.addImport("webviewRaw", webviewRaw);
    unit_tests.linkLibrary(staticLib);

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
