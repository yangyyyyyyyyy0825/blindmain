extends Node2D

# === 常量 (Constants) ===
# 障碍物的移动速度（单位：像素/秒）
const MOVE_SPEED: float = 200.0
# 障碍物类型列表
const OBSTACLE_TYPES: Array[String] = ["bike", "car", "shop", "traffic-cone", "trash-can", "turd"]
# 新增：碰撞冷却时间（1秒内只触发1次）
const COLLISION_COOLDOWN: float = 1.0

# === 导出变量 ===
# 当前障碍物类型（在Inspector中可调试）
@export var obstacle_type: String = "bike"

# === 私有变量 (Private Variables) ===
# 用于在物理帧中平滑移动
var _velocity: Vector2 = Vector2.ZERO
# 障碍物精灵节点引用
var _obstacle_sprites: Dictionary = {}
# 碰撞区域引用
var _collision_area: Area2D
# GameSession引用（用于检测暂停状态，默认null）
var _game_session: Node = null
# 新增：冷却计时器
var _collision_cooldown_timer: float = 0.0

# === 初始化 ===
func _ready() -> void:
	# 初始化速度，方向向左（X轴负方向）
	_velocity = Vector2.LEFT * MOVE_SPEED
	# 随机选择障碍物类型（如果没有预先设置）
	if obstacle_type == "bike":
		_randomize_obstacle_type()
	# 设置障碍物显示
	_setup_obstacle_sprites()
	# 设置碰撞区域
	_setup_collision_area()
	# 延迟1帧获取GameSession（确保场景加载完成，避免null）
	call_deferred("_get_game_session")

# === 核心修复：安全获取GameSession ===
func _get_game_session() -> void:
	# 方案1：递归查找场景中所有节点（容错性最高）
	_game_session = get_tree().root.find_child("GameSession", true, false)
	# 方案2：如果GameSession是自动加载单例，用这个（二选一）
	# _game_session = get_node("/root/GameSession")
	
	# 修复：Godot 4.x 用 push_warning 替代 print_warning
	if not _game_session:
		push_warning("未找到GameSession节点，障碍物将不响应暂停！")

# === 物理处理（带暂停检测） ===
func _physics_process(delta: float) -> void:
	# 安全检查：GameSession存在且游戏暂停时，停止移动
	if _game_session and _game_session.game_paused:
		return
	# 根据速度和时间增量移动障碍物
	position += _velocity * delta
	# 检查是否移出屏幕，如果是则销毁
	_check_if_off_screen()
	# 新增：更新冷却计时器
	if _collision_cooldown_timer > 0:
		_collision_cooldown_timer -= delta

# === 私有方法 ===
# 随机选择障碍物类型
func _randomize_obstacle_type() -> void:
	obstacle_type = OBSTACLE_TYPES.pick_random()

# 设置障碍物精灵显示
func _setup_obstacle_sprites() -> void:
	# 收集所有障碍物精灵节点
	for child in get_children():
		if child is Sprite2D:
			_obstacle_sprites[child.name] = child
	
	# 隐藏所有精灵，只显示选中的类型
	for sprite_name in _obstacle_sprites:
		_obstacle_sprites[sprite_name].visible = (sprite_name == obstacle_type)
		# 设置统一的缩放
		_obstacle_sprites[sprite_name].scale = Vector2(0.2, 0.2)

# 检查是否移出屏幕
func _check_if_off_screen() -> void:
	var _viewport_size: Vector2 = get_viewport().size
	# 如果障碍物完全移出屏幕左侧，销毁它
	if position.x < -100:
		queue_free()

# 设置碰撞区域
func _setup_collision_area() -> void:
	# 创建碰撞区域
	_collision_area = Area2D.new()
	_collision_area.name = "CollisionArea"
	add_child(_collision_area)
	
	# 创建碰撞形状
	var collision_shape = CollisionShape2D.new()
	collision_shape.name = "CollisionShape"
	_collision_area.add_child(collision_shape)
	
	# 使用矩形碰撞形状
	var rectangle_shape = RectangleShape2D.new()
	rectangle_shape.size = Vector2(40, 40)  # 根据障碍物大小调整
	collision_shape.shape = rectangle_shape
	
	# 设置碰撞层和掩码
	_collision_area.collision_layer = 2  # 障碍物层
	_collision_area.collision_mask = 1   # 检测玩家层
	
	# 连接碰撞信号
	_collision_area.area_entered.connect(_on_area_entered)

# 碰撞检测回调（修复括号问题）
func _on_area_entered(area: Area2D) -> void:
	# 校验：玩家+GameSession有效+冷却结束
	if area.get_parent().name == "Player" and _game_session and _collision_cooldown_timer <= 0:
		print("障碍物与玩家碰撞！")
		# 调用GameSession的公共方法更新失误数（+1）
		_game_session.add_error_count(1)
		print("失误数已更新：", _game_session.error_count)  # 修复：用逗号拼接，避免括号问题
		# 启动冷却，避免重复触发
		_collision_cooldown_timer = COLLISION_COOLDOWN
	elif not _game_session:
		push_warning("未找到GameSession，无法更新失误数！")

# === 公共方法 ===
# 设置障碍物类型
func set_obstacle_type(type: String) -> void:
	if type in OBSTACLE_TYPES:
		obstacle_type = type
		_setup_obstacle_sprites()
