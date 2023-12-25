const std = @import("std");

const Remover = @import("simple_remove.zig").Remover;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try getCommandArgs(allocator);
    defer std.process.argsFree(allocator, args);
    var remover = Remover.new(args[1..], allocator) catch |err| {
        switch (err) {
            error.HomeNotFound => std.debug.print("Can not get environment variable HOME, use 'echo $HOME' to check\n", .{}),
            else => |other_err| std.debug.print("other error occured: {any}\n", .{other_err}),
        }
        return err;
    };
    try remover.execute();
    remover.deinit();
}

fn getCommandArgs(allocator: std.mem.Allocator) ![]const [:0]u8 {
    const args = try std.process.argsAlloc(allocator);
    return args;
}
