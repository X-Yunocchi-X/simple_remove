const std = @import("std");

const Remover = @import("simple_remove.zig").Remover;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try getCommandArgs(allocator);
    defer std.process.argsFree(allocator, args);
    var remover = Remover.new(args, allocator) catch |err| {
        switch (err) {
            error.HomeNotFound => std.debug.print("Can not get environment variable HOME, use 'echo $HOME' to check\n", .{}),
            else => |other_err| std.debug.print("other error occured: {}\n", .{other_err}),
        }
        return err;
    };
    try remover.createDirCache("/home/yuno/Downloads/code");
    remover.deinit();

    // var dir = try std.fs.cwd().openIterableDir("/home/yuno/Downloads/aws", .{});
    // defer dir.close();
    // var walker = try dir.walk(allocator);
    // defer walker.deinit();
    // while (try walker.next()) |entry| {
    //     inline for (std.meta.fields(@TypeOf(entry))) |f| {
    //         if (f.type != []const u8 and f.type != []u8) {
    //             std.debug.print(f.name ++ " {any}\n", .{@as(f.type, @field(entry, f.name))});
    //             // std.debug.print("type: {}\n", .{f.type});
    //         } else {
    //             std.debug.print(f.name ++ " {s}\n", .{@as(f.type, @field(entry, f.name))});
    //         }
    //     }
    // }
}

fn getCommandArgs(allocator: std.mem.Allocator) ![]const [:0]u8 {
    const args = try std.process.argsAlloc(allocator);
    return args;
}
