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
`build.zig.zon`:
```zig
.{
    .dependencies = .{
        .webview = .{
            .url = "https://github.com/thechampagne/webview-zig/archive/refs/heads/main.tar.gz" ,
            .hash = "12208586373679a455aa8ef874112c93c1613196f60137878d90ce9d2ae8fb9cd511",
        },
    },
}
```
`build.zig`:
```zig
const webview = b.dependency("webview", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("webview", webview.module("webview"));
exe.linkLibrary(webview.artifact("webviewStatic")); // or "webviewShared" for shared library
// exe.linkSystemLibrary("webview"); to link with installed prebuilt library without building
```

### References
 - [webview](https://github.com/webview/webview)

### License

This repo is released under the [MIT License](https://github.com/thechampagne/webview-zig/blob/main/LICENSE).
