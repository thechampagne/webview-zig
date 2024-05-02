# webview-zig

[![](https://img.shields.io/github/v/tag/thechampagne/webview-zig?label=version)](https://github.com/thechampagne/webview-zig/releases/latest) [![](https://img.shields.io/github/license/thechampagne/webview-zig)](https://github.com/thechampagne/webview-zig/blob/main/LICENSE)

Zig binding for a tiny cross-platform **webview** library to build modern cross-platform GUIs.

<p align="center">
<img src="https://raw.githubusercontent.com/thechampagne/webview-zig/main/.github/assets/screenshot.png"/>
</p>

### Requirements
 - [Zig Compiler](https://ziglang.org/) - **0.12.0**
 - Unix
   - [GTK3](https://webkitgtk.org/) and [WebKitGTK](https://webkitgtk.org/)
 - Windows
   - [WebView2 Runtime](https://developer.microsoft.com/en-us/microsoft-edge/webview2/)
 - macOS
   - [WebKit](https://webkit.org/)

### Usage
```zig
const webview = b.dependency("webview", .{
    .target = target,
    .optimize = optimize,
});
exe.addModule("webview", webview.module("webview"));
exe.linkLibrary(webview.artifact("webviewStatic")); // or "webviewShared" for shared library
// exe.linkSystemLibrary("webview"); to link with installed prebuilt library without building
```

### References
 - [webview](https://github.com/webview/webview)

### License

This repo is released under the [MIT License](https://github.com/thechampagne/webview-zig/blob/main/LICENSE).
