# 文件路径: scripts/world/Obstacle.gd
extends Node2D

# === 常量 (Constants) ===
# 障碍物的移动速度（单位：像素/秒）
const MOVE_SPEED: float = 200.0
# 障碍物类型列表
const OBSTACLE_TYPES: Array[String] = ["bike", "car", "shop", "traffic-cone", "trash-can", "turd"]

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

# === 物理处理 ===
func _physics_process(delta: float) -> void:
	# 根据速度和时间增量移动障碍物
	position += _velocity * delta
	# 检查是否移出屏幕，如果是则销毁
	_check_if_off_screen()

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

# 碰撞检测回调
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		print("障碍物与玩家碰撞！")
		# 这里可以添加游戏逻辑，比如游戏结束、减少生命值等
		# 暂时只打印日志

# === 公共方法 ===
# 设置障碍物类型
func set_obstacle_type(type: String) -> void:
	if type in OBSTACLE_TYPES:
		obstacle_type = type
		_setup_obstacle_sprites()
