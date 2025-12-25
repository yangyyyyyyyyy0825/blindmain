extends Node

# === 节点引用 ===
@onready var player: Node2D = $"../Player"
@onready var world: Node2D = $"../World"
@onready var hud: Control = $"../HUD"

# === 游戏状态 ===
var game_started: bool = false
var game_paused: bool = false
var score: int = 0

# === 生命周期 ===
func _ready() -> void:
	print("Game Session initialized")
	_setup_game()
	_start_game()

func _process(_delta: float) -> void:
	if game_started and not game_paused:
		_update_game(_delta)

# === 私有方法 ===
# 设置游戏
func _setup_game() -> void:
	# 确保所有必要节点都存在
	if not player:
		push_error("Player node not found!")
	if not world:
		push_error("World node not found!")
	if not hud:
		push_error("HUD node not found!")

# 开始游戏
func _start_game() -> void:
	print("Game started!")
	game_started = true
	game_paused = false
	score = 0

# 更新游戏逻辑
func _update_game(_delta: float) -> void:
	# 这里可以添加游戏逻辑，比如：
	# - 生成障碍物
	# - 更新分数
	# - 检查碰撞等
	pass

# === 公共方法 ===
# 暂停游戏
func pause_game() -> void:
	if game_started:
		game_paused = true
		print("Game paused")

# 恢复游戏
func resume_game() -> void:
	if game_started:
		game_paused = false
		print("Game resumed")

# 重新开始游戏
func restart_game() -> void:
	print("Restarting game...")
	_start_game()

# 游戏结束
func game_over() -> void:
	game_started = false
	print("Game Over! Final score: ", score)

# 增加分数
func add_score(points: int) -> void:
	score += points
	print("Score: ", score)
