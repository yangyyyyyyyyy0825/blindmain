extends Control

# ----------------------
# 难度选择按钮：跳转到 main.tscn 场景
# ----------------------
func _on_speedrun_btn_pressed():
	_goto_main_scene("speedrun")

func _on_harmless_btn_pressed():
	_goto_main_scene("harmless")

func _on_endless_btn_pressed():
	_goto_main_scene("endless")

# 跳转到 main.tscn 的核心逻辑（传递难度参数）
func _goto_main_scene(difficulty: String):
	# 1. 将选中的难度写入全局变量
	Global.selected_difficulty = difficulty
	print("选中难度：", difficulty)
	
	# 2. 销毁当前难度选择场景
	queue_free()
	
	# 3. 加载并切换到 main.tscn 场景
	var main_scene = load("res://scenes/main/main.tscn")
	if main_scene:
		get_tree().change_scene_to_packed(main_scene)
	else:
		push_error("无法加载main场景，请检查路径！")

# ----------------------
# 返回按钮：回到 root.tscn 的 MainMenu
# ----------------------
func _on_backroot_pressed():
	# 1. 销毁当前难度选择场景
	queue_free()
	
	# 2. 显示 root 下的 MainMenu
	if get_tree().root.has_node("MainMenu"):
		get_tree().root.get_node("MainMenu").visible = true
	else:
		# 兜底：切回 root.tscn 场景
		var root_scene = load("res://scenes/main/root.tscn")
		if root_scene:
			get_tree().change_scene_to_packed(root_scene)
		else:
			push_error("无法加载root场景，请检查路径！")
