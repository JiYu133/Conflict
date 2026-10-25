# GasComponent

**文件路径：** `classes/weapon/gas_component.gd`

**继承自：** `Node`

提供击发到枪机开始后坐的近似导气延时，不积分压力或活塞刚体。

| 方法 | 行为 |
|---|---|
| `initialize(cfg: WeaponConfig)` | 兼容初始化入口，保存机匣配置 |
| `reconfigure(barrel_cfg: BarrelConfig)` | 缓存已装枪管的 barrel_length 与 muzzle_velocity |
| `get_delay_time() -> float` | 返回 barrel_length / muzzle_velocity * 0.3 |

未重配时使用脚本默认枪管参数 0.415 m / 900 m/s。初速<=0 时返回 0.001 s，不会按旧文档描述直接除零。BaseWeapon 在枪管配件变化时重配本组件，并将结果用于枪机 cycle delay 与射速标定。

0.3 是经验系数，不区分短/长行程活塞和导气管长度。当前不读取 WeaponConfig 上不存在的枪管字段。
