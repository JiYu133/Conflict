# ScreenPostProcess

`ScreenPostProcess` 是独立的摄像机后处理模块，导入自桌面上的 `屏幕后处理1.5.gd`。它继承 `Camera3D`，在运行时按需创建全屏 `CanvasLayer` / `ColorRect` shader，可独立控制以下效果：

- 动态模糊与景深
- 色散、暗角、故障、鱼眼、噪点和像素化
- 全屏模糊、径向模糊和基于标记物体的遮罩模糊
- 轮廓描边、CRT、色调映射、锐化和泛光

## 文件

实现位于 `classes/player/screen_post_process.gd`，全局类名为 `ScreenPostProcess`。

## 使用方式

将脚本挂到需要后处理的 `Camera3D` 节点，或在代码中作为该摄像机的脚本使用。除动态模糊外的效果开关默认关闭；动态模糊默认开启，但只有摄像机旋转时才产生强度。参数可以在 Inspector 中调整。

该模块目前只完成项目集成，没有挂载到任何现有场景，也没有修改 `BasePlayer`、`PlayerCameraController` 或现有玩家屏幕效果系统。后续接入场景时，应确认该摄像机是当前 viewport 的 active camera，并评估同时启用多个 `SCREEN_TEXTURE` pass 的性能成本。

## 注意事项

- 物体遮罩模糊会查找名为 `模糊区域` 的 `Node3D`，并使用其上级 `MeshInstance3D` 作为遮罩目标。
- 景深会在摄像机没有 `CameraAttributesPractical` 时创建并绑定一份。
- 所有效果节点都由脚本运行时创建，不需要额外的 `.tscn` 或纹理资源。
