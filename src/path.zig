const std = @import("std");
const fs = std.fs;

const Dir = fs.Dir;
const File = fs.File;

const assert = std.debug.assert;

// path should be absolute path
pub fn Path(comptime T: type) type {
    assert(T == Dir or T == File);
    return struct {
        path: []const u8,
        file: T = undefined,

        pub fn init(self: @This()) void {
            _ = self;
        }
    };
}
