# AmmoComponent

**文件路径：** `classes/weapon/ammo_component.gd`

**继承自：** `Node`

管理弹匣数组、当前弹匣索引、膛内弹和待进膛状态。弹匣元素为 null（标准弹）或 BulletData；消耗弹药会移除元素，不能用数组长度作为打空后仍保留的容量。

## 初始化与配置

initialize(cfg: WeaponConfig) 保存引用，先建一个空弹匣并清膛。装配 MagazineConfig 后 reconfigure(mag_cfg) 读取 magazine_capacity、reserve_magazines、has_last_round_hold_open，重建弹匣池并保留当前膛内弹；这些参数不属于 WeaponConfig。

clear_magazine() 拆下弹匣池但保留已上膛子弹。get_capacity() 返回独立缓存的容量，不从当前剩余数组长度反推。

## 弹药接口

| 方法 | 行为 |
|---|---|
| `has_ammo()` / `has_chambered_round()` | 查询枪上可用弹药 / 膛内实弹 |
| `consume_round()` | 优先消耗膛内弹，否则弹出当前弹匣首发 |
| `prepare_next_round()` / `is_next_round_ready()` | 标记/查询待进膛弹，不立即消费 |
| `chamber_round()` | 从当前弹匣移除一发并装膛，结束待进膛状态 |
| `swap_magazine()` | 循环查找非空备用弹匣，不自动补给，保留膛内弹 |
| `should_hold_open()` | has_ammo() 为 false 且 MagazineConfig 允许挂机 |
| `get_current_magazine_count()` / `get_magazine_count(idx)` | 当前/指定弹匣余弹 |
| `get_reserve_count()` / `get_total_remaining()` | 备用弹匣总弹 / 所有弹匣加膛内弹 |

recalculate_capacity(base_cap, bonus) 按目标容量填充或截断现有弹匣；这属于调试/旧兼容操作，不是普通战术换弹。apply_magazine_attachments(am) 是旧额外容量接口，当前默认装配使用 MagazineConfig.reconfigure()；两者不能混为一套可叠加的弹药库存机制。

refill_all() 与 debug_set_ammo(...) 用于调试重置，普通玩法补弹走 BaseWeapon.reload()，避免调试接口凭空补给。

## 信号

last_round_fired() 在从弹匣消费最后一发后触发。ammo_count_changed(current, reserve) 更新当前弹匣与备用弹匣计数（参数不含膛内弹）。bolt_hold_open_requested 是保留信号，当前没有主动 emit，实际挂机由 BaseWeapon 判断。

测试见 [Testing](../Testing.md)：combat_regression_check 覆盖换弹进度与缺枪管时不消耗实弹，未穷举全部弹药库存边界。
