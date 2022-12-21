const std = @import("std");
const print = std.debug.print;
pub fn main() !void {
    print("AOC 2021\n", .{});
    print("Loading file...\n", .{});
    var start_time = std.time.nanoTimestamp();
    var file = try std.fs.cwd().openFile("src/resources/day01.txt", .{});
    const file_size = (try file.stat()).size;
    print("File size is {}\n", .{file_size});
    const allocator = std.heap.page_allocator;

    var buffer = try allocator.alloc(u8, file_size);
    try file.reader().readNoEof(buffer);

    var iter = std.mem.split(u8, buffer, "\n\n");
    var counter: u32 = 0;
    var list = std.ArrayList(Elv).init(allocator);
    while (iter.next()) |entry| {
        counter += 1;
        var internal_iter = std.mem.split(u8, entry, "\n");
        var elv_calories: u32 = 0;
        while (internal_iter.next()) |calories| {
            if (calories.len == 0) {
                continue;
            }
            elv_calories += try std.fmt.parseInt(u32, calories, 10);
        }
        try list.append(Elv{ .number = counter, .total_calories = elv_calories });
    }
    print("We've got {d} elves to feed \n", .{counter});
    print("Right we have {} in our list \n", .{list.items.len});

    print("Let's decide who is the fattest Elv in the room \n", .{});
    var fattest_elv: Elv = Elv{};
    for (list.items) |elv| {
        if (elv.total_calories > fattest_elv.total_calories) {
            fattest_elv = elv;
        }
    }
    print("Fattest Elv is elv no {d} with a callories {d} \n", .{ fattest_elv.number, fattest_elv.total_calories });
    //PART 2
    print("Let's find the top 3 fattest Elves!\n", .{});

    // var sorted = std.sort.sort(u32, list.items, {}, comptime std.sort.desc(u32));
    // print("Sorted are {} {} {} ", .{ sorted[0], sorted[1], sorted[2] });
    std.sort.sort(Elv, list.items, {}, cmpByData);
    // print("Sorted are {} {} {} ", .{ list.items[0].number, list.items[1].number, list.items[2].number });

    var items = list.items;
    const max = items[0].total_calories + items[1].total_calories + items[2].total_calories;
    print("Total calories is {}\n", .{max});

    var elves = [_]Elv{ Elv{}, Elv{}, Elv{} };
    for (list.items) |elv| {
        for (elves) |fat, idx| {
            if (elv.total_calories > fat.total_calories) {
                elves[idx] = elv;
                break;
            }
        }
    }
    print("Fattest elves are: \n", .{});
    var total_elves_calories: u32 = 0;
    for (elves) |elv| {
        print("no: {d}, cal: {d}\n", .{ elv.number, elv.total_calories });
        total_elves_calories += elv.total_calories;
    }
    print("Total calories gathered by top 3 elves is {d}\n", .{total_elves_calories});

    var duration = std.time.nanoTimestamp() - start_time;

    print("Duration was {} ms", .{duration});
}
fn cmpByData(_: void, a: Elv, b: Elv) bool {
    if (a.total_calories > b.total_calories) {
        return true;
    } else {
        return false;
    }
}
const Elv = struct {
    number: u32 = undefined,
    total_calories: u32 = 0,
};
