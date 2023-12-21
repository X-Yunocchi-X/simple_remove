const std = @import("std");
const io = std.io;

const simple_rm = @import("simple_rm.zig");

const page_allocator = std.heap.page_allocator;

pub fn main() !void {
    const args = try getArgs();

    const stdout = io.getStdOut().writer();
    for (args) |value| {
        try stdout.print("{s}\n", .{value});
    }

    defer std.process.argsFree(page_allocator, args);
}

fn getArgs() ![]const [:0]u8 {
    const args = try std.process.argsAlloc(page_allocator);
    return args;
}
