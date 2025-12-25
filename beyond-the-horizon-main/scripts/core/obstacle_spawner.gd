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

# === 私有变量 (Private Variables) ===
var _spawn_timer: Timer

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
	spawn_position.x = viewport_size.x + 100 # 稍微在屏幕外右侧
	var y_ratio: float = TRACK_Y_RATIOS.pick_random() # 随机选择一条轨道
	spawn_position.y = viewport_size.y * y_ratio

	new_obstacle.position = spawn_position

	# 2. 将新障碍物添加到生成器的父节点（即World场景）中
	get_parent().add_child(new_obstacle)

	# 3. 发出信号
	obstacle_spawned.emit(new_obstacle)
