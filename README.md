# Conflict（冲突）

> 以俄乌冲突为背景的拟真战术FPS游戏，追求真实的装备与战斗体验。

## 项目简介

《Conflict》是一款注重拟真体验的第一人称射击游戏，在真实性与游戏性之间优先选择前者。玩家扮演小队成员，在模块化战场中完成战术任务，体验现代战争的残酷与抉择。

## 当前开发阶段

- [x] 项目架构设计
- [x] 玩家基础类（组件化系统）
- [x] 模型加载与摄像机控制
- [x] 基础移动与惯性（起步爆发/步态波动/转向减速）
- [x] 武器系统（枪机循环/弹药/配件与改装预览）
- [x] 基础死亡/昏迷布娃娃（持续迭代）
- [x] 左手、脊柱观察与双脚 IK 基础管线（持续校准）
- [x] 基础医疗、解剖伤道与生理反馈（部分高级治疗待实现）
- [ ] 多人网络同步

## 环境要求

- **Godot Engine** 4.7（与 project.godot 的功能版本及 GDExtension 构建匹配）
- **操作系统**：Windows / macOS / Linux
- **显卡**：支持Vulkan


## 架构特点

- **组件化设计**：玩家功能通过添加/移除组件实现，易于扩展和维护。
- **配置驱动**：角色属性、模型节点查找规则均通过配置文件控制。
- **Mod友好**：支持自定义角色模型和配置，提供制作指南。
- **混合真实第一人称**：相机过滤头部位置、输入视角独立；手 IK 跟随武器目标，弹道始终从实际枪口出发。

## 开发规范

### 命名约定
- 类名：PascalCase（如 `BasePlayer`）
- 变量与方法：snake_case（如 `model_node`、`load_model`）
- 常量：UPPER_CASE（如 `MAX_SPEED`）
- 私有成员：`_` 前缀（如 `_skeleton`）

### 节点约定
模型场景中建议包含以下节点以获得最佳兼容性：
- `Skeleton3D`：角色骨骼
- `AnimationPlayer`：动画播放器
- `CameraMount`：第一人称摄像机挂载点（Marker3D）

## 开发文档

- [队友代码集成说明](docs/TeammateIntegration.md) — 目录迁移、组件边界和版本冲突处理
- [DebugAPI 无头调试接口](docs/debug/DebugAPI.md) — AI、自动化测试和控制台的统一调试入口

模块文档和源码索引位于 [`docs/`](docs/README.md)；新增/补充组件见 [RuntimeSystems](docs/RuntimeSystems.md)，运行验证见 [Testing](docs/Testing.md)：

- [Player 系统](docs/player/) — 玩家、移动、摄像机、动画、武器检测
- [Weapon 核心](docs/weapon/) — 枪械组件（枪机、弹药、导气、后座等）
- [Weapon 配件](docs/attachments/) — 瞄具、握把、枪口、弹匣
- [UI 系统](docs/ui/UISystem.md) — 设置、提示、通知与 3D 武器改装界面
- [工具类](docs/utils/) — 日志系统

## 参与贡献

欢迎提交 Issue 和 Pull Request 参与项目开发。

## 许可证

本项目基于 [MIT License](LICENSE) 开源
