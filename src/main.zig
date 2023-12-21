const std = @import("std");

const simple_remove = @import("simple_remove.zig");

const allocator = std.heap.page_allocator;

pub fn main() !void {
    const args = try getCommandArgs();
    const remover = simple_remove.Remover.new(args) catch |err| {
        switch (err) {
            error.HomeNotFound => std.debug.print("Can not get environment variable HOME, use 'echo $HOME' to check\n", .{}),
            else => |other_err| std.debug.print("other error occured: {}\n", .{other_err}),
        }
        return err;
    };
    _ = remover;

    std.process.argsFree(allocator, args);
}

fn getCommandArgs() ![]const [:0]u8 {
    const args = try std.process.argsAlloc(allocator);
    return args;
}
