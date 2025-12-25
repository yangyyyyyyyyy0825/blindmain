extends Node2D

# === 常量 ===
# 轨道线的颜色和宽度
const TRACK_COLOR: Color = Color.WHITE
const TRACK_WIDTH: float = 2.0

# === 导出变量 ===
# 轨道相对位置（动态3分窗口）
@export var track_y_ratios: Array[float] = [0.25, 0.5, 0.75]

# === 初始化 ===
func _ready() -> void:
	_setup_viewport_listener()
	_redraw_tracks()

# === 私有方法 ===
# 设置监听窗口大小变化
func _setup_viewport_listener() -> void:
	# 获取根视口 (Root Viewport)
	var root_viewport: Viewport = get_viewport()
	# 连接 size_changed 信号，当窗口大小改变时调用 _on_viewport_resized
	root_viewport.size_changed.connect(_on_viewport_resized)

# 当窗口大小改变时，重新绘制轨道
func _on_viewport_resized() -> void:
	_redraw_tracks()

# 执行重绘
func _redraw_tracks() -> void:
	queue_redraw() # 这是 Godot 4 的方法，等同于旧版的 update()

# === 绘制方法 ===
func _draw() -> void:
	# 获取当前视口的尺寸
	var viewport_size: Vector2 = get_viewport_rect().size
	var viewport_width: float = viewport_size.x
	var viewport_height: float = viewport_size.y

	# 遍历所有轨道相对位置，绘制线条
	for y_ratio in track_y_ratios:
		var y_position: float = viewport_height * y_ratio
		var start_point: Vector2 = Vector2(0, y_position)
		var end_point: Vector2 = Vector2(viewport_width, y_position)
		draw_line(start_point, end_point, TRACK_COLOR, TRACK_WIDTH)
