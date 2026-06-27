# EjectionComponent

**文件路径：** `Classes/Weapon/Weapon/ejection_component.gd`  
**继承自：** `Node`

## 功能概述

确定弹壳从抛壳窗飞出时的位置和初始速度。击发后枪机后坐抽出弹壳，抛壳挺撞击弹壳将其从抛壳窗弹出；该组件提供抛壳窗的相对位置偏移和弹壳初始速度向量，供上层系统（粒子/刚体）实例化弹壳特效。

## 初始化

### `initialize(cfg: WeaponConfig) -> void`

在武器实例创建后由 `BaseWeapon` 调用，将 `WeaponConfig` 引用存入 `config`。当前版本初始化不读取配置数据，抛壳参数均为硬编码默认值。

## 信号（Signals）

此组件无信号。

## 公开属性（Properties）

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `config` | `WeaponConfig` | — | 武器配置引用，由 `initialize()` 注入 |
| `_ejection_port_position` | `Vector3` | `(0.05, 0.0, 0.2)` | 抛壳窗位置偏移（相对武器节点原点）：向右 5 cm，向前 20 cm（私有） |
| `_ejection_velocity` | `Vector3` | `(1.0, 2.0, -0.5)` | 弹壳抛出初始速度：向右 1 m/s，向上 2 m/s，向后 0.5 m/s（私有） |

## 公开方法（Methods）

### `get_ejection_position() -> Vector3`
返回弹壳弹出位置相对于武器节点原点的偏移向量，供上层在世界空间中换算后生成弹壳实体。

### `get_ejection_velocity() -> Vector3`
返回弹壳弹出时的初始速度向量（世界空间方向），供刚体或粒子系统设置初速。

## 依赖关系

- **依赖：** `WeaponConfig`（当前仅存引用，未读取字段；未来可根据 `weapon_type` 区分不同武器布局的抛壳窗位置）
- **被依赖：** `BaseWeapon` 持有此组件，在枪机后坐到位（`bolt_reached_rear` 信号触发后）调用 `get_ejection_position()` 和 `get_ejection_velocity()` 以生成弹壳特效

## 注意事项

- 当前抛壳位置和速度均为硬编码，适用于右手抛壳的 AR 布局（如 M4/AK 系列），左手抛壳武器（如 FAMAS）需手动修改或扩展为可配置参数。
- 代码注释明确说明后续应根据武器模型自动检测挂载点（`Marker3D`/`BoneAttachment3D`）替代硬编码偏移。
- 速度向量为局部参考方向，实际生成弹壳时需将其与武器节点的全局变换（`global_transform.basis`）相乘才能得到正确的世界空间速度。
- 此组件不负责实例化弹壳场景或播放抛壳音效，只提供数据；弹壳的视觉和音频效果由上层系统实现。
