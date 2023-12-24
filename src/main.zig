const std = @import("std");

const simple_remove = @import("simple_remove.zig");

const path = @import("path.zig");

pub fn main() !void {
    // var allocator: *const std.mem.Allocator = &std.heap.page_allocator;

    // const args = try getCommandArgs(allocator);
    // defer std.process.argsFree(allocator.*, args);
    // const remover = simple_remove.Remover.new(args) catch |err| {
    //     switch (err) {
    //         error.HomeNotFound => std.debug.print("Can not get environment variable HOME, use 'echo $HOME' to check\n", .{}),
    //         else => |other_err| std.debug.print("other error occured: {}\n", .{other_err}),
    //     }
    //     return err;
    // };
    // _ = remover;
    const a = comptime foo();
    const b = comptime bar();
    const c = comptime bar2();
    std.debug.print("a: {}, b: {}, c: {}\n", .{ a, b, c });
}
fn foo() u8 {
    return 2;
}
fn bar() u8 {
    var buf: [1]u8 = undefined;
    buf[0] = foo();
    return buf[0];
}

fn bar2() u8 {
    var buf: [1]u8 = undefined;
    std.os.getrandom(buf[0..]) catch return 0;
    return buf[0];
}

fn getCommandArgs(allocator: *const std.mem.Allocator) ![]const [:0]u8 {
    const args = try std.process.argsAlloc(allocator.*);
    return args;
}
