extends Control

# 返回root主菜单（仅保留核心功能，无打印输出）
func _on_back_to_root_btn_pressed():
	# 销毁当前GameIntro场景
	queue_free()
	
	# 查找并显示MainMenu节点
	if get_tree().root.has_node("MainMenu"):
		get_tree().root.get_node("MainMenu").visible = true
	else:
		# 兜底：切回root场景文件（替换成你实际的root.tscn路径）
		var root_scene = load("res://scenes/main/root.tscn")
		if root_scene:
			get_tree().change_scene_to_packed(root_scene)
