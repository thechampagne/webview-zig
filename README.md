# webview-zig

[![](https://img.shields.io/github/v/tag/thechampagne/webview-zig?label=version)](https://github.com/thechampagne/webview-zig/releases/latest) [![](https://img.shields.io/github/license/thechampagne/webview-zig)](https://github.com/thechampagne/webview-zig/blob/main/LICENSE)

Zig binding for a tiny cross-platform **webview** library to build modern cross-platform GUIs.

<p align="center">
<img src="https://raw.githubusercontent.com/thechampagne/webview-zig/main/.github/assets/screenshot.png"/>
</p>

### Requirements
 - [Zig Compiler](https://ziglang.org/) - **0.13.0**
 - Unix
   - [GTK3](https://gtk.org/) and [WebKitGTK](https://webkitgtk.org/)
 - Windows
   - [WebView2 Runtime](https://developer.microsoft.com/en-us/microsoft-edge/webview2/)
 - macOS
   - [WebKit](https://webkit.org/)

### Usage

```
zig fetch --save https://github.com/thechampagne/webview-zig/archive/refs/heads/main.tar.gz
```

`build.zig.zon`:
```zig
.{
    .dependencies = .{
        .webview = .{
            .url = "https://github.com/thechampagne/webview-zig/archive/refs/heads/main.tar.gz" ,
          //.hash = "12208586373679a455aa8ef874112c93c1613196f60137878d90ce9d2ae8fb9cd511",
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

### API

```zig
const WebView = struct {

    const WebViewVersionInfo = struct {
        version: struct {
            major: c_uint,
            minor: c_uint,
            patch: c_uint,
        },
        version_number: [32]c_char,
        pre_release: [48]c_char,
        build_metadata: [48]c_char,
    };

    const DispatchCallback = *const fn (?*anyopaque, ?*anyopaque) callconv(.c) void;

    const BindCallback = *const fn ([*:0]const u8, [*:0]const u8, ?*anyopaque) callconv(.c) void;

    const WindowSizeHint = enum(c_uint) {
        none,
        min,
        max,
        fixed
    };

    const NativeHandle = enum(c_uint) {
        ui_window,
        ui_widget,
        browser_controller
    };

    const WebViewError = error {
        MissingDependency,
        Canceled,
        InvalidState,
        InvalidArgument,
        Unspecified,
        Duplicate,
        NotFound,
    };

    fn create(debug: bool, window: ?*anyopaque) WebView;

    fn run(self: WebView) WebViewError!void;

    fn terminate(self: WebView) WebViewError!void;
    
    fn dispatch(self: WebView, func: DispatchCallback, arg: ?*anyopaque) WebViewError!void;
    
    fn getWindow(self: WebView) ?*anyopaque;

    fn getNativeHandle(self: WebView, kind: NativeHandle) ?*anyopaque;
    
    fn setTitle(self: WebView, title: [:0]const u8) WebViewError!void;
    
    fn setSize(self: WebView, width: i32, height: i32, hint: WindowSizeHint) WebViewError!void;
    
    fn navigate(self: WebView, url: [:0]const u8) WebViewError!void;
    
    fn setHtml(self: WebView, html: [:0]const u8) WebViewError!void;
    
    fn init(self: WebView, js: [:0]const u8) WebViewError!void;
    
    fn eval(self: WebView, js: [:0]const u8) WebViewError!void;
    
    fn bind(self: WebView, name: [:0]const u8, func: BindCallback, arg: ?*anyopaque) WebViewError!void;
    
    fn unbind(self: WebView, name: [:0]const u8) WebViewError!void;
    
    fn ret(self: WebView ,seq: [:0]const u8, status: i32, result: [:0]const u8) WebViewError!void;
    
    fn version() *const WebViewVersionInfo;

    fn destroy(self: WebView) WebViewError!void;
}
```

### References
 - [webview](https://github.com/webview/webview/tree/0.12.0) - **0.12.0**

### License

This repo is released under the [MIT License](https://github.com/thechampagne/webview-zig/blob/main/LICENSE).

Third party code:
 - [external/WebView2](https://github.com/thechampagne/webview-zig/tree/main/external/WebView2) licensed under the [BSD-3-Clause License](https://github.com/thechampagne/webview-zig/tree/main/external/WebView2/LICENSE).
