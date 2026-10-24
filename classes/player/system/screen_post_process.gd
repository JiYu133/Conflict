class_name ScreenPostProcess
extends Camera3D

@export_group("动态模糊")
@export var 启用动态模糊: bool = true:
	set(value):
		启用动态模糊 = value
		if not value and _blur_color_rect and _blur_color_rect.material:
			_blur_color_rect.material.set_shader_parameter("intensity", 0.0)

@export var 灵敏度 : float = 1.5
@export var 最大强度 : float = 0.06
@export var 采样数 : int = 8:
	set(value):
		采样数 = value
		_update_blur_shader_param("samples", 采样数)
@export var 高斯标准差 : float = 0.5:
	set(value):
		高斯标准差 = value
		_update_blur_shader_param("sigma", 高斯标准差)

@export_group("景深")
@export var 启用景深: bool = false:
	set(value):
		启用景深 = value
		_update_dof()

@export var 景深强度: float = 0.2:
	set(value):
		景深强度 = value
		_update_dof()

@export var 远模糊起始距离: float = 50.0:
	set(value):
		远模糊起始距离 = value
		_update_dof()

@export var 近模糊起始距离: float = 2.0:
	set(value):
		近模糊起始距离 = value
		_update_dof()

@export_group("色散效果")
@export var 启用色散: bool = false:
	set(value):
		启用色散 = value
		if _ca_color_rect:
			_ca_color_rect.visible = value

@export var 色散强度: float = 0.02:
	set(value):
		色散强度 = clamp(value, 0.0, 0.1)
		if _ca_color_rect and _ca_color_rect.material:
			_ca_color_rect.material.set_shader_parameter("intensity", 色散强度)

@export var 色散影响UI: bool = true:
	set(value):
		色散影响UI = value
		if _ca_canvas_layer:
			_ca_canvas_layer.layer = 10 if value else -1

@export_group("暗角效果")
@export var 启用暗角: bool = false:
	set(value):
		启用暗角 = value
		if _vignette_color_rect:
			_vignette_color_rect.visible = value

@export_enum("矩形", "椭圆", "圆形") var 暗角形状: int = 1:
	set(value):
		暗角形状 = value
		if _vignette_color_rect and _vignette_color_rect.material:
			_vignette_color_rect.material.set_shader_parameter("shape_type", value)

@export var 暗角颜色: Color = Color(0, 0, 0, 1):
	set(value):
		暗角颜色 = value
		if _vignette_color_rect and _vignette_color_rect.material:
			_vignette_color_rect.material.set_shader_parameter("vignette_color", value)

@export var 暗角强度: float = 1.0:
	set(value):
		暗角强度 = clamp(value, 0.0, 3.0)
		if _vignette_color_rect and _vignette_color_rect.material:
			_vignette_color_rect.material.set_shader_parameter("intensity", 暗角强度)

@export var 暗角半径: float = 0.5:
	set(value):
		暗角半径 = clamp(value, 0.0, 1.0)
		if _vignette_color_rect and _vignette_color_rect.material:
			_vignette_color_rect.material.set_shader_parameter("radius", 暗角半径)

@export var 暗角柔化: float = 0.9:
	set(value):
		暗角柔化 = clamp(value, 0.0, 1.0)
		if _vignette_color_rect and _vignette_color_rect.material:
			_vignette_color_rect.material.set_shader_parameter("softness", 暗角柔化)

@export var 暗角影响UI: bool = false:
	set(value):
		暗角影响UI = value
		if _vignette_canvas_layer:
			_vignette_canvas_layer.layer = 10 if value else -1

@export_group("故障效果")
@export var 启用故障: bool = false:
	set(value):
		启用故障 = value
		if _glitch_color_rect:
			_glitch_color_rect.visible = value

@export var 故障强度: float = 0.3:
	set(value):
		故障强度 = clamp(value, 0.0, 1.0)
		if _glitch_color_rect and _glitch_color_rect.material:
			_glitch_color_rect.material.set_shader_parameter("intensity", 故障强度)

@export var 故障速度: float = 1.3:
	set(value):
		故障速度 = max(0.0, value)
		if _glitch_color_rect and _glitch_color_rect.material:
			_glitch_color_rect.material.set_shader_parameter("speed", 故障速度)

@export var 撕裂强度: float = 0.1:
	set(value):
		撕裂强度 = clamp(value, 0.0, 1.0)
		if _glitch_color_rect and _glitch_color_rect.material:
			_glitch_color_rect.material.set_shader_parameter("tear_strength", 撕裂强度)

@export var 色散干扰: float = 0.5:
	set(value):
		色散干扰 = clamp(value, 0.0, 1.0)
		if _glitch_color_rect and _glitch_color_rect.material:
			_glitch_color_rect.material.set_shader_parameter("chroma_strength", 色散干扰)

@export var 故障影响UI: bool = false:
	set(value):
		故障影响UI = value
		if _glitch_canvas_layer:
			_glitch_canvas_layer.layer = 10 if value else -1

@export_group("鱼眼效果")
@export var 启用鱼眼: bool = false:
	set(value):
		启用鱼眼 = value
		if _fisheye_color_rect:
			_fisheye_color_rect.visible = value

@export var 鱼眼强度: float = 0.5:
	set(value):
		鱼眼强度 = clamp(value, 0.0, 2.0)
		if _fisheye_color_rect and _fisheye_color_rect.material:
			_fisheye_color_rect.material.set_shader_parameter("intensity", 鱼眼强度)

@export var 鱼眼中心X: float = 0.5:
	set(value):
		鱼眼中心X = clamp(value, 0.0, 1.0)
		if _fisheye_color_rect and _fisheye_color_rect.material:
			_fisheye_color_rect.material.set_shader_parameter("center_x", 鱼眼中心X)

@export var 鱼眼中心Y: float = 0.5:
	set(value):
		鱼眼中心Y = clamp(value, 0.0, 1.0)
		if _fisheye_color_rect and _fisheye_color_rect.material:
			_fisheye_color_rect.material.set_shader_parameter("center_y", 鱼眼中心Y)

@export var 鱼眼影响UI: bool = false:
	set(value):
		鱼眼影响UI = value
		if _fisheye_canvas_layer:
			_fisheye_canvas_layer.layer = 10 if value else -1

@export_group("屏幕噪点")
@export var 启用噪点: bool = false:
	set(value):
		启用噪点 = value
		if _noise_color_rect:
			_noise_color_rect.visible = value

@export var 噪点强度: float = 0.1:
	set(value):
		噪点强度 = clamp(value, 0.0, 1.0)
		if _noise_color_rect and _noise_color_rect.material:
			_noise_color_rect.material.set_shader_parameter("intensity", 噪点强度)

@export var 噪点速度: float = 0.5:
	set(value):
		噪点速度 = max(0.0, value)
		if _noise_color_rect and _noise_color_rect.material:
			_noise_color_rect.material.set_shader_parameter("speed", 噪点速度)

@export_enum("黑白", "彩色") var 噪点模式: int = 0:
	set(value):
		噪点模式 = value
		if _noise_color_rect and _noise_color_rect.material:
			_noise_color_rect.material.set_shader_parameter("mode", value)

@export var 噪点影响UI: bool = false:
	set(value):
		噪点影响UI = value
		if _noise_canvas_layer:
			_noise_canvas_layer.layer = 10 if value else -1

@export_group("像素化")
@export var 启用像素化: bool = false:
	set(value):
		启用像素化 = value
		if _pixelation_color_rect:
			_pixelation_color_rect.visible = value

