const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const export_path = b.option([]const u8, "export_path", "Path to save auto-generated files [default: `./gen`]") orelse "./gen";
    const build_options = b.addOptions();
    build_options.addOption([]const u8, "export_path", export_path);

    const lib = b.addSharedLibrary(.{
        .name = "roc_godot",
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const godot_zig = b.dependency("godot_zig", .{
        .target = target,
        .optimize = optimize,
        //.export_path = export_path,
    });
    //std.debug.print("{s}\n", .{godot_zig.builder.top_level_steps.keys()});
    const bind_step: *std.Build.Step = &godot_zig.builder.top_level_steps.getPtr("install").?.*.step;
    lib.step.dependOn(bind_step);
    const godot_module = godot_zig.module("godot");
    const godot_core_module = godot_zig.module("GodotCore");
    //godot_module.addIncludePath(b.path(export_path));
    lib.root_module.addImport("godot", godot_module);
    lib.root_module.addImport("GodotCore", godot_core_module);
    //lib.addIncludePath(b.path(export_path));
    //b.installArtifact(godot_zig.artifact("godot"));
    b.installArtifact(godot_zig.artifact("binding_generator"));
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
