const std = @import("std");
const file = @embedFile("resources/day02.txt");
const EnemyHand = enum(u8) {
    rock = 'A',
    paper = 'B',
    scissors = 'C',
};
const MyHand = enum(u8) {
    rock = 'X',
    paper = 'Y',
    scissors = 'Z',
};
const Fight = struct {
    lhs: EnemyHand,
    rhs: MyHand,
};
const Forseen = enum(u8) {
    lose = 'X',
    draw = 'Y',
    win = 'Z',
};
pub fn main() !void {
    var splitted = std.mem.tokenize(u8, file, "\n");
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var list = std.ArrayList(Fight).init(allocator);
    while (splitted.next()) |line| {
        var res = std.mem.split(u8, line, " ");
        try list.append(Fight{ .lhs = @intToEnum(EnemyHand, res.next().?[0]), .rhs = @intToEnum(MyHand, res.next().?[0]) });
    }
    var total: u32 = 0;
    for (list.items) |item| {
        const res: u8 = result(item.lhs, item.rhs);
        total += res;
    }
    std.debug.print("TOTAL : {}\n", .{total});

    //PART 2
    var for_total: u32 = 0;
    for (list.items) |item| {
        const calculate: Forseen = @intToEnum(Forseen, @enumToInt(item.rhs));
        const res: u8 = forseen(calculate, item.lhs);
        for_total += res;
    }
    std.debug.print("TOTAL after calculation: {}\n ", .{for_total});
}
fn forseen(target: Forseen, enemy: EnemyHand) u8 {
    //could move to 6 3 and 0 to to number + switch as below
    return switch (target) {
        .win => switch (enemy) {
            .scissors => 1 + 6,
            .paper => 3 + 6,
            .rock => 2 + 6,
        },
        .draw => switch (enemy) {
            .scissors => 3 + 3,
            .paper => 2 + 3,
            .rock => 1 + 3,
        },
        .lose => switch (enemy) {
            .scissors => 2 + 0,
            .paper => 1 + 0,
            .rock => 3 + 0,
        },
    };
}

fn result(lhs: EnemyHand, rhs: MyHand) u8 {
    return switch (rhs) {
        .scissors => 3 + switch (lhs) {
            .scissors => @as(u8, 3),
            .paper => 6,
            .rock => 0,
        },
        .paper => 2 + switch (lhs) {
            .scissors => @as(u8, 0),
            .paper => 3,
            .rock => 6,
        },
        .rock => 1 + switch (lhs) {
            .scissors => @as(u8, 6),
            .paper => 0,
            .rock => 3,
        },
    };
}
