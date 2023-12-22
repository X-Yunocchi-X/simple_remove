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

    // const p = path.Path(std.fs.Dir){ .path = "test" };

    // const foo: fn () anyerror!u8 = undefined;

    // std.debug.print("res: {}\n", .{@TypeOf(foo())});
}

// fn foo() !u8 {
//     return error.Err;
// }

fn getCommandArgs(allocator: *const std.mem.Allocator) ![]const [:0]u8 {
    const args = try std.process.argsAlloc(allocator.*);
    return args;
}
