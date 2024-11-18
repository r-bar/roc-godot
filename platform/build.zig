const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "roc_godot",
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const godot_zig = b.dependency("godot_zig", .{
        .target = target,
        .optimize = optimize,
    });
    //std.debug.print("{s}\n", .{godot_zig.builder.top_level_steps.keys()});
    //const godot_zig_install_step: *std.Build.Step = &godot_zig.builder.top_level_steps.getPtr("install").?.*.step;
    //lib.step.dependOn(bind_step);
    const godot_module = godot_zig.module("godot");
    //const godot_core_module = godot_zig.module("GodotCore");
    //godot_module.addIncludePath(b.path(export_path));
    lib.root_module.addImport("godot", godot_module);
    //lib.root_module.addImport("GodotCore", godot_core_module);
    b.installArtifact(lib);

    const unit_tests = b.addTest(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
