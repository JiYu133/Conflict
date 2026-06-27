# AmmoComponent

**文件路径：** `Classes/Weapon/Weapon/ammo_component.gd`  
**继承自：** `Node`

## 功能概述

管理武器的全部弹药状态，包括弹匣库存池、膛内弹药状态以及托弹板推送逻辑。每个弹匣以 `Array` 表示，元素为 `null`（标准弹）或 `BulletData`（自定义弹种），并对外暴露弹药消耗、换弹、弹匣附件扩容等接口。

## 初始化

### `initialize(cfg: WeaponConfig) -> void`

在武器实例创建后、首次开火前由 `BaseWeapon` 调用。根据 `cfg.reserve_magazines + 1` 创建弹匣池（1 个在枪 + N 个备用），每个弹匣填充 `cfg.magazine_capacity` 发 `null` 标准弹，并将 `current_magazine` 重置为 0、`chambered_round` 重置为 `false`。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `last_round_fired` | 无 | 当前弹匣最后一发被消耗后（弹匣数组变为空） |
| `bolt_hold_open_requested` | 无 | 预留接口，当前代码中不主动 emit；供后续拉机柄挂机系统（动画/音效/UI）订阅 |
| `ammo_count_changed` | `current: int, reserve: int` | 任何弹药数量变化后（消耗、进膛），`current` 为当前弹匣余弹，`reserve` 为其余所有弹匣总弹数 |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| `config` | `WeaponConfig` | 武器配置引用，由 `initialize()` 注入 |
| `magazines` | `Array[Array]` | 弹匣池，`magazines[i]` 为第 i 个弹匣的子弹列表 |
| `current_magazine` | `int` | 当前使用中的弹匣索引 |
| `chambered_round` | `bool` | 枪膛内是否有已上膛的子弹 |
| `_next_round_ready` | `bool` | 托弹板是否已将下一发顶到进弹位置，等待枪机复进抓取（私有） |

## 公开方法（Methods）

### `has_ammo() -> bool`
判断是否有弹药可用（膛内有弹 或 当前弹匣非空），是开火前提条件之一。

### `has_chambered_round() -> bool`
仅检查膛内是否有未击发的子弹。

### `is_next_round_ready() -> bool`
检查托弹板是否已将下一发推到进弹位置，供枪机复进时判断是否可进膛。

### `consume_round() -> void`
消耗一发子弹。优先消耗膛内弹，膛内无弹时从当前弹匣顶部弹出一发；弹匣打空时 emit `last_round_fired`。

### `get_current_magazine_count() -> int`
返回当前弹匣剩余子弹数。

### `get_reserve_count() -> int`
返回所有备用弹匣（不含当前在用弹匣）的总弹数。

### `prepare_next_round() -> void`
将当前弹匣顶端子弹标记为"已推到进弹位"（`_next_round_ready = true`），不立即进膛，需等枪机复进后调用 `chamber_round()`。

### `chamber_round() -> void`
将准备好的子弹推入枪膛。优先消费 `_next_round_ready` 状态（同时从弹匣数组移除对应元素，防止弹匣计数不变导致无限弹药），无准备弹时直接从弹匣顶取。

### `should_hold_open() -> bool`
判断是否需要触发空仓挂机：弹匣和膛内均无弹，且 `config.has_last_round_hold_open` 为 `true`。

### `swap_magazine() -> void`
切换到下一个有子弹的弹匣（循环查找）。所有弹匣为空时保持原索引，由空仓挂机流程接管。战术换弹时不清空 `chambered_round`，仅清空 `_next_round_ready`。

### `apply_magazine_attachments(am: AttachmentManager) -> void`
在附件管理器初始化完成后调用，读取扩容弹匣的额外容量并对所有弹匣追加 `null` 填充。

### `get_magazine_count(idx: int) -> int`
返回指定索引弹匣的剩余子弹数，越界返回 0。

### `get_total_remaining() -> int`
返回所有弹匣子弹数之和加上膛内弹（0 或 1）。

## 依赖关系

- **依赖：** `WeaponConfig`（读取 `magazine_capacity`、`reserve_magazines`、`has_last_round_hold_open`）；`AttachmentManager`（读取 `get_total_magazine_capacity_bonus()`，仅在 `apply_magazine_attachments` 中使用）
- **被依赖：** `BaseWeapon` 持有并调用此组件；`BaseWeapon` 订阅 `last_round_fired` 和 `ammo_count_changed` 信号以驱动空仓挂机和 UI 更新

## 注意事项

- `prepare_next_round()` 与 `chamber_round()` 必须配对使用。若 `chamber_round()` 在 `_next_round_ready = true` 时被调用，会从弹匣数组移除一发；若直接调用 `chamber_round()` 跳过准备步骤，也会移除一发，两条路径均会正确消耗弹匣，但不可重复调用。
- `swap_magazine()` 不会重新填充弹匣弹药（无补给逻辑），弹匣一旦打空即永久为空，除非外部系统重新写入 `magazines[i]`。
- `bolt_hold_open_requested` 信号当前没有任何 emit 调用，连接它不会有任何效果，直到后续系统显式 emit。
- 当所有弹匣均空时 `swap_magazine()` 不会切换索引（取模后值不变），此时 `get_current_magazine_count()` 返回 0，符合空仓挂机预期。
