extends Node2D

# === 动画状态枚举 ===
enum PlayerState {
	IDLE,
	WALK,
	RUN
}

# === 导出变量 ===
@export var move_speed: float = 200.0
@export var current_track: int = 1  # 当前所在轨道 (0, 1, 2)
@export var horizontal_position: float = 150.0  # 水平位置

# === 节点引用 ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var static_sprite: Sprite2D = $Sprite2D

# === 私有变量 ===
var _current_state: PlayerState = PlayerState.IDLE
var _viewport_size: Vector2
var _track_positions: Array[float] = [0.25, 0.5, 0.75]  # 与轨道脚本保持一致
var _is_moving: bool = false
var _move_direction: Vector2 = Vector2.ZERO
# 碰撞区域引用
var _collision_area: Area2D

# === 生命周期 ===
func _ready() -> void:
	_setup_animations()
	_setup_viewport_listener()
	_setup_collision_area()
	_update_position()
	# 默认隐藏动画精灵，显示静态精灵
	animated_sprite.visible = false

func _process(delta: float) -> void:
	_handle_input()
	_update_movement(delta)

# === 私有方法 ===
# 设置动画
func _setup_animations() -> void:
	# 创建动画精灵帧
	var sprite_frames = SpriteFrames.new()
	
	# 添加idle动画
	sprite_frames.add_animation("idle")
	sprite_frames.add_frame("idle", load("res://assets/icons/player/idle.svg"))
	sprite_frames.set_animation_speed("idle", 1.0)
	sprite_frames.set_animation_loop("idle", false)
	
	# 添加walk动画
	sprite_frames.add_animation("walk")
	sprite_frames.add_frame("walk", load("res://assets/icons/player/walk.svg"))
	sprite_frames.set_animation_speed("walk", 8.0)
	sprite_frames.set_animation_loop("walk", true)
	
	# 添加run动画
	sprite_frames.add_animation("run")
	sprite_frames.add_frame("run", load("res://assets/icons/player/run.svg"))
	sprite_frames.set_animation_speed("run", 12.0)
	sprite_frames.set_animation_loop("run", true)
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.play("idle")

# 设置视口监听
func _setup_viewport_listener() -> void:
	var viewport = get_viewport()
	viewport.size_changed.connect(_on_viewport_resized)
	_viewport_size = viewport.get_visible_rect().size

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
	rectangle_shape.size = Vector2(30, 30)  # 根据玩家大小调整
	collision_shape.shape = rectangle_shape
	
	# 设置碰撞层和掩码
	_collision_area.collision_layer = 1  # 玩家层
	_collision_area.collision_mask = 2   # 检测障碍物层
	
	# 连接碰撞信号
	_collision_area.area_entered.connect(_on_area_entered)

# 碰撞检测回调
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Obstacle":
		print("玩家与障碍物碰撞！")
		# 这里可以添加游戏逻辑，比如游戏结束、减少生命值等
		# 暂时只打印日志

# 处理输入
func _handle_input() -> void:
	var state_changed = false
	var moving = false
	
	# 处理垂直移动（轨道切换）
	if Input.is_action_just_pressed("ui_up") and current_track > 0:
		current_track -= 1
		state_changed = true
		moving = true
	elif Input.is_action_just_pressed("ui_down") and current_track < 2:
		current_track += 1
		state_changed = true
		moving = true
	
	# 处理水平移动
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
	
	_is_moving = moving
	
	if state_changed:
		_update_position()
		if moving:
			_set_state(PlayerState.WALK)
			# 显示动画精灵，隐藏静态精灵
			animated_sprite.visible = true
			static_sprite.visible = false
		else:
			_set_state(PlayerState.IDLE)
			# 隐藏动画精灵，显示静态精灵
			animated_sprite.visible = false
			static_sprite.visible = true

# 更新移动
func _update_movement(delta: float) -> void:
	if _is_moving and _move_direction.x != 0:
		# 更新水平位置
		horizontal_position += _move_direction.x * move_speed * delta
		
		# 限制在屏幕范围内
		var screen_width = _viewport_size.x
		horizontal_position = clamp(horizontal_position, 50, screen_width - 50)
		
		# 更新位置
		position.x = horizontal_position
		
		# 处理翻转
		if _move_direction.x < 0:
			# 向左移动，翻转精灵
			animated_sprite.flip_h = true
			static_sprite.flip_h = true
		elif _move_direction.x > 0:
			# 向右移动，不翻转
			animated_sprite.flip_h = false
			static_sprite.flip_h = false
	elif not _is_moving and _current_state == PlayerState.WALK:
		# 停止移动时返回idle状态
		_set_state(PlayerState.IDLE)
		animated_sprite.visible = false
		static_sprite.visible = true

# 更新位置
func _update_position() -> void:
	if _viewport_size.y > 0:
		var target_y = _viewport_size.y * _track_positions[current_track]
		position.y = target_y
		position.x = horizontal_position

# 设置状态
func _set_state(new_state: PlayerState) -> void:
	if _current_state != new_state:
		_current_state = new_state
		_play_animation_for_state()

# 播放对应状态的动画
func _play_animation_for_state() -> void:
	match _current_state:
		PlayerState.IDLE:
			animated_sprite.play("idle")
		PlayerState.WALK:
			animated_sprite.play("walk")
		PlayerState.RUN:
			animated_sprite.play("run")

# 视口大小改变回调
func _on_viewport_resized() -> void:
	_viewport_size = get_viewport().get_visible_rect().size
	_update_position()

# === 公共方法 ===
# 切换到指定轨道
func switch_to_track(track_index: int) -> void:
	if track_index >= 0 and track_index < 3:
		current_track = track_index
		_update_position()
		_set_state(PlayerState.WALK)

# 获取当前轨道
func get_current_track() -> int:
	return current_track
