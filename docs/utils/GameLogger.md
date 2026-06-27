# GameLogger

**文件路径：** `Classes/GameLogger/game_logger.gd`  
**继承自：** `Node`

## 功能概述

全局日志工具类，提供带时间戳、模块标签和级别前缀的结构化日志输出。支持四个日志级别（DEBUG / INFO / WARN / ERROR），通过 `minimum_level` 属性过滤低优先级日志，ERROR 级别输出到 `printerr`，WARN 级别同时触发 `push_warning`。

## 初始化

无 `initialize()` 方法。作为 `Node` 使用，通常以 Autoload 方式注册为全局单例（别名建议为 `Logger`），在场景树就绪后即可使用。

典型用法：
```
Logger.info("WeaponManager", "武器初始化完成")
Logger.warn("AmmoComponent", "弹药不足")
Logger.error("AttachmentFactory", "配件场景实例化失败")
```

## 信号（Signals）

无。

## 公开方法（Methods）

### `debug(module: String, message: String) -> void`

输出 DEBUG 级别日志。低于 `minimum_level` 时静默丢弃。

### `info(module: String, message: String) -> void`

输出 INFO 级别日志。低于 `minimum_level` 时静默丢弃。

### `warn(module: String, message: String) -> void`

输出 WARN 级别日志。同时调用 `push_warning` 使其在 Godot 编辑器警告面板中可见。

### `error(module: String, message: String) -> void`

输出 ERROR 级别日志。通过 `printerr` 输出到标准错误流。

## 依赖关系

- **依赖：**
  - Godot 内置 `Time` 单例 — 用于获取当前时间字符串（`Time.get_time_string_from_system()`）
- **被依赖：**
  - 项目中任何需要结构化日志的系统，典型调用方包括 `AttachmentFactory`（通过 `push_warning` / `push_error` 输出，非直接调用本类）

## 注意事项

- `minimum_level` 使用 `@export` 暴露，可在编辑器 Inspector 中直接调整，无需修改代码即可控制日志详细程度。
- 日志格式固定为 `[HH:MM:SS] LEVEL [Module] Message`，不可自定义格式。
- `Time.get_time_string_from_system()` 返回本地时间，不含日期，长时间运行的会话中无法区分跨天的日志。
- 本类不写入文件，所有输出仅在运行时可见（控制台 / 编辑器输出面板），无持久化能力。
- WARN 级别会同时 `print` 和 `push_warning`，日志会在控制台出现两次（一次普通输出，一次来自 `push_warning` 的引擎内部回显，取决于编辑器版本）。
