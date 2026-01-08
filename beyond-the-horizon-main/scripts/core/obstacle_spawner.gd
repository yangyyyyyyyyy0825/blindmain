# 文件路径: scripts/core/ObstacleSpawner.gd
extends Node

# === 信号 (Signals) ===
# 当生成一个新障碍物时发出此信号（可用于扩展）
signal obstacle_spawned(obstacle)

# === 导出变量 (Exported Variables) ===
# 在Inspector中可配置的障碍物场景
@export var obstacle_scene: PackedScene

# === 常量 (Constants) ===
# 障碍物生成的时间间隔（秒）
const SPAWN_INTERVAL: float = 2.0
# 三条轨道的相对位置（与Tracks.gd和PlayerController.gd保持一致）
const TRACK_Y_RATIOS: Array[float] = [0.25, 0.5, 0.75]
# 屏幕特效配置
const SHAKE_DURATION: float = 0.3  # 抖动持续时间(秒)
const SHAKE_INTENSITY: float = 5.0  # 抖动强度(像素)
const RED_TINT: Color = Color(1, 0.3, 0.3, 0.8)  # 红色 tint
const NORMAL_TINT: Color = Color(1, 1, 1, 1)  # 正常 tint

# === 私有变量 (Private Variables) ===
var _spawn_timer: Timer
var is_shaking: bool = false  # 抖动状态标记，避免重复触发

# === 引用 (References) ===
@onready var main_camera = get_tree().root.get_camera_2d()  # 获取主相机

# === 初始化 ===
func _ready() -> void:
	_setup_spawn_timer()

# === 私有方法 ===
func _setup_spawn_timer() -> void:
	# 创建一个新的计时器节点
	_spawn_timer = Timer.new()
	# 设置计时器的等待时间
	_spawn_timer.wait_time = SPAWN_INTERVAL
	# 设置为自动重启（即循环计时）
	_spawn_timer.autostart = true
	# 连接计时器的 "timeout" 信号到我们的生成函数
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	# 将计时器作为子节点添加到生成器，这样它会自动处理生命周期
	add_child(_spawn_timer)

func _on_spawn_timer_timeout() -> void:
	_spawn_obstacle()

func _spawn_obstacle() -> void:
	# 安全检查：确保已分配障碍物场景
	if obstacle_scene == null:
		push_warning("ObstacleSpawner: obstacle_scene is not assigned!")
		return

	# 从预设创建一个新的障碍物实例
	var new_obstacle := obstacle_scene.instantiate() as Node2D
	
	# 1. 设置生成位置：X在屏幕右侧外，Y在随机轨道上
	var spawn_position := Vector2.ZERO
	var viewport_size: Vector2 = get_viewport().size
	spawn_position.x = viewport_size.x + 100  # 稍微在屏幕外右侧
	var y_ratio: float = TRACK_Y_RATIOS.pick_random()  # 随机选择一条轨道
	spawn_position.y = viewport_size.y * y_ratio

	new_obstacle.position = spawn_position

	# 2. 配置碰撞检测（连接玩家碰撞信号）
	var obstacle_area = new_obstacle.get_node_or_null("Area2D")
	if obstacle_area:
		# 检测到玩家碰撞时触发屏幕特效
		obstacle_area.body_entered.connect(func(body):
			# 假设玩家节点在"player"组中
			if body.is_in_group("player"):
				_trigger_screen_effects()
		)
	else:
		push_warning("Obstacle instance missing Area2D node for collision detection!")

	# 3. 将新障碍物添加到生成器的父节点（即World场景）中
	get_parent().add_child(new_obstacle)

	# 4. 发出信号
	obstacle_spawned.emit(new_obstacle)

# === 屏幕特效相关方法 ===
# 触发屏幕抖动和变红效果
func _trigger_screen_effects() -> void:
	if is_shaking:
		return  # 避免重复触发
	
	is_shaking = true
	main_camera.modulate = RED_TINT  # 屏幕短暂变红
	await _shake_camera()  # 执行屏幕抖动
	main_camera.modulate = NORMAL_TINT  # 恢复正常显示
	is_shaking = false

# 相机抖动实现
func _shake_camera() -> void:
	var start_time = Time.get_ticks_msec() / 1000.0
	var original_position = main_camera.position  # 记录初始位置
	
	# 在抖动持续时间内不断偏移相机位置
	while Time.get_ticks_msec() / 1000.0 - start_time < SHAKE_DURATION:
		var offset = Vector2(
			randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY),
			randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY)
		)
		main_camera.position = original_position + offset
		await get_tree().process_frame  # 等待下一帧刷新
	
	main_camera.position = original_position  # 恢复相机初始位置
