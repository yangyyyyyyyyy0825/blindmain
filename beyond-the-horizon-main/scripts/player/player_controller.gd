extends Node2D

# ==============================================================
# 枚举定义
# ==============================================================
enum PlayerState {
	IDLE,       # 闲置状态
	WALK        # 行走状态
}

# ==============================================================
# 导出变量（可在编辑器中调整）
# ==============================================================
@export var move_speed: float = 200.0          # 移动速度
@export var current_track: int = 1             # 当前轨道索引 (0,1,2)
@export var horizontal_position: float = 150.0 # 初始水平位置
# 新增：导出动画资源路径（需在编辑器中指定）
@export var idle_animation: Animation = null   # 闲置动画资源
@export var walk_animation: Animation = null   # 行走动画资源

# ==============================================================
# 节点引用（适配新的节点结构）
# ==============================================================
@onready var sprite: Sprite2D = $Sprite                # 主精灵节点
@onready var animation_player: AnimationPlayer = $AnimationPlayer # 动画播放器
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D # 碰撞多边形

# ==============================================================
# 私有变量
# ==============================================================
var _current_state: PlayerState = PlayerState.IDLE # 当前玩家状态
var _viewport_size: Vector2                        # 视口尺寸
var _track_positions: Array[float] = [0.25, 0.5, 0.75] # 轨道垂直位置比例
var _is_moving: bool = false                       # 是否正在移动
var _move_direction: Vector2 = Vector2.ZERO        # 移动方向
var _collision_area: Area2D                        # 碰撞区域引用

# ==============================================================
# 生命周期函数
# ==============================================================
func _ready() -> void:
	"""节点初始化"""
	_setup_animations()
	_setup_viewport_listener()
	_setup_collision_area()
	_update_position()
	
	# 初始播放闲置动画
	_play_animation_for_state()

func _process(delta: float) -> void:
	"""每帧处理"""
	_handle_input()
	_update_movement(delta)

# ==============================================================
# 私有方法 - 初始化相关
# ==============================================================
func _setup_animations() -> void:
	"""初始化动画（适配AnimationPlayer）"""
	# 检查动画资源是否配置
	if not idle_animation or not walk_animation:
		print("警告：请在编辑器中为玩家节点配置idle和walk动画资源！")
		return
	
	# 将动画添加到AnimationPlayer
	animation_player.add_animation("idle", idle_animation)
	animation_player.add_animation("walk", walk_animation)
	
	# 配置动画属性
	animation_player.set_animation_loop("idle", false)
	animation_player.set_animation_loop("walk", true)
	animation_player.speed_scale = 1.0

func _setup_viewport_listener() -> void:
	"""监听视口尺寸变化"""
	var viewport = get_viewport()
	viewport.size_changed.connect(_on_viewport_resized)
	_viewport_size = viewport.get_visible_rect().size

func _setup_collision_area() -> void:
	"""创建碰撞区域（适配CollisionPolygon2D）"""
	# 创建Area2D节点
	_collision_area = Area2D.new()
	_collision_area.name = "CollisionArea"
	add_child(_collision_area)
	
	# 复用已有的CollisionPolygon2D
	if collision_polygon:
		# 将碰撞多边形移动到CollisionArea下
		collision_polygon.reparent(_collision_area)
	else:
		# 备用：如果没有CollisionPolygon2D则创建矩形碰撞
		var collision_shape = CollisionShape2D.new()
		collision_shape.name = "CollisionShape"
		_collision_area.add_child(collision_shape)
		
		var rectangle_shape = RectangleShape2D.new()
		rectangle_shape.size = Vector2(30, 30)
		collision_shape.shape = rectangle_shape
	
	# 配置碰撞层和掩码
	_collision_area.collision_layer = 1  # 玩家层
	_collision_area.collision_mask = 2   # 检测障碍物层
	
	# 绑定碰撞信号
	_collision_area.area_entered.connect(_on_area_entered)

# ==============================================================
# 私有方法 - 输入与移动
# ==============================================================
func _handle_input() -> void:
	"""处理玩家输入"""
	var state_changed = false
	var moving = false
	
	# 轨道切换（上下键）
	if Input.is_action_just_pressed("ui_up") and current_track > 0:
		current_track -= 1
		state_changed = true
		moving = true
	elif Input.is_action_just_pressed("ui_down") and current_track < 2:
		current_track += 1
		state_changed = true
		moving = true
	
	# 水平移动（左右键）
	if Input.is_action_pressed("ui_left"):
		_move_direction.x = -1
		moving = true
		state_changed = true
	elif Input.is_action_pressed("ui_right"):
		_move_direction.x = 1
		moving = true
		state_changed = true
	else:
		_move_direction.x = 0
	
	# 更新移动状态
	_is_moving = moving
	
	# 状态变化处理
	if state_changed:
		_update_position()
		if moving:
			_set_state(PlayerState.WALK)
		else:
			_set_state(PlayerState.IDLE)

func _update_movement(delta: float) -> void:
	"""更新移动逻辑"""
	if _is_moving and _move_direction.x != 0:
		# 更新水平位置
		horizontal_position += _move_direction.x * move_speed * delta
		
		# 限制在屏幕范围内
		var screen_width = _viewport_size.x
		horizontal_position = clamp(horizontal_position, 50, screen_width - 50)
		position.x = horizontal_position
		
		# 精灵翻转（左右移动）
		sprite.flip_h = _move_direction.x < 0
	elif not _is_moving and _current_state == PlayerState.WALK:
		# 停止移动时切换为闲置状态
		_set_state(PlayerState.IDLE)

func _update_position() -> void:
	"""更新玩家位置（轨道+水平）"""
	if _viewport_size.y > 0:
		position.y = _viewport_size.y * _track_positions[current_track]
		position.x = horizontal_position

# ==============================================================
# 私有方法 - 状态与动画
# ==============================================================
func _set_state(new_state: PlayerState) -> void:
	"""切换玩家状态"""
	if _current_state != new_state:
		_current_state = new_state
		_play_animation_for_state()

func _play_animation_for_state() -> void:
	"""根据状态播放对应动画（适配AnimationPlayer）"""
	match _current_state:
		PlayerState.IDLE:
			if animation_player.has_animation("idle"):
				animation_player.play("idle")
		PlayerState.WALK:
			if animation_player.has_animation("walk"):
				animation_player.play("walk")

# ==============================================================
# 回调方法
# ==============================================================
func _on_viewport_resized() -> void:
	"""视口尺寸变化回调"""
	_viewport_size = get_viewport().get_visible_rect().size
	_update_position()

func _on_area_entered(area: Area2D) -> void:
	"""碰撞检测回调"""
	if area.get_parent().name == "Obstacle":
		print("玩家与障碍物碰撞！")
		# 可扩展：游戏结束、扣血等逻辑

# ==============================================================
# 公共方法
# ==============================================================
func switch_to_track(track_index: int) -> void:
	"""切换到指定轨道"""
	if track_index >= 0 and track_index < 3:
		current_track = track_index
		_update_position()
		_set_state(PlayerState.WALK)

func get_current_track() -> int:
	"""获取当前轨道索引"""
	return current_track
