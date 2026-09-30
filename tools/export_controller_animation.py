"""Bake the controller-retargeted idle onto the project's Mixamo skeleton.

Run with Blender:
  blender --background Desktop/idle.blend --python tools/export_controller_animation.py

The script deliberately exports one armature and no meshes.
"""

import bpy
import math
import os


SOURCE_ACTION = "Armature|mixamo.com|Layer0_remap"
TARGET_FBX = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "assets", "models", "player", "test_model", "Swat.fbx")
)
OUTPUT_FBX = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "assets", "animations", "player", "idle.fbx")
)


BONE_MAP = {
    "mixamorig:Hips": "root.x",
    "mixamorig:Spine": "spine_01.x",
    "mixamorig:Spine1": "spine_02.x",
    "mixamorig:Spine2": "spine_03.x",
    "mixamorig:Neck": "neck.x",
    "mixamorig:LeftShoulder": "shoulder.l",
    "mixamorig:LeftArm": "arm_stretch.l",
    "mixamorig:LeftForeArm": "forearm_stretch.l",
    "mixamorig:LeftHand": "hand.l",
    "mixamorig:RightShoulder": "shoulder.r",
    "mixamorig:RightArm": "arm_stretch.r",
    "mixamorig:RightForeArm": "forearm_stretch.r",
    "mixamorig:RightHand": "hand.r",
    "mixamorig:LeftUpLeg": "thigh_stretch.l",
    "mixamorig:LeftLeg": "leg_stretch.l",
    "mixamorig:LeftFoot": "foot.l",
    "mixamorig:LeftToeBase": "toes_01.l",
    "mixamorig:RightUpLeg": "thigh_stretch.r",
    "mixamorig:RightLeg": "leg_stretch.r",
    "mixamorig:RightFoot": "foot.r",
    "mixamorig:RightToeBase": "toes_01.r",
}

