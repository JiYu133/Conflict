class_name BloodEffectConfig
extends Resource

## 死亡后外部渗血表现配置。
## 纹理由美术资源提供；本资源只描述播放时序、尺寸和粒子参数。

@export_group("Textures")
## 顶视角血泊贴图。建议使用带 alpha 的 PNG，边缘应有自然的不规则形状。
@export var blood_pool_texture: Texture2D
## 单滴/小血滴贴图。建议使用带 alpha 的 PNG。
@export var blood_drop_texture: Texture2D

@export_group("Pool")
## 血泊开始出现前的延迟，模拟尸体落地后的短暂积液过程。
@export_range(0.0, 10.0, 0.05) var pool_delay: float = 0.35
## 血泊从无到最大尺寸的扩散时长。
@export_range(0.05, 20.0, 0.05) var pool_growth_duration: float = 4.0
@export var pool_start_size: Vector2 = Vector2(0.08, 0.08)
@export var pool_max_size: Vector2 = Vector2(2.2, 1.55)
@export_range(0.01, 1.0, 0.01) var pool_alpha: float = 0.88
## 血泊贴地时向上抬升的偏移，避免与地面 z-fighting。
@export_range(0.001, 0.1, 0.001) var ground_offset: float = 0.012

@export_group("Drips")
## 渗血表现持续时间；0 表示持续到复活或节点被清理。
@export_range(0.0, 120.0, 0.5) var drip_duration: float = 18.0
@export_range(0.0, 60.0, 0.1) var drip_delay: float = 0.2
@export_range(1, 128, 1) var drip_amount: int = 36
@export_range(0.01, 2.0, 0.01) var drip_lifetime: float = 0.75
@export_range(0.1, 30.0, 0.1) var drip_gravity: float = 9.8
@export_range(0.01, 0.3, 0.005) var drip_size: float = 0.035
@export_range(0.0, 1.0, 0.01) var drip_alpha: float = 0.75

@export_group("Ground Query")
## 地面射线检测的长度；应覆盖尸体可能离地的高度。
@export_range(1.0, 30.0, 0.5) var ground_ray_length: float = 8.0
@export_flags_3d_physics var ground_collision_mask: int = 1
