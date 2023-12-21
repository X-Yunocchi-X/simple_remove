const std = @import("std");

const Remover = @import("simple_remove.zig").Remover;

const allocator = std.heap.page_allocator;

pub fn main() void {
    const args = getCommandArgs();
    const remover = Remover.new(args) catch |err| switch (err) {
        error.HomeNotFound => std.debug.print("Can not get environment variable HOME, use 'echo $HOME' to check", .{}),
        else => |other_err| std.debug.print("other error occured: {}", other_err),
    };
    _ = remover;

    std.process.argsFree(allocator, args);
}

fn getCommandArgs() []const [:0]u8 {
    const args = try std.process.argsAlloc(allocator);
    return args;
}