@export var 像素大小: float = 0.004:
	set(value):
		像素大小 = clamp(value, 0.001, 0.2)
		if _pixelation_color_rect and _pixelation_color_rect.material:
			_pixelation_color_rect.material.set_shader_parameter("pixel_size", 像素大小)

@export var 像素化影响UI: bool = false:
	set(value):
		像素化影响UI = value
		if _pixelation_canvas_layer:
			_pixelation_canvas_layer.layer = 10 if value else -1

@export_group("全屏模糊")
@export var 启用全屏模糊: bool = false:
	set(value):
		启用全屏模糊 = value
		if _gaussian_color_rect:
			_gaussian_color_rect.visible = value

@export var 模糊强度: float = 5.0:
	set(value):
		模糊强度 = max(0.0, value)
		if _gaussian_color_rect and _gaussian_color_rect.material:
			_gaussian_color_rect.material.set_shader_parameter("intensity", 模糊强度)

@export var 模糊采样数: int = 12:
	set(value):
		模糊采样数 = max(4, value)
		if _gaussian_color_rect and _gaussian_color_rect.material:
			_gaussian_color_rect.material.set_shader_parameter("samples", 模糊采样数)

@export var 全屏模糊影响UI: bool = false:
	set(value):
		全屏模糊影响UI = value
		if _gaussian_canvas_layer:
			_gaussian_canvas_layer.layer = 10 if value else -1

@export_group("径向模糊")
@export var 启用径向模糊: bool = false:
	set(value):
		启用径向模糊 = value
		if _radial_color_rect:
			_radial_color_rect.visible = value

@export_enum("全屏径向模糊", "边缘径向模糊") var 径向模糊模式: int = 0:
	set(value):
		径向模糊模式 = value
		if _radial_color_rect and _radial_color_rect.material:
			_radial_color_rect.material.set_shader_parameter("mode", value)

@export_enum("中心", "左上", "右上", "左下", "右下", "顶部", "底部", "左", "右") var 中心预设: String = "中心":
	set(value):
		中心预设 = value
		_update_radial_center()

@export var 中心偏移量: float = 0.0:
	set(value):
		中心偏移量 = clamp(value, 0.0, 0.5)
		_update_radial_center()

@export var 径向模糊强度: float = 0.5:
	set(value):
		径向模糊强度 = max(0.0, value)
		if _radial_color_rect and _radial_color_rect.material:
			_radial_color_rect.material.set_shader_parameter("intensity", 径向模糊强度)

@export var 径向采样数: int = 12:
	set(value):
		径向采样数 = max(4, value)
		if _radial_color_rect and _radial_color_rect.material:
			_radial_color_rect.material.set_shader_parameter("samples", 径向采样数)

@export var 径向模糊影响UI: bool = false:
	set(value):
		径向模糊影响UI = value
		if _radial_canvas_layer:
			_radial_canvas_layer.layer = 10 if value else -1

var _current_center_x: float = 0.5
var _current_center_y: float = 0.5

func _update_radial_center():
	var offset = 中心偏移量
	var cx = 0.5
	var cy = 0.5
	match 中心预设:
		"中心":
			cx = 0.5
			cy = 0.5
		"左上":
			cx = 0.5 - offset
			cy = 0.5 - offset
		"右上":
			cx = 0.5 + offset
			cy = 0.5 - offset
		"左下":
			cx = 0.5 - offset
			cy = 0.5 + offset
		"右下":
			cx = 0.5 + offset
			cy = 0.5 + offset
		"顶部":
			cx = 0.5
			cy = 0.5 - offset
		"底部":
			cx = 0.5
			cy = 0.5 + offset
		"左":
			cx = 0.5 - offset
			cy = 0.5
		"右":
			cx = 0.5 + offset
			cy = 0.5
	cx = clamp(cx, 0.0, 1.0)
	cy = clamp(cy, 0.0, 1.0)
	_current_center_x = cx
	_current_center_y = cy
	if _radial_color_rect and _radial_color_rect.material:
		_radial_color_rect.material.set_shader_parameter("center_x", cx)
		_radial_color_rect.material.set_shader_parameter("center_y", cy)

@export_group("物体遮罩模糊")
@export var 启用物体模糊: bool = false:
	set(value):
		启用物体模糊 = value
		if _blur_material:
			_blur_material.set_shader_parameter("enable_blur", value)
		if _blur_rect:
			_blur_rect.visible = value

@export var 反向模糊: bool = false:
	set(value):
		反向模糊 = value
		if _blur_material:
			_blur_material.set_shader_parameter("reverse_blur", value)

@export var 物体模糊强度: float = 10.0:
	set(value):
		物体模糊强度 = max(0.0, value)
		if _blur_material:
			_blur_material.set_shader_parameter("blur_strength", value)

@export var 物体模糊半径: float = 15.0:
	set(value):
		物体模糊半径 = max(0.0, value)
		if _blur_material:
			_blur_material.set_shader_parameter("blur_radius", value)

@export var 降采样: float = 0.5:
	set(value):
		降采样 = clamp(value, 0.25, 1.0)
		if _blur_sub_viewport:
			var size = get_viewport().get_visible_rect().size * 降采样
			_blur_sub_viewport.size = Vector2i(size)

@export var 遮罩采样质量: int = 8:
	set(value):
		遮罩采样质量 = clamp(value, 4, 16)
		if _blur_material:
			_blur_material.set_shader_parameter("samples", 遮罩采样质量)

@export var 物体模糊影响UI: bool = false:
	set(value):
		物体模糊影响UI = value
		if _blur_canvas_layer2:
			_blur_canvas_layer2.layer = 1000 if value else -1

@export_group("轮廓描边")
@export var 启用轮廓描边: bool = false:
	set(value):
		启用轮廓描边 = value
		if _outline_color_rect:
			_outline_color_rect.visible = value

@export var 轮廓颜色: Color = Color(1, 1, 1, 1):
	set(value):
		轮廓颜色 = value
		if _outline_color_rect and _outline_color_rect.material:
			_outline_color_rect.material.set_shader_parameter("outline_color", value)

@export var 轮廓阈值: float = 0.1:
	set(value):
		轮廓阈值 = clamp(value, 0.0, 1.0)
		if _outline_color_rect and _outline_color_rect.material:
			_outline_color_rect.material.set_shader_parameter("threshold", 轮廓阈值)

@export var 轮廓强度: float = 1.0:
	set(value):
		轮廓强度 = clamp(value, 0.0, 3.0)
		if _outline_color_rect and _outline_color_rect.material:
			_outline_color_rect.material.set_shader_parameter("intensity", 轮廓强度)

@export var 轮廓影响UI: bool = false:
	set(value):
		轮廓影响UI = value
		if _outline_canvas_layer:
			_outline_canvas_layer.layer = 10 if value else -1

@export_group("CRT效果")
@export var 启用CRT: bool = false:
	set(value):
		启用CRT = value
		if _crt_color_rect:
			_crt_color_rect.visible = value

@export var 扫描线强度: float = 0.3:
	set(value):
		扫描线强度 = clamp(value, 0.0, 1.0)
		if _crt_color_rect and _crt_color_rect.material:
			_crt_color_rect.material.set_shader_parameter("scanline_strength", 扫描线强度)

@export var 扫描线密度: float = 2.0:
	set(value):
		扫描线密度 = max(0.1, value)
		if _crt_color_rect and _crt_color_rect.material:
			_crt_color_rect.material.set_shader_parameter("scanline_density", 扫描线密度)

