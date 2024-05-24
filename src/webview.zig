// Copyright (c) 2023 XXIV
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
pub const raw = @import("raw.zig");

pub const WebView = struct {
    
    webview: raw.webview_t,

    const Self = @This();

    pub const WebViewVersionInfo = raw.webview_version_info_t;

    pub const DispatchCallback = *const fn (WebView, ?*anyopaque) void;

    pub const BindCallback = *const fn ([:0]const u8, [:0]const u8, ?*anyopaque) void;

    pub const WindowSizeHint = enum(c_int) {
        None,
        Min,
        Max,
        Fixed
    };

    pub fn create(debug: bool, window: ?*anyopaque) Self {
        return Self{ .webview = raw.webview_create(@intFromBool(debug), window) };
    }

    pub fn run(self: Self) void {
        raw.webview_run(self.webview);
    }

    pub fn terminate(self: Self) void {
        raw.webview_terminate(self.webview);
    }
    
    pub fn dispatch(self: Self, func: anytype, arg: ?*anyopaque) void {
        const T = @TypeOf(func);
        if (T != DispatchCallback and T != fn (WebView, ?*anyopaque) void) {
            @compileError(fmt.comptimePrint("expected type 'fn (WebView, ?*anyopaque) void' or '*const fn (WebView, ?*anyopaque) void', found '{any}'",
                                            .{T}));
        }
        const callback = struct {
            var callback: DispatchCallback = undefined;
            fn function(w: raw.webview_t, ctx: ?*anyopaque) callconv(.C) void {
                if (T == DispatchCallback) {
                    callback(.{ .webview = w}, ctx);
                } else {
                    @call(.always_inline, func, .{.{ .webview = w}, ctx});
                }
            }
        };
        if (T == DispatchCallback) callback.callback = func;
        raw.webview_dispatch(self.webview, callback.function, arg);
    }
    
    pub fn getWindow(self: Self) ?*anyopaque {
        return raw.webview_get_window(self.webview);
    }
    
    pub fn setTitle(self: Self, title: [:0]const u8) void {
        raw.webview_set_title(self.webview, title.ptr);
    }
    
    pub fn setSize(self: Self, width: i32, height: i32, hint: WindowSizeHint) void {
        raw.webview_set_size(self.webview, width, height, @intFromEnum(hint));
    }
    
    pub fn navigate(self: Self, url: [:0]const u8) void {
        raw.webview_navigate(self.webview, url.ptr);
    }
    
    pub fn setHtml(self: Self, html: [:0]const u8) void {
        raw.webview_set_html(self.webview, html.ptr);
    }
    
    pub fn init(self: Self, js: [:0]const u8) void {
        raw.webview_init(self.webview, js.ptr);
    }
    
    pub fn eval(self: Self, js: [:0]const u8) void {
        raw.webview_eval(self.webview, js.ptr);
    }
    
    pub fn bind(self: Self, name: [:0]const u8, func: anytype, arg: ?*anyopaque) void {
        const T = @TypeOf(func);
        if (T != BindCallback and T != fn ([:0]const u8, [:0]const u8, ?*anyopaque) void) {
            @compileError(fmt.comptimePrint("expected type 'fn ([:0]const u8, [:0]const u8, ?*anyopaque) void' or '*const fn ([:0]const u8, [:0]const u8, ?*anyopaque) void', found '{any}'",
                                            .{T}));
        }
        const callback = struct {
            var callback: BindCallback = undefined;
            fn function(seq: [*c]const u8, req: [*c]const u8, ctx: ?*anyopaque) callconv(.C) void {
                if (T == BindCallback) {
                    callback(mem.sliceTo(seq, 0), mem.sliceTo(req, 0), ctx);
                } else {
                    @call(.always_inline, func, .{mem.sliceTo(seq, 0), mem.sliceTo(req, 0), ctx});
                }
            }
        };
        if (T == BindCallback) callback.callback = func;
        raw.webview_bind(self.webview, name.ptr, callback.function, arg);
    }
    
    pub fn unbind(self: Self, name: [:0]const u8) void {
        raw.webview_unbind(self.webview, name.ptr);
    }
    
    pub fn ret(self: Self ,seq: [:0]const u8, status: i32, result: [:0]const u8) void {
        raw.webview_return(self.webview, seq.ptr, status, result.ptr);
    }
    
    pub fn version() *const WebViewVersionInfo {
        return raw.webview_version();
    }

    pub fn destroy(self: Self) void {
        raw.webview_destroy(self.webview);
    }
};
