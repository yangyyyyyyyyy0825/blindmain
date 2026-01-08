extends Control

# 结算数据（由GameSession传递）
var result_data: Dictionary = {
	"difficulty": "endless",
	"time": 0.0,
	"error_count": 0,
	"score": 0
}

# 场景预加载（仅保留root场景）
var root_scene: PackedScene

func _ready() -> void:
	# 初始化结算数据显示
	_update_result_ui()
	# 延迟预加载场景
	call_deferred("_preload_scenes")
	# 绑定按钮信号
	_bind_buttons()
	print("结算场景初始化完成")

# 绑定按钮信号
func _bind_buttons() -> void:
	if has_node("BackMenuBtn"):
		$BackMenuBtn.pressed.connect(_on_back_menu_btn_pressed)
		print("✅ 返回首页按钮信号绑定成功")
	else:
		push_warning("⚠️ 找不到BackMenuBtn节点！")

# 预加载场景
func _preload_scenes() -> void:
	root_scene = load("res://scenes/main/root.tscn")
	if not root_scene:
		push_error("❌ root场景加载失败！路径：res://scenes/main/root.tscn")
	else:
		print("✅ root场景预加载成功")

# 更新结算界面显示
func _update_result_ui() -> void:
	var difficulty_name = {
		"speedrun": "速通模式",
		"harmless": "无伤模式",
		"endless": "无尽模式"
	}.get(result_data.difficulty, "未知模式")
	
	if has_node("DifficultyText"):
		$DifficultyText.text = "挑战难度：%s" % difficulty_name
	if has_node("TimeText"):
		var total_seconds = int(result_data.time)
		var minutes = str(total_seconds / 60).pad_zeros(2)
		var seconds = str(total_seconds % 60).pad_zeros(2)
		$TimeText.text = "游戏时长：%s:%s" % [minutes, seconds]
	if has_node("ErrorText"):
		$ErrorText.text = "失误次数：%d" % result_data.error_count
	if has_node("ScoreText"):
		$ScoreText.text = "最终分数：%d" % result_data.score

# 返回首页（改用Godot标准场景切换）
func _on_back_menu_btn_pressed() -> void:
	print("🔵 点击返回首页")
	if root_scene:
		# 直接切换到root场景（Godot标准方法，自动重置场景）
		get_tree().change_scene_to_packed(root_scene)
	else:
		push_error("❌ 无法返回首页：root场景未加载")

# 外部设置结算数据的接口
func set_result_data(data: Dictionary) -> void:
	result_data = data
	_update_result_ui()
	print("📊 结算数据已更新：", result_data)