@export var 屏幕弯曲: float = 0.3:
	set(value):
		屏幕弯曲 = clamp(value, 0.0, 1.0)
		if _crt_color_rect and _crt_color_rect.material:
			_crt_color_rect.material.set_shader_parameter("curvature", 屏幕弯曲)

@export var 色彩偏移强度: float = 0.02:
	set(value):
		色彩偏移强度 = clamp(value, 0.0, 0.1)
		if _crt_color_rect and _crt_color_rect.material:
			_crt_color_rect.material.set_shader_parameter("chroma_shift", 色彩偏移强度)

@export var CRT影响UI: bool = false:
	set(value):
		CRT影响UI = value
		if _crt_canvas_layer:
			_crt_canvas_layer.layer = 10 if value else -1

@export_group("色调映射")
@export var 启用色调映射: bool = false:
	set(value):
		启用色调映射 = value
		if _color_grading_color_rect:
			_color_grading_color_rect.visible = value

@export var 亮度: float = 0.0:
	set(value):
		亮度 = clamp(value, -1.0, 1.0)
		if _color_grading_color_rect and _color_grading_color_rect.material:
			_color_grading_color_rect.material.set_shader_parameter("brightness", 亮度)

@export var 对比度: float = 1.0:
	set(value):
		对比度 = clamp(value, 0.0, 3.0)
		if _color_grading_color_rect and _color_grading_color_rect.material:
			_color_grading_color_rect.material.set_shader_parameter("contrast", 对比度)

@export var 饱和度: float = 1.0:
	set(value):
		饱和度 = clamp(value, 0.0, 2.0)
		if _color_grading_color_rect and _color_grading_color_rect.material:
			_color_grading_color_rect.material.set_shader_parameter("saturation", 饱和度)

@export var 色相偏移: float = 0.0:
	set(value):
		色相偏移 = clamp(value, 0.0, 360.0)
		if _color_grading_color_rect and _color_grading_color_rect.material:
			_color_grading_color_rect.material.set_shader_parameter("hue_shift", 色相偏移)

@export_group("锐化")
@export var 启用锐化: bool = false:
	set(value):
		启用锐化 = value
		if _sharpen_color_rect:
			_sharpen_color_rect.visible = value

@export var 锐化强度: float = 0.3:
	set(value):
		锐化强度 = clamp(value, 0.0, 2.0)
		if _sharpen_color_rect and _sharpen_color_rect.material:
			_sharpen_color_rect.material.set_shader_parameter("intensity", 锐化强度)

@export_group("泛光")
@export var 启用泛光: bool = false:
	set(value):
		启用泛光 = value
		if _bloom_color_rect:
			_bloom_color_rect.visible = value

@export var 泛光强度: float = 0.5:
	set(value):
		泛光强度 = clamp(value, 0.0, 2.0)
		if _bloom_color_rect and _bloom_color_rect.material:
			_bloom_color_rect.material.set_shader_parameter("intensity", 泛光强度)

@export var 泛光阈值: float = 0.3:
	set(value):
		泛光阈值 = clamp(value, 0.0, 1.0)
		if _bloom_color_rect and _bloom_color_rect.material:
			_bloom_color_rect.material.set_shader_parameter("threshold", 泛光阈值)

@export var 泛光半径: float = 0.02:
	set(value):
		泛光半径 = clamp(value, 0.001, 0.1)
		if _bloom_color_rect and _bloom_color_rect.material:
			_bloom_color_rect.material.set_shader_parameter("radius", 泛光半径)

@export var 泛光采样数: int = 12:
	set(value):
		泛光采样数 = max(4, value)
		if _bloom_color_rect and _bloom_color_rect.material:
			_bloom_color_rect.material.set_shader_parameter("samples", 泛光采样数)

var _blur_prev_rot := Vector2.ZERO
var _blur_canvas_layer: CanvasLayer = null
var _blur_color_rect: ColorRect = null
var _dof_attribs: CameraAttributesPractical = null
var _ca_canvas_layer: CanvasLayer = null
var _ca_color_rect: ColorRect = null
var _vignette_canvas_layer: CanvasLayer = null
var _vignette_color_rect: ColorRect = null
var _glitch_canvas_layer: CanvasLayer = null
var _glitch_color_rect: ColorRect = null
var _glitch_time: float = 0.0
var _fisheye_canvas_layer: CanvasLayer = null
var _fisheye_color_rect: ColorRect = null
var _noise_canvas_layer: CanvasLayer = null
var _noise_color_rect: ColorRect = null
var _noise_time: float = 0.0
var _pixelation_canvas_layer: CanvasLayer = null
var _pixelation_color_rect: ColorRect = null
var _gaussian_canvas_layer: CanvasLayer = null
var _gaussian_color_rect: ColorRect = null
var _radial_canvas_layer: CanvasLayer = null
var _radial_color_rect: ColorRect = null
var _outline_canvas_layer: CanvasLayer = null
var _outline_color_rect: ColorRect = null
var _crt_canvas_layer: CanvasLayer = null
var _crt_color_rect: ColorRect = null
var _color_grading_canvas_layer: CanvasLayer = null
var _color_grading_color_rect: ColorRect = null
var _sharpen_canvas_layer: CanvasLayer = null
var _sharpen_color_rect: ColorRect = null
var _bloom_canvas_layer: CanvasLayer = null
var _bloom_color_rect: ColorRect = null

var _blur_canvas_layer2: CanvasLayer = null
var _blur_rect: ColorRect = null
var _blur_material: ShaderMaterial = null
var _blur_back_buffer: BackBufferCopy = null
var _blur_targets: Array[MeshInstance3D] = []
var _blur_sub_viewport: SubViewport = null
var _blur_sub_camera: Camera3D = null

func _ready():
	_blur_prev_rot = Vector2(rotation.y, rotation.x)
	await get_tree().process_frame
	_setup_blur()
	_init_dof()
	_update_dof()
	_setup_ca()
	_setup_vignette()
	_setup_glitch()
	_setup_fisheye()
	_setup_noise()
	_setup_pixelation()
	_setup_gaussian_blur()
	_setup_radial_blur()
	_setup_outline()
	_setup_crt()
	_setup_color_grading()
	_setup_sharpen()
	_setup_bloom()
	_setup_object_blur()

func _process(delta):
	if 启用动态模糊:
		var current_rot = Vector2(rotation.y, rotation.x)
		var rot_delta = current_rot - _blur_prev_rot
		_blur_prev_rot = current_rot
		var motion = -rot_delta * 灵敏度
		var speed = motion.length()
		if _blur_color_rect and _blur_color_rect.material:
			if speed > 0.0001:
				var dir = motion.normalized()
				var intensity = clamp(speed, 0.0, 最大强度)
				_blur_color_rect.material.set_shader_parameter("direction", dir)
				_blur_color_rect.material.set_shader_parameter("intensity", intensity)
			else:
				_blur_color_rect.material.set_shader_parameter("intensity", 0.0)
	if 启用故障 and _glitch_color_rect and _glitch_color_rect.material:
		_glitch_time += delta * 故障速度
		_glitch_color_rect.material.set_shader_parameter("time", _glitch_time)
	if 启用噪点 and _noise_color_rect and _noise_color_rect.material:
		_noise_time += delta * 噪点速度
		_noise_color_rect.material.set_shader_parameter("time", _noise_time)
	if _blur_sub_camera and not _blur_targets.is_empty():
		_blur_sub_camera.global_transform = global_transform