def main():
    scene = bpy.context.scene
    source = bpy.data.objects.get("rig")
    source_action = bpy.data.actions.get(SOURCE_ACTION)
    if not source or source.type != "ARMATURE":
        raise RuntimeError("Controller armature 'rig' was not found")
    if not source_action:
        raise RuntimeError("Controller action '%s' was not found" % SOURCE_ACTION)

    before = set(scene.objects)
    bpy.ops.import_scene.fbx(filepath=TARGET_FBX, automatic_bone_orientation=False)
    imported = [obj for obj in scene.objects if obj not in before]
    targets = [obj for obj in imported if obj.type == "ARMATURE"]
    if not targets:
        raise RuntimeError("Target FBX did not contain an armature")
    target = targets[0]
    target.name = "Armature"

    # Keep only the target armature from the imported model.  The source scene's
    # player and weapon objects are never selected or exported.
    for obj in imported:
        if obj != target:
            bpy.data.objects.remove(obj, do_unlink=True)

    missing = [
        "%s <- %s" % (target_name, source_name)
        for target_name, source_name in BONE_MAP.items()
        if target_name not in target.pose.bones or source_name not in source.pose.bones
    ]
    if missing:
        raise RuntimeError("Retarget bone mapping is incomplete: %s" % ", ".join(missing))

    if not source.animation_data or source.animation_data.action != source_action:
        raise RuntimeError("Controller rig is not currently using '%s'" % SOURCE_ACTION)
    bake_frame_start = int(source_action.frame_range[0])
    bake_frame_end = int(source_action.frame_range[1])

    target.animation_data_clear()
    target.animation_data_create()
    baked_action = bpy.data.actions.new("__idle_controller_baked__")
    target.animation_data.action = baked_action

    # Assign evaluated matrices explicitly. Blender 3.6's visual NLA bake does
    # not reliably preserve child-bone transforms from this Blender 4.2 file.
    # Parent-first assignment makes each target pose bone match the controller
    # bone in world space before its local channels are keyed.
    target_world_inverse = target.matrix_world.inverted()
    source_rest_world = {
        source_name: source.matrix_world @ source.data.bones[source_name].matrix_local
        for source_name in BONE_MAP.values()
    }
    target_rest_world = {
        target_name: target.matrix_world @ target.data.bones[target_name].matrix_local
        for target_name in BONE_MAP
    }
    for frame in range(bake_frame_start, bake_frame_end + 1):
        scene.frame_set(frame)
        desired_matrices = {}
        for target_name, source_name in BONE_MAP.items():
            source_pose_world = source.matrix_world @ source.pose.bones[source_name].matrix
            pose_delta_world = source_pose_world @ source_rest_world[source_name].inverted()
            desired_world = pose_delta_world @ target_rest_world[target_name]
            desired_matrices[target_name] = target_world_inverse @ desired_world

        for target_name, matrix in desired_matrices.items():
            pose_bone = target.pose.bones[target_name]
            rest_bone = target.data.bones[target_name]
            if rest_bone.parent:
                parent_pose_matrix = desired_matrices[rest_bone.parent.name]
                matrix_basis = rest_bone.convert_local_to_pose(
                    matrix,
                    rest_bone.matrix_local,
                    parent_matrix=parent_pose_matrix,
                    parent_matrix_local=rest_bone.parent.matrix_local,
                    invert=True,
                )
            else:
                matrix_basis = rest_bone.convert_local_to_pose(
                    matrix,
                    rest_bone.matrix_local,
                    invert=True,
                )
            location, rotation, scale = matrix_basis.decompose()
            pose_bone.rotation_mode = "QUATERNION"
            pose_bone.location = location
            pose_bone.rotation_quaternion = rotation
            pose_bone.scale = scale

        for target_name in desired_matrices:
            pose_bone = target.pose.bones[target_name]
            values = tuple(pose_bone.location) + tuple(pose_bone.rotation_quaternion) + tuple(pose_bone.scale)
            if not all(math.isfinite(value) for value in values):
                raise RuntimeError(
                    "Non-finite retarget transform at frame %d on %s" % (frame, target_name)
                )
            pose_bone.keyframe_insert("location", frame=frame, group=target_name)
            pose_bone.keyframe_insert("rotation_quaternion", frame=frame, group=target_name)
            pose_bone.keyframe_insert("scale", frame=frame, group=target_name)

    scene.frame_set(bake_frame_start)
    bpy.context.view_layer.update()
    translation_errors = []
    for target_name, source_name in BONE_MAP.items():
        actual_world = target.matrix_world @ target.pose.bones[target_name].matrix
        source_pose_world = source.matrix_world @ source.pose.bones[source_name].matrix
        pose_delta_world = source_pose_world @ source_rest_world[source_name].inverted()
        expected_world = pose_delta_world @ target_rest_world[target_name]
        translation_errors.append(
            (
                (actual_world.translation - expected_world.translation).length,
                target_name,
                tuple(round(value, 4) for value in actual_world.translation),
                tuple(round(value, 4) for value in expected_world.translation),
            )
        )
    worst_error = max(translation_errors)
    max_translation_error = worst_error[0]
    if max_translation_error > 0.05:
        raise RuntimeError(
            "Explicit retarget bake failed world-space validation: %.6f m on %s, actual=%s expected=%s"
            % worst_error
        )

    # Blender's FBX exporter shifts baked animation forward by one frame. Move
    # only the new target action to 0..63 so Godot receives the expected 1..64.
    for curve in baked_action.fcurves:
        for point in curve.keyframe_points:
            point.co.x -= 1.0
            point.handle_left.x -= 1.0
            point.handle_right.x -= 1.0
    scene.frame_start = bake_frame_start - 1
    scene.frame_end = bake_frame_end - 1

    # Blender's FBX bake exporter uses the scene name as the Take name. Godot
    # sanitizes this to `mixamo_com`, which is the name used by AnimationTree.
    scene.name = "mixamo.com"
    bpy.ops.object.select_all(action="DESELECT")
    target.select_set(True)
    bpy.context.view_layer.objects.active = target
    bpy.ops.export_scene.fbx(
        filepath=OUTPUT_FBX,
        use_selection=True,
        object_types={"ARMATURE"},
        use_mesh_modifiers=False,
        add_leaf_bones=False,
        bake_anim=True,
        bake_anim_use_all_actions=False,
        bake_anim_use_nla_strips=False,
        bake_anim_force_startend_keying=True,
        bake_anim_step=1.0,
        use_armature_deform_only=True,
        primary_bone_axis="Y",
        secondary_bone_axis="X",
        armature_nodetype="LIMBNODE",
    )
    print(
        "EXPORTED",
        OUTPUT_FBX,
        "frames",
        scene.frame_start,
        scene.frame_end,
        "mapped_bones",
        len(BONE_MAP),
        "max_translation_error_m",
        "%.6f" % max_translation_error,
        "baked_curves",
        len(baked_action.fcurves),
    )


if __name__ == "__main__":
    main()
