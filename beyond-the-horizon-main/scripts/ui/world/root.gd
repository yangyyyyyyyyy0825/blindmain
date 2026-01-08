extends Control

# 场景预加载（延迟加载+容错）
var main_scene: PackedScene
var difficulty_scene: PackedScene
var game_intro_scene: PackedScene

# 主菜单节点引用（匹配你的场景节点名）
@onready var main_menu: Control = $MainMenu
@onready var start_game_btn: Button = $MainMenu/StartGameBtn
@onready var difficulty_btn: Button = $MainMenu/DifficultyBtn
@onready var game_intro_btn: Button = $MainMenu/GameIntroBtn

func _ready() -> void:
	# 强制显示主菜单
	if main_menu:
		main_menu.visible = true
	else:
		push_warning("⚠️ 找不到MainMenu节点！")
	
	# 绑定按钮信号（核心修复：手动绑定信号）
	_bind_buttons()
	
	# 延迟预加载场景
	call_deferred("_preload_all_scenes")
	print("Root场景初始化完成")

# 绑定按钮信号（匹配你的按钮节点名）
func _bind_buttons() -> void:
	if start_game_btn:
		start_game_btn.pressed.connect(_on_start_game_btn_pressed)
		print("✅ StartGameBtn信号绑定成功")
	else:
		push_error("❌ 找不到StartGameBtn节点！")
	
	if difficulty_btn:
		difficulty_btn.pressed.connect(_on_difficulty_btn_pressed)
		print("✅ DifficultyBtn信号绑定成功")
	else:
		push_error("❌ 找不到DifficultyBtn节点！")
	
	if game_intro_btn:
		game_intro_btn.pressed.connect(_on_game_intro_btn_pressed)
		print("✅ GameIntroBtn信号绑定成功")
	else:
		push_error("❌ 找不到GameIntroBtn节点！")

# 预加载所有场景
func _preload_all_scenes() -> void:
	main_scene = load("res://scenes/main/main.tscn")
	if not main_scene:
		push_error("❌ main场景加载失败！路径：res://scenes/main/main.tscn")
	else:
		print("✅ main场景预加载成功")
	
	difficulty_scene = load("res://scenes/main/difficulty_select.tscn")
	if not difficulty_scene:
		push_error("❌ 难度选择场景加载失败！路径：res://scenes/main/difficulty_select.tscn")
	else:
		print("✅ 难度选择场景预加载成功")
	
	game_intro_scene = load("res://scenes/main/game_intro.tscn")
	if not game_intro_scene:
		push_error("❌ 游戏介绍场景加载失败！路径：res://scenes/main/game_intro.tscn")
	else:
		print("✅ 游戏介绍场景预加载成功")

# 通用场景加载函数
func _load_new_scene(scene_packed: PackedScene) -> void:
	if not scene_packed:
		push_error("❌ 场景加载失败：场景为空")
		return
	
	# 清理旧场景
	var root_node = get_tree().root
	for child in root_node.get_children():
		if child.name != "Global":
			child.queue_free()
	print("🗑️ 已清理所有旧场景")
	
	# 实例化新场景
	var new_instance = scene_packed.instantiate()
	if not new_instance:
		push_error("❌ 场景实例化失败！")
		return
	
	# 添加到根节点
	root_node.add_child(new_instance)
	get_tree().current_scene = new_instance
	print("✅ 已加载新场景：", scene_packed.resource_path.get_file())
	
	# 设置锚点全屏
	if new_instance is Control:
		new_instance.anchor_left = 0.0
		new_instance.anchor_top = 0.0
		new_instance.anchor_right = 1.0
		new_instance.anchor_bottom = 1.0

# 按钮点击事件（匹配函数名）
func _on_start_game_btn_pressed():
	print("🔵 点击开始游戏")
	Global.selected_difficulty = "endless"
	if main_scene:
		_load_new_scene(main_scene)
	else:
		push_error("❌ 无法开始游戏：main场景未加载")

func _on_difficulty_btn_pressed():
	print("🔵 点击难度选择")
	if difficulty_scene:
		_load_new_scene(difficulty_scene)
	else:
		push_error("❌ 无法打开难度选择：场景未加载")

func _on_game_intro_btn_pressed():
	print("🔵 点击游戏介绍")
	if game_intro_scene:
		_load_new_scene(game_intro_scene)
	else:
		push_error("❌ 无法打开游戏介绍：场景未加载")