func _setup_object_blur():
	_find_blur_targets()
	if _blur_targets.is_empty():
		return
	var viewport_size = get_viewport().get_visible_rect().size
	var scaled_size = viewport_size * clamp(降采样, 0.25, 1.0)
	_blur_sub_viewport = SubViewport.new()
	_blur_sub_viewport.size = Vector2i(scaled_size)
	_blur_sub_viewport.transparent_bg = true
	add_child(_blur_sub_viewport)
	_blur_sub_camera = Camera3D.new()
	_blur_sub_camera.cull_mask = 2
	_blur_sub_camera.global_transform = global_transform
	_blur_sub_viewport.add_child(_blur_sub_camera)
	for target in _blur_targets:
		target.layers = 2
		for child in target.get_children():
			if child is MeshInstance3D:
				child.layers = 2
	self.cull_mask = -1
	_blur_canvas_layer2 = CanvasLayer.new()
	_blur_canvas_layer2.layer = 1000 if 物体模糊影响UI else -1
	add_child(_blur_canvas_layer2)
	_blur_back_buffer = BackBufferCopy.new()
	_blur_back_buffer.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	_blur_canvas_layer2.add_child(_blur_back_buffer)
	_blur_rect = ColorRect.new()
	_blur_rect.anchor_left = 0.0
	_blur_rect.anchor_top = 0.0
	_blur_rect.anchor_right = 1.0
	_blur_rect.anchor_bottom = 1.0
	_blur_rect.offset_left = 0
	_blur_rect.offset_top = 0
	_blur_rect.offset_right = 0
	_blur_rect.offset_bottom = 0
	_blur_rect.color = Color(1, 1, 1, 1)
	_blur_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_blur_rect.visible = 启用物体模糊
	_blur_canvas_layer2.add_child(_blur_rect)
	await get_tree().process_frame
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform sampler2D MASK_TEXTURE;
	uniform bool enable_blur = true;
	uniform float blur_strength = 10.0;
	uniform float blur_radius = 15.0;
	uniform int samples = 8;
	uniform bool reverse_blur = false;
	void fragment() {
		vec2 uv = UV;
		if (enable_blur) {
			vec4 mask_tex = texture(MASK_TEXTURE, uv);
			float object_mask = step(0.1, mask_tex.a);
			vec2 texel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
			float radius = blur_radius * 2.0;
			float sigma = radius * 0.3;
			int steps = samples;
			vec4 color_h = vec4(0.0);
			float total_h = 0.0;
			for (int i = -steps; i <= steps; i++) {
				float fi = float(i);
				float dist = abs(fi);
				if (dist > radius) continue;
				vec2 sample_uv = uv + vec2(fi * texel_size.x, 0.0);
				sample_uv = clamp(sample_uv, 0.0, 1.0);
				float weight = exp(-(dist * dist) / (2.0 * sigma * sigma));
				color_h += texture(SCREEN_TEXTURE, sample_uv) * weight;
				total_h += weight;
			}
			color_h /= total_h;
			vec4 color_v = vec4(0.0);
			float total_v = 0.0;
			for (int j = -steps; j <= steps; j++) {
				float fj = float(j);
				float dist = abs(fj);
				if (dist > radius) continue;
				vec2 sample_uv = uv + vec2(0.0, fj * texel_size.y);
				sample_uv = clamp(sample_uv, 0.0, 1.0);
				float weight = exp(-(dist * dist) / (2.0 * sigma * sigma));
				color_v += texture(SCREEN_TEXTURE, sample_uv) * weight;
				total_v += weight;
			}
			color_v /= total_v;
			vec4 blurred = (color_h + color_v) * 0.5;
			vec4 original = texture(SCREEN_TEXTURE, uv);
			float mask = reverse_blur ? (1.0 - object_mask) : object_mask;
			float blend = mask * blur_strength;
			COLOR = mix(original, blurred, clamp(blend, 0.0, 1.0));
		} else {
			COLOR = texture(SCREEN_TEXTURE, uv);
		}
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	_blur_material = ShaderMaterial.new()
	_blur_material.shader = shader
	_blur_material.set_shader_parameter("enable_blur", 启用物体模糊)
	_blur_material.set_shader_parameter("blur_strength", 物体模糊强度)
	_blur_material.set_shader_parameter("blur_radius", 物体模糊半径)
	_blur_material.set_shader_parameter("samples", 遮罩采样质量)
	_blur_material.set_shader_parameter("reverse_blur", 反向模糊)
	_blur_material.set_shader_parameter("MASK_TEXTURE", _blur_sub_viewport.get_texture())
	_blur_rect.material = _blur_material

func _find_blur_targets():
	_blur_targets.clear()
	var nodes = get_tree().root.find_children("模糊区域", "Node3D", true, false)
	if nodes.is_empty():
		return
	for node in nodes:
		if node is Node3D:
			var parent = node.get_parent()
			var mesh_instance: MeshInstance3D = null
			while parent:
				if parent is MeshInstance3D:
					mesh_instance = parent
					break
				parent = parent.get_parent()
			if mesh_instance:
				_blur_targets.append(mesh_instance)

func _setup_blur():
	_blur_canvas_layer = CanvasLayer.new()
	_blur_canvas_layer.layer = -2
	add_child(_blur_canvas_layer)
	_blur_color_rect = ColorRect.new()
	_blur_color_rect.anchor_left = 0.0
	_blur_color_rect.anchor_top = 0.0
	_blur_color_rect.anchor_right = 1.0
	_blur_color_rect.anchor_bottom = 1.0
	_blur_color_rect.offset_left = 0
	_blur_color_rect.offset_top = 0
	_blur_color_rect.offset_right = 0
	_blur_color_rect.offset_bottom = 0
	_blur_color_rect.color = Color(1, 1, 1, 1)
	_blur_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform vec2 direction = vec2(0.0, 0.0);
	uniform float intensity : hint_range(0.0, 0.1) = 0.02;
	uniform int samples : hint_range(4, 32) = 8;
	uniform float sigma : hint_range(0.1, 2.0) = 0.5;
	void fragment() {
		vec2 uv = UV;
		if (intensity < 0.0001) {
			COLOR = texture(SCREEN_TEXTURE, uv);
		} else {
			vec2 offset = direction * intensity;
			vec4 color = vec4(0.0);
			float total_weight = 0.0;
			for (int i = 0; i < samples; i++) {
				float t = float(i) / float(samples - 1);
				float pos = t - 0.5;
				float weight = exp(-(pos * pos) / (2.0 * sigma * sigma));
				vec2 sample_uv = uv + offset * pos;
				sample_uv = clamp(sample_uv, 0.0, 1.0);
				color += texture(SCREEN_TEXTURE, sample_uv) * weight;
				total_weight += weight;
			}
			COLOR = color / total_weight;
		}
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("direction", Vector2.ZERO)
	material.set_shader_parameter("intensity", 0.0)
	material.set_shader_parameter("samples", 采样数)
	material.set_shader_parameter("sigma", 高斯标准差)
	_blur_color_rect.material = material
	_blur_canvas_layer.add_child(_blur_color_rect)

func _update_blur_shader_param(param: StringName, value):
	if _blur_color_rect and _blur_color_rect.material:
		_blur_color_rect.material.set_shader_parameter(param, value)

func _init_dof():
	var attr = attributes
	if attr == null:
		_dof_attribs = CameraAttributesPractical.new()
		attributes = _dof_attribs
	elif attr is CameraAttributesPractical:
		_dof_attribs = attr
	else:
		_dof_attribs = CameraAttributesPractical.new()
		attributes = _dof_attribs

func _update_dof():
	if _dof_attribs == null:
		_init_dof()
	if 启用景深:
		_dof_attribs.dof_blur_far_enabled = true
		_dof_attribs.dof_blur_near_enabled = true
		_dof_attribs.dof_blur_amount = 景深强度
		_dof_attribs.dof_blur_far_distance = 远模糊起始距离
		_dof_attribs.dof_blur_near_distance = 近模糊起始距离
	else:
		_dof_attribs.dof_blur_far_enabled = false
		_dof_attribs.dof_blur_near_enabled = false

func _setup_ca():
	_ca_canvas_layer = CanvasLayer.new()
	_ca_canvas_layer.layer = 10 if 色散影响UI else -1
	add_child(_ca_canvas_layer)
	_ca_color_rect = ColorRect.new()
	_ca_color_rect.anchor_left = 0.0
	_ca_color_rect.anchor_top = 0.0
	_ca_color_rect.anchor_right = 1.0
	_ca_color_rect.anchor_bottom = 1.0
	_ca_color_rect.offset_left = 0
	_ca_color_rect.offset_top = 0
	_ca_color_rect.offset_right = 0
	_ca_color_rect.offset_bottom = 0
	_ca_color_rect.color = Color(1, 1, 1, 1)
	_ca_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ca_color_rect.visible = 启用色散
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity : hint_range(0.0, 0.1) = 0.02;
	void fragment() {
		vec2 uv = UV;
		vec2 center = vec2(0.5, 0.5);
		vec2 dir = uv - center;
		float dist = length(dir);
		vec2 offset = dir * intensity * dist;
		vec2 uv_r = uv + offset;
		vec2 uv_b = uv - offset;
		uv_r = clamp(uv_r, 0.0, 1.0);
		uv_b = clamp(uv_b, 0.0, 1.0);
		float r = texture(SCREEN_TEXTURE, uv_r).r;
		float g = texture(SCREEN_TEXTURE, uv).g;
		float b = texture(SCREEN_TEXTURE, uv_b).b;
		COLOR = vec4(r, g, b, 1.0);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 色散强度)
	_ca_color_rect.material = material
	_ca_canvas_layer.add_child(_ca_color_rect)

func _setup_vignette():
	_vignette_canvas_layer = CanvasLayer.new()
	_vignette_canvas_layer.layer = 10 if 暗角影响UI else -1
	add_child(_vignette_canvas_layer)
	_vignette_color_rect = ColorRect.new()
	_vignette_color_rect.anchor_left = 0.0
	_vignette_color_rect.anchor_top = 0.0
	_vignette_color_rect.anchor_right = 1.0
	_vignette_color_rect.anchor_bottom = 1.0
	_vignette_color_rect.offset_left = 0
	_vignette_color_rect.offset_top = 0
	_vignette_color_rect.offset_right = 0
	_vignette_color_rect.offset_bottom = 0
	_vignette_color_rect.color = Color(1, 1, 1, 1)
	_vignette_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vignette_color_rect.visible = 启用暗角
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity : hint_range(0.0, 3.0) = 0.8;
	uniform float radius : hint_range(0.0, 1.0) = 0.5;
	uniform float softness : hint_range(0.0, 1.0) = 0.4;
	uniform vec4 vignette_color : source_color = vec4(0.0);
	uniform int shape_type : hint_range(0, 2) = 1;
	void fragment() {
		vec2 uv = SCREEN_UV;
		vec2 centered = uv - vec2(0.5);
		float edge;
		if (shape_type == 0) {
			edge = max(abs(centered.x) * 2.0, abs(centered.y) * 2.0);
		} else if (shape_type == 2) {
			edge = length(centered) * 2.0;
		} else {
			float rx = 0.8;
			float ry = 1.0;
			edge = length(centered / vec2(rx, ry)) * 2.0;
		}
		float v = smoothstep(radius, radius + softness, edge);
		v = pow(v, 2.0);
		float alpha = clamp(v * intensity, 0.0, 1.0);
		vec4 bg = texture(SCREEN_TEXTURE, uv);
		COLOR = mix(bg, vignette_color, alpha);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 暗角强度)
	material.set_shader_parameter("radius", 暗角半径)
	material.set_shader_parameter("softness", 暗角柔化)
	material.set_shader_parameter("vignette_color", 暗角颜色)
	material.set_shader_parameter("shape_type", 暗角形状)
	_vignette_color_rect.material = material
	_vignette_canvas_layer.add_child(_vignette_color_rect)

func _setup_glitch():
	_glitch_canvas_layer = CanvasLayer.new()
	_glitch_canvas_layer.layer = 10 if 故障影响UI else -1
	add_child(_glitch_canvas_layer)
	_glitch_color_rect = ColorRect.new()
	_glitch_color_rect.anchor_left = 0.0
	_glitch_color_rect.anchor_top = 0.0
	_glitch_color_rect.anchor_right = 1.0
	_glitch_color_rect.anchor_bottom = 1.0
	_glitch_color_rect.offset_left = 0
	_glitch_color_rect.offset_top = 0
	_glitch_color_rect.offset_right = 0
	_glitch_color_rect.offset_bottom = 0
	_glitch_color_rect.color = Color(1, 1, 1, 1)
	_glitch_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_glitch_color_rect.visible = 启用故障
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float time = 0.0;
	uniform float intensity : hint_range(0.0, 1.0) = 0.5;
	uniform float speed : hint_range(0.0, 2.0) = 1.0;
	uniform float tear_strength : hint_range(0.0, 1.0) = 0.3;
	uniform float chroma_strength : hint_range(0.0, 1.0) = 0.2;
	float hash(float x) { return fract(sin(x * 127.1 + 311.7) * 43758.5453123); }
	void fragment() {
		vec2 uv = UV;
		float t = time * speed;
		float seed = floor(t * 10.0);
		float tear_amount = tear_strength * intensity;
		float tear = 0.0;
		if (tear_amount > 0.001) {
			float line = floor(uv.y * 20.0 + hash(seed + 0.5) * 3.0);
			float offset = hash(line + seed + 1.0) - 0.5;
			tear = offset * tear_amount * 0.5;
		}
		vec2 tear_uv = uv + vec2(tear, 0.0);
		float chroma = chroma_strength * intensity;
		vec2 chroma_offset = vec2(hash(seed + 2.0) - 0.5, hash(seed + 3.0) - 0.5) * chroma * 0.1;
		vec2 uv_r = tear_uv + chroma_offset;
		vec2 uv_g = tear_uv;
		vec2 uv_b = tear_uv - chroma_offset;
		uv_r = clamp(uv_r, 0.0, 1.0);
		uv_g = clamp(uv_g, 0.0, 1.0);
		uv_b = clamp(uv_b, 0.0, 1.0);
		float r = texture(SCREEN_TEXTURE, uv_r).r;
		float g = texture(SCREEN_TEXTURE, uv_g).g;
		float b = texture(SCREEN_TEXTURE, uv_b).b;
		COLOR = vec4(r, g, b, 1.0);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("time", 0.0)
	material.set_shader_parameter("intensity", 故障强度)
	material.set_shader_parameter("speed", 故障速度)
	material.set_shader_parameter("tear_strength", 撕裂强度)
	material.set_shader_parameter("chroma_strength", 色散干扰)
	_glitch_color_rect.material = material
	_glitch_canvas_layer.add_child(_glitch_color_rect)

func _setup_fisheye():
	_fisheye_canvas_layer = CanvasLayer.new()
	_fisheye_canvas_layer.layer = 10 if 鱼眼影响UI else -1
	add_child(_fisheye_canvas_layer)
	_fisheye_color_rect = ColorRect.new()
	_fisheye_color_rect.anchor_left = 0.0
	_fisheye_color_rect.anchor_top = 0.0
	_fisheye_color_rect.anchor_right = 1.0
	_fisheye_color_rect.anchor_bottom = 1.0
	_fisheye_color_rect.offset_left = 0
	_fisheye_color_rect.offset_top = 0
	_fisheye_color_rect.offset_right = 0
	_fisheye_color_rect.offset_bottom = 0
	_fisheye_color_rect.color = Color(1, 1, 1, 1)
	_fisheye_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fisheye_color_rect.visible = 启用鱼眼
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity : hint_range(0.0, 2.0) = 0.5;
	uniform float center_x : hint_range(0.0, 1.0) = 0.5;
	uniform float center_y : hint_range(0.0, 1.0) = 0.5;
	void fragment() {
		vec2 uv = UV;
		vec2 center = vec2(center_x, center_y);
		vec2 dir = uv - center;
		float dist = length(dir);
		float max_dist = length(vec2(1.0 - center_x, 1.0 - center_y));
		float normalized_dist = dist / max_dist;
		float radius = intensity * 0.8;
		float factor = 1.0 + radius * normalized_dist * normalized_dist;
		vec2 distorted_uv = center + dir / factor;
		distorted_uv = clamp(distorted_uv, 0.0, 1.0);
		COLOR = texture(SCREEN_TEXTURE, distorted_uv);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 鱼眼强度)
	material.set_shader_parameter("center_x", 鱼眼中心X)
	material.set_shader_parameter("center_y", 鱼眼中心Y)
	_fisheye_color_rect.material = material
	_fisheye_canvas_layer.add_child(_fisheye_color_rect)

func _setup_noise():
	_noise_canvas_layer = CanvasLayer.new()
	_noise_canvas_layer.layer = 10 if 噪点影响UI else -1
	add_child(_noise_canvas_layer)
	_noise_color_rect = ColorRect.new()
	_noise_color_rect.anchor_left = 0.0
	_noise_color_rect.anchor_top = 0.0
	_noise_color_rect.anchor_right = 1.0
	_noise_color_rect.anchor_bottom = 1.0
	_noise_color_rect.offset_left = 0
	_noise_color_rect.offset_top = 0
	_noise_color_rect.offset_right = 0
	_noise_color_rect.offset_bottom = 0
	_noise_color_rect.color = Color(1, 1, 1, 1)
	_noise_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_noise_color_rect.visible = 启用噪点
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity : hint_range(0.0, 1.0) = 0.1;
	uniform float time = 0.0;
	uniform float speed : hint_range(0.0, 2.0) = 0.5;
	uniform int mode : hint_range(0, 1) = 0;
	float hash(vec2 p) {
		return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
	}
	void fragment() {
		vec2 uv = UV;
		vec2 seed = uv * 200.0 + time * 10.0;
		float noise = hash(seed);
		float noise2 = hash(seed + vec2(1.0, 0.0));
		float noise3 = hash(seed + vec2(0.0, 1.0));
		vec4 bg = texture(SCREEN_TEXTURE, uv);
		if (mode == 0) {
			float gray = dot(bg.rgb, vec3(0.299, 0.587, 0.114));
			float mixed = mix(gray, noise, intensity);
			COLOR = vec4(vec3(mixed), bg.a);
		} else {
			vec3 color_noise = vec3(noise, noise2, noise3);
			vec3 mixed = mix(bg.rgb, color_noise, intensity);
			COLOR = vec4(mixed, bg.a);
		}
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 噪点强度)
	material.set_shader_parameter("time", 0.0)
	material.set_shader_parameter("speed", 噪点速度)
	material.set_shader_parameter("mode", 噪点模式)
	_noise_color_rect.material = material
	_noise_canvas_layer.add_child(_noise_color_rect)

func _setup_pixelation():
	_pixelation_canvas_layer = CanvasLayer.new()
	_pixelation_canvas_layer.layer = 10 if 像素化影响UI else -1
	add_child(_pixelation_canvas_layer)
	_pixelation_color_rect = ColorRect.new()
	_pixelation_color_rect.anchor_left = 0.0
	_pixelation_color_rect.anchor_top = 0.0
	_pixelation_color_rect.anchor_right = 1.0
	_pixelation_color_rect.anchor_bottom = 1.0
	_pixelation_color_rect.offset_left = 0
	_pixelation_color_rect.offset_top = 0
	_pixelation_color_rect.offset_right = 0
	_pixelation_color_rect.offset_bottom = 0
	_pixelation_color_rect.color = Color(1, 1, 1, 1)
	_pixelation_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_pixelation_color_rect.visible = 启用像素化
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float pixel_size : hint_range(0.001, 0.2) = 0.02;
	void fragment() {
		vec2 uv = UV;
		vec2 pixelated_uv = floor(uv / pixel_size) * pixel_size + pixel_size * 0.5;
		pixelated_uv = clamp(pixelated_uv, 0.0, 1.0);
		COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("pixel_size", 像素大小)
	_pixelation_color_rect.material = material
	_pixelation_canvas_layer.add_child(_pixelation_color_rect)

func _setup_gaussian_blur():
	_gaussian_canvas_layer = CanvasLayer.new()
	_gaussian_canvas_layer.layer = 10 if 全屏模糊影响UI else -1
	add_child(_gaussian_canvas_layer)
	_gaussian_color_rect = ColorRect.new()
	_gaussian_color_rect.anchor_left = 0.0
	_gaussian_color_rect.anchor_top = 0.0
	_gaussian_color_rect.anchor_right = 1.0
	_gaussian_color_rect.anchor_bottom = 1.0
	_gaussian_color_rect.offset_left = 0
	_gaussian_color_rect.offset_top = 0
	_gaussian_color_rect.offset_right = 0
	_gaussian_color_rect.offset_bottom = 0
	_gaussian_color_rect.color = Color(1, 1, 1, 1)
	_gaussian_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_gaussian_color_rect.visible = 启用全屏模糊
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity = 0.5;
	uniform int samples : hint_range(4, 32) = 12;
	void fragment() {
		vec2 uv = UV;
		vec2 texel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
		float radius = intensity * 2.0;
		if (radius < 0.1) {
			COLOR = texture(SCREEN_TEXTURE, uv);
		} else {
			vec4 color = vec4(0.0);
			float total_weight = 0.0;
			float step_size = (radius * 2.0) / float(samples);
			for (int i = 0; i < samples; i++) {
				for (int j = 0; j < samples; j++) {
					float offset_x = -radius + step_size * (float(i) + 0.5);
					float offset_y = -radius + step_size * (float(j) + 0.5);
					vec2 offset = vec2(offset_x, offset_y) * texel_size;
					vec2 sample_uv = uv + offset;
					sample_uv = clamp(sample_uv, 0.0, 1.0);
					color += texture(SCREEN_TEXTURE, sample_uv);
					total_weight += 1.0;
				}
			}
			color /= total_weight;
			COLOR = color;
		}
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 模糊强度)
	material.set_shader_parameter("samples", 模糊采样数)
	_gaussian_color_rect.material = material
	_gaussian_canvas_layer.add_child(_gaussian_color_rect)

func _setup_radial_blur():
	_radial_canvas_layer = CanvasLayer.new()
	_radial_canvas_layer.layer = 10 if 径向模糊影响UI else -1
	add_child(_radial_canvas_layer)
	_radial_color_rect = ColorRect.new()
	_radial_color_rect.anchor_left = 0.0
	_radial_color_rect.anchor_top = 0.0
	_radial_color_rect.anchor_right = 1.0
	_radial_color_rect.anchor_bottom = 1.0
	_radial_color_rect.offset_left = 0
	_radial_color_rect.offset_top = 0
	_radial_color_rect.offset_right = 0
	_radial_color_rect.offset_bottom = 0
	_radial_color_rect.color = Color(1, 1, 1, 1)
	_radial_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_radial_color_rect.visible = 启用径向模糊
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity : hint_range(0.0, 2.0) = 0.5;
	uniform float center_x : hint_range(0.0, 1.0) = 0.5;
	uniform float center_y : hint_range(0.0, 1.0) = 0.5;
	uniform int samples : hint_range(4, 32) = 12;
	uniform int mode : hint_range(0, 1) = 0;
	void fragment() {
		vec2 uv = UV;
		vec2 center = vec2(center_x, center_y);
		vec2 dir = uv - center;
		float dist = length(dir);
		if (intensity < 0.001 || dist < 0.001) {
			COLOR = texture(SCREEN_TEXTURE, uv);
		} else {
			vec2 dir_norm = dir / dist;
			vec4 color = vec4(0.0);
			float total_weight = 0.0;
			float sigma = intensity * 0.3;
			float max_radius = intensity * 0.5;
			float factor = 1.0;
			if (mode == 1) {
				float max_dist = length(vec2(1.0 - center_x, 1.0 - center_y));
				factor = clamp(dist / max_dist, 0.0, 1.0);
			}
			for (int i = 0; i < samples; i++) {
				float t = float(i) / float(samples - 1);
				float radius = t * max_radius * factor;
				vec2 sample_uv = center + dir_norm * (dist + radius);
				sample_uv = clamp(sample_uv, 0.0, 1.0);
				float weight = exp(-(radius * radius) / (2.0 * sigma * sigma));
				color += texture(SCREEN_TEXTURE, sample_uv) * weight;
				total_weight += weight;
			}
			color /= total_weight;
			COLOR = color;
		}
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 径向模糊强度)
	material.set_shader_parameter("center_x", 0.5)
	material.set_shader_parameter("center_y", 0.5)
	material.set_shader_parameter("samples", 径向采样数)
	material.set_shader_parameter("mode", 径向模糊模式)
	_radial_color_rect.material = material
	_radial_canvas_layer.add_child(_radial_color_rect)
	_update_radial_center()

func _setup_outline():
	_outline_canvas_layer = CanvasLayer.new()
	_outline_canvas_layer.layer = 10 if 轮廓影响UI else -1
	add_child(_outline_canvas_layer)
	_outline_color_rect = ColorRect.new()
	_outline_color_rect.anchor_left = 0.0
	_outline_color_rect.anchor_top = 0.0
	_outline_color_rect.anchor_right = 1.0
	_outline_color_rect.anchor_bottom = 1.0
	_outline_color_rect.offset_left = 0
	_outline_color_rect.offset_top = 0
	_outline_color_rect.offset_right = 0
	_outline_color_rect.offset_bottom = 0
	_outline_color_rect.color = Color(1, 1, 1, 1)
	_outline_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_outline_color_rect.visible = 启用轮廓描边
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform vec4 outline_color : source_color = vec4(1.0);
	uniform float threshold : hint_range(0.0, 1.0) = 0.1;
	uniform float intensity : hint_range(0.0, 3.0) = 1.0;
	void fragment() {
		vec2 uv = UV;
		vec2 texel = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
		vec2 offset = texel;
		vec4 c00 = texture(SCREEN_TEXTURE, uv - offset);
		vec4 c01 = texture(SCREEN_TEXTURE, uv + vec2(0.0, -offset.y));
		vec4 c02 = texture(SCREEN_TEXTURE, uv + vec2(offset.x, -offset.y));
		vec4 c10 = texture(SCREEN_TEXTURE, uv + vec2(-offset.x, 0.0));
		vec4 c11 = texture(SCREEN_TEXTURE, uv);
		vec4 c12 = texture(SCREEN_TEXTURE, uv + vec2(offset.x, 0.0));
		vec4 c20 = texture(SCREEN_TEXTURE, uv + vec2(-offset.x, offset.y));
		vec4 c21 = texture(SCREEN_TEXTURE, uv + vec2(0.0, offset.y));
		vec4 c22 = texture(SCREEN_TEXTURE, uv + offset);
		float gx = -c00.r - c01.r - c02.r + c20.r + c21.r + c22.r;
		float gy = -c00.r - c10.r - c20.r + c02.r + c12.r + c22.r;
		float edge = length(vec2(gx, gy));
		edge = smoothstep(threshold, threshold + 0.2, edge);
		edge = clamp(edge * intensity, 0.0, 1.0);
		COLOR = mix(c11, outline_color, edge);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("outline_color", 轮廓颜色)
	material.set_shader_parameter("threshold", 轮廓阈值)
	material.set_shader_parameter("intensity", 轮廓强度)
	_outline_color_rect.material = material
	_outline_canvas_layer.add_child(_outline_color_rect)

func _setup_crt():
	_crt_canvas_layer = CanvasLayer.new()
	_crt_canvas_layer.layer = 10 if CRT影响UI else -1
	add_child(_crt_canvas_layer)
	_crt_color_rect = ColorRect.new()
	_crt_color_rect.anchor_left = 0.0
	_crt_color_rect.anchor_top = 0.0
	_crt_color_rect.anchor_right = 1.0
	_crt_color_rect.anchor_bottom = 1.0
	_crt_color_rect.offset_left = 0
	_crt_color_rect.offset_top = 0
	_crt_color_rect.offset_right = 0
	_crt_color_rect.offset_bottom = 0
	_crt_color_rect.color = Color(1, 1, 1, 1)
	_crt_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_crt_color_rect.visible = 启用CRT
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float scanline_strength : hint_range(0.0, 1.0) = 0.3;
	uniform float scanline_density : hint_range(0.1, 5.0) = 2.0;
	uniform float curvature : hint_range(0.0, 1.0) = 0.3;
	uniform float chroma_shift : hint_range(0.0, 0.1) = 0.02;
	void fragment() {
		vec2 uv = UV;
		vec2 centered = uv - 0.5;
		float dist = length(centered);
		float max_dist = 0.7071;
		float factor = 1.0 + curvature * dist / max_dist;
		vec2 distorted = centered / factor + 0.5;
		distorted = clamp(distorted, 0.0, 1.0);
		float scanline = sin(distorted.y * 3.14159 * scanline_density * 100.0);
		scanline = abs(scanline);
		scanline = 1.0 - scanline * scanline_strength;
		vec4 color = texture(SCREEN_TEXTURE, distorted);
		float r = texture(SCREEN_TEXTURE, distorted + vec2(chroma_shift, 0.0)).r;
		float b = texture(SCREEN_TEXTURE, distorted - vec2(chroma_shift, 0.0)).b;
		color.r = mix(color.r, r, 0.5);
		color.b = mix(color.b, b, 0.5);
		COLOR = vec4(color.rgb * scanline, color.a);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("scanline_strength", 扫描线强度)
	material.set_shader_parameter("scanline_density", 扫描线密度)
	material.set_shader_parameter("curvature", 屏幕弯曲)
	material.set_shader_parameter("chroma_shift", 色彩偏移强度)
	_crt_color_rect.material = material
	_crt_canvas_layer.add_child(_crt_color_rect)

func _setup_color_grading():
	_color_grading_canvas_layer = CanvasLayer.new()
	_color_grading_canvas_layer.layer = -1
	add_child(_color_grading_canvas_layer)
	_color_grading_color_rect = ColorRect.new()
	_color_grading_color_rect.anchor_left = 0.0
	_color_grading_color_rect.anchor_top = 0.0
	_color_grading_color_rect.anchor_right = 1.0
	_color_grading_color_rect.anchor_bottom = 1.0
	_color_grading_color_rect.offset_left = 0
	_color_grading_color_rect.offset_top = 0
	_color_grading_color_rect.offset_right = 0
	_color_grading_color_rect.offset_bottom = 0
	_color_grading_color_rect.color = Color(1, 1, 1, 1)
	_color_grading_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_color_grading_color_rect.visible = 启用色调映射
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float brightness : hint_range(-1.0, 1.0) = 0.0;
	uniform float contrast : hint_range(0.0, 3.0) = 1.0;
	uniform float saturation : hint_range(0.0, 2.0) = 1.0;
	uniform float hue_shift : hint_range(0.0, 360.0) = 0.0;
	vec3 rgb2hsv(vec3 c) {
		vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
		vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
		vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
		float d = q.x - min(q.w, q.y);
		float e = 1.0e-10;
		return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	}
	vec3 hsv2rgb(vec3 c) {
		vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
		vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
		return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
	}
	void fragment() {
		vec4 bg = texture(SCREEN_TEXTURE, UV);
		vec3 color = bg.rgb;
		color += brightness;
		color = (color - 0.5) * contrast + 0.5;
		vec3 hsv = rgb2hsv(color);
		hsv.y *= saturation;
		hsv.x = mod(hsv.x + hue_shift / 360.0, 1.0);
		color = hsv2rgb(hsv);
		COLOR = vec4(clamp(color, 0.0, 1.0), bg.a);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("brightness", 亮度)
	material.set_shader_parameter("contrast", 对比度)
	material.set_shader_parameter("saturation", 饱和度)
	material.set_shader_parameter("hue_shift", 色相偏移)
	_color_grading_color_rect.material = material
	_color_grading_canvas_layer.add_child(_color_grading_color_rect)

func _setup_sharpen():
	_sharpen_canvas_layer = CanvasLayer.new()
	_sharpen_canvas_layer.layer = -1
	add_child(_sharpen_canvas_layer)
	_sharpen_color_rect = ColorRect.new()
	_sharpen_color_rect.anchor_left = 0.0
	_sharpen_color_rect.anchor_top = 0.0
	_sharpen_color_rect.anchor_right = 1.0
	_sharpen_color_rect.anchor_bottom = 1.0
	_sharpen_color_rect.offset_left = 0
	_sharpen_color_rect.offset_top = 0
	_sharpen_color_rect.offset_right = 0
	_sharpen_color_rect.offset_bottom = 0
	_sharpen_color_rect.color = Color(1, 1, 1, 1)
	_sharpen_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_sharpen_color_rect.visible = 启用锐化
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity : hint_range(0.0, 2.0) = 0.3;
	void fragment() {
		vec2 uv = UV;
		vec2 texel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
		vec2 offset = texel_size;
		vec4 c00 = texture(SCREEN_TEXTURE, uv - offset);
		vec4 c01 = texture(SCREEN_TEXTURE, uv + vec2(0.0, -offset.y));
		vec4 c02 = texture(SCREEN_TEXTURE, uv + vec2(offset.x, -offset.y));
		vec4 c10 = texture(SCREEN_TEXTURE, uv + vec2(-offset.x, 0.0));
		vec4 c11 = texture(SCREEN_TEXTURE, uv);
		vec4 c12 = texture(SCREEN_TEXTURE, uv + vec2(offset.x, 0.0));
		vec4 c20 = texture(SCREEN_TEXTURE, uv + vec2(-offset.x, offset.y));
		vec4 c21 = texture(SCREEN_TEXTURE, uv + vec2(0.0, offset.y));
		vec4 c22 = texture(SCREEN_TEXTURE, uv + offset);
		vec4 sharpened = c11 * 9.0 - (c00 + c01 + c02 + c10 + c12 + c20 + c21 + c22);
		vec4 final = c11 + sharpened * intensity;
		COLOR = clamp(final, 0.0, 1.0);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 锐化强度)
	_sharpen_color_rect.material = material
	_sharpen_canvas_layer.add_child(_sharpen_color_rect)

func _setup_bloom():
	_bloom_canvas_layer = CanvasLayer.new()
	_bloom_canvas_layer.layer = -1
	add_child(_bloom_canvas_layer)
	_bloom_color_rect = ColorRect.new()
	_bloom_color_rect.anchor_left = 0.0
	_bloom_color_rect.anchor_top = 0.0
	_bloom_color_rect.anchor_right = 1.0
	_bloom_color_rect.anchor_bottom = 1.0
	_bloom_color_rect.offset_left = 0
	_bloom_color_rect.offset_top = 0
	_bloom_color_rect.offset_right = 0
	_bloom_color_rect.offset_bottom = 0
	_bloom_color_rect.color = Color(1, 1, 1, 1)
	_bloom_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bloom_color_rect.visible = 启用泛光
	var shader_code = """
	shader_type canvas_item;
	uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
	uniform float intensity : hint_range(0.0, 2.0) = 0.5;
	uniform float threshold : hint_range(0.0, 1.0) = 0.3;
	uniform float radius : hint_range(0.001, 0.1) = 0.02;
	uniform int samples : hint_range(4, 24) = 12;
	void fragment() {
		vec2 uv = UV;
		vec2 texel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
		vec4 color = texture(SCREEN_TEXTURE, uv);
		float brightness = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		vec4 bloom = vec4(0.0);
		float total_weight = 0.0;
		float sigma = radius * 20.0;
		for (int i = 0; i < samples; i++) {
			float angle = float(i) * 6.2832 / float(samples);
			float distance = radius * (0.5 + 0.5 * float(i) / float(samples));
			vec2 offset = vec2(cos(angle), sin(angle)) * distance * 100.0 * texel_size;
			vec2 sample_uv = uv + offset;
			sample_uv = clamp(sample_uv, 0.0, 1.0);
			vec4 sample_color = texture(SCREEN_TEXTURE, sample_uv);
			float sample_brightness = dot(sample_color.rgb, vec3(0.299, 0.587, 0.114));
			float bloom_mask = smoothstep(threshold, threshold + 0.1, sample_brightness);
			vec4 bloom_sample = sample_color * bloom_mask;
			float weight = exp(-(offset.x * offset.x + offset.y * offset.y) / (2.0 * sigma * sigma));
			bloom += bloom_sample * weight;
			total_weight += weight;
		}
		if (total_weight > 0.0) {
			bloom /= total_weight;
		}
		float bright_mask = smoothstep(threshold, threshold + 0.1, brightness);
		vec4 result = color + bloom * intensity * bright_mask;
		COLOR = clamp(result, 0.0, 1.0);
	}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("intensity", 泛光强度)
	material.set_shader_parameter("threshold", 泛光阈值)
	material.set_shader_parameter("radius", 泛光半径)
	material.set_shader_parameter("samples", 泛光采样数)
	_bloom_color_rect.material = material
	_bloom_canvas_layer.add_child(_bloom_color_rect)
