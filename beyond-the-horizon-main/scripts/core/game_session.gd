extends Node

# === 1. 节点引用 ===
@onready var player: Node2D = $"../Player"          
@onready var hud: Control = $"../HUD"              

# === 结算场景预加载（延迟+容错） ===
var result_scene: PackedScene

# === 2. 游戏核心状态 ===
var game_started: bool = false    
var game_paused: bool = false     
var score: int = 0                
var error_count: int = 0          
var game_time: float = 0.0        
var _player_initial_pos: Vector2  

# === 难度配置 ===
var current_difficulty: String = ""          
var time_limit: float = INF                  # 时间限制（INF无限制）
var error_limit: int = INF                   # 失误数限制
# 新增：无尽模式失误失败阈值
const ENDLESS_ERROR_LIMIT = 10               

# === 3. 生命周期 - 初始化 ===
func _ready() -> void:
	# 延迟预加载结算场景
	call_deferred("_preload_result_scene")
	# 检查必要节点
	_check_required_nodes()
	# 加载难度配置
	_load_difficulty_config()
	# 初始化玩家位置
	if player:
		_player_initial_pos = player.position
	# 初始化游戏状态
	_setup_game()
	# 延迟开始游戏（避免立即触发game_over）
	call_deferred("_start_game_safe")
	# 绑定HUD信号
	_bind_hud_signals()
	print("GameSession初始化完成")

# 预加载结算场景（容错版）
func _preload_result_scene() -> void:
	result_scene = load("res://scenes/main/GameResult.tscn")
	if not result_scene:
		push_error("❌ 结算场景加载失败！路径：res://scenes/main/GameResult.tscn")
	else:
		print("✅ 结算场景预加载成功（GameSession）")

# 检查必要节点（容错提示）
func _check_required_nodes() -> void:
	if not player:
		push_error("❌ 缺失Player节点！请检查节点路径：../Player")
	else:
		print("✅ Player节点已找到")
	
	if not hud:
		push_error("❌ 缺失HUD节点！请检查节点路径：../HUD")
	else:
		print("✅ HUD节点已找到")

# 加载难度配置（核心修改：harmless改为无伤模式，失误限制1次）
func _load_difficulty_config() -> void:
	# 获取全局难度，默认无尽
	current_difficulty = Global.selected_difficulty if Global.selected_difficulty != "" else "endless"
	print("🔧 加载难度：", current_difficulty)
	
	# 难度规则定义（直接写死，避免依赖Global.difficulty_rules）
	match current_difficulty:
		"speedrun":  # 速通模式：60秒+5次失误
			time_limit = 60.0
			error_limit = 5
		"harmless":  # 无伤模式：无时间+1次失误
			time_limit = INF
			error_limit = 1
		"endless":   # 无尽模式：仅10次失误失败
			time_limit = INF
			error_limit = INF  # 覆盖为INF，用自定义阈值
	
	print("🔧 难度配置：时间限制=", time_limit, "秒 | 失误限制=", error_limit, "次")

# 初始化游戏UI
func _setup_game() -> void:
	if hud:
		_update_all_hud_status()
		_update_difficulty_ui()
	print("🎮 游戏UI初始化完成")

# 安全开始游戏（延迟执行，避免立即结束）
func _start_game_safe() -> void:
	game_started = true
	game_paused = false
	score = 0
	error_count = 0
	game_time = 0.0
	
	# 重置玩家位置
	if player and _player_initial_pos:
		player.position = _player_initial_pos
	# 延迟销毁障碍物（避免节点加载时机问题）
	call_deferred("_destroy_all_obstacles")
	
	# 更新UI
	_update_all_hud_status()
	_update_difficulty_ui()
	print("🎮 游戏已安全开始！")

# === 4. 帧更新 ===
func _process(delta: float) -> void:
	if game_started and not game_paused:
		# 游戏核心逻辑
		_update_game_logic(delta)
		# 更新游戏时间
		game_time += delta
		_update_game_time_ui()
		# 检测游戏结束条件
		_check_game_over_conditions()

# 检测游戏结束条件（保留：无尽模式10次失误，无伤模式1次失误）
func _check_game_over_conditions() -> void:
	# 1. 非无尽模式：保留原有规则（时间/失误数限制）
	if current_difficulty != "endless":
		if time_limit != INF and game_time >= time_limit:
			print("🛑 游戏结束：时间耗尽（已用%.1f秒，限制%.1f秒）" % [game_time, time_limit])
			game_over()
		if error_limit != INF and error_count >= error_limit:
			print("🛑 游戏结束：失误数超限（当前%d次，限制%d次）" % [error_count, error_limit])
			game_over()
	# 2. 无尽模式：仅10次失误触发失败结算
	else:
		if error_count >= ENDLESS_ERROR_LIMIT:
			print("🛑 无尽模式失败：失误数达到%d次" % ENDLESS_ERROR_LIMIT)
			game_over()

# 游戏核心逻辑（示例：每帧+1分）
func _update_game_logic(_delta: float) -> void:
	score += 1
	_update_all_hud_status()

# === 5. 障碍物清理 ===
func _destroy_all_obstacles() -> void:
	var all_nodes = []
	# 收集所有节点（跳过系统节点）
	for scene_node in get_tree().root.get_children():
		if scene_node.name in ["AudioManager", "Timer", "CanvasLayer", "Global"]:
			continue
		_collect_all_nodes(scene_node, all_nodes)
	
	# 销毁障碍物（仅Node2D类型）
	var destroyed_count = 0
	for node in all_nodes:
		if node is Node2D:
			if node.name.to_lower().find("obstacle") != -1 or node.name in ["trash-can", "traffic-cone", "bike", "car", "shop", "turd"]:
				node.queue_free()
				destroyed_count += 1
	print("🗑️ 已销毁", destroyed_count, "个障碍物")

# 递归收集所有节点
func _collect_all_nodes(node: Node, node_list: Array) -> void:
	node_list.append(node)
	for child in node.get_children():
		_collect_all_nodes(child, node_list)

# === 6. HUD信号绑定 ===
func _bind_hud_signals() -> void:
	if not hud:
		push_error("❌ 无法绑定HUD信号：HUD节点不存在")
		return
	
	# 退出按钮
	if hud.has_node("TopBar/ExitBtn"):
		hud.get_node("TopBar/ExitBtn").pressed.connect(_on_exit_btn_clicked)
		print("✅ ExitBtn信号绑定成功")
	else:
		push_error("❌ 找不到ExitBtn节点！")
	
	# 菜单弹窗
	if hud.has_node("MenuPopup"):
		hud.get_node("MenuPopup").id_pressed.connect(_on_menu_option_selected)
		print("✅ MenuPopup信号绑定成功")
	else:
		push_error("❌ 找不到MenuPopup节点！")

# === 7. HUD UI更新 ===
func _update_all_hud_status() -> void:
	if not hud:
		return
	
	# 失误数
	if hud.has_node("TopBar/StatusInfo/ErrorCount"):
		hud.get_node("TopBar/StatusInfo/ErrorCount").text = "失误数：%d" % error_count
	# 分数
	if hud.has_node("TopBar/StatusInfo/Score"):
		hud.get_node("TopBar/StatusInfo/Score").text = "分数：%d" % score
	# 当前场景
	if hud.has_node("TopBar/StatusInfo/GameSceneName"):
		hud.get_node("TopBar/StatusInfo/GameSceneName").text = "当前场景：main"

# 更新难度显示（核心修改：harmless显示为无伤模式）
func _update_difficulty_ui() -> void:
	if not hud:
		return
	
	if hud.has_node("TopBar/StatusInfo/Difficulty"):
		var difficulty_text = {
			"speedrun": "速通模式",
			"harmless": "无伤模式",  # 改为无伤模式
			"endless": "无尽模式"
		}.get(current_difficulty, "未知模式")
		hud.get_node("TopBar/StatusInfo/Difficulty").text = "模式：%s" % difficulty_text

# 更新游戏时间UI
func _update_game_time_ui() -> void:
	if not hud:
		return
	
	var total_seconds = int(game_time)
	var minutes = str(total_seconds / 60).pad_zeros(2)
	var seconds = str(total_seconds % 60).pad_zeros(2)
	
	if hud.has_node("TopBar/StatusInfo/GameTime"):
		# 速通模式显示剩余时间
		if time_limit != INF:
			var remaining_time = max(0, int(time_limit - game_time))
			var rem_min = str(remaining_time / 60).pad_zeros(2)
			var rem_sec = str(remaining_time % 60).pad_zeros(2)
			hud.get_node("TopBar/StatusInfo/GameTime").text = "剩余时间：%s:%s" % [rem_min, rem_sec]
		# 其他模式（含无尽、无伤）显示总时间
		else:
			hud.get_node("TopBar/StatusInfo/GameTime").text = "游戏时间：%s:%s" % [minutes, seconds]

# === 8. HUD菜单事件 ===
func _on_exit_btn_clicked():
	if hud:
		var btn_pos = hud.get_node("TopBar/ExitBtn").get_global_position()
		hud.get_node("MenuPopup").popup(Rect2(btn_pos + Vector2(0, 60), hud.get_node("MenuPopup").size))

func _on_menu_option_selected(option_id: int) -> void:
	match option_id:
		0: # 重新开始
			_restart_game()
		1: # 暂停/恢复
			_toggle_pause()
		2: # 退出游戏→结算
			_game_exit_to_result()

# === 9. 菜单功能 ===
func _restart_game() -> void:
	print("🔄 点击重新开始（游戏内）")
	_start_game_safe()

func _toggle_pause() -> void:
	game_paused = not game_paused
	if game_paused:
		print("⏸️ 游戏暂停")
	else:
		print("▶️ 游戏恢复")

# 退出游戏跳结算
func _game_exit_to_result() -> void:
	print("🚪 点击退出游戏→结算")
	game_over()

# === 10. 公共方法 ===
func add_score(points: int) -> void:
	score += points
	_update_all_hud_status()
	print("➕ 分数更新：", score)

func add_error_count(count: int = 1) -> void:
	error_count += count
	_update_all_hud_status()
	print("❌ 失误数更新：", error_count)

# === 11. 游戏结束（终极修复：仅保留锚点） ===
func game_over() -> void:
	game_started = false
	print("🏁 游戏结束！最终分数：", score, " | 难度：", current_difficulty, " | 总失误：", error_count)
	
	# 1. 检查结算场景是否加载
	if not result_scene:
		push_error("❌ 无法跳结算：结算场景未加载")
		return
	
	# 2. 打包结算数据
	var result_data = {
		"difficulty": current_difficulty,
		"time": game_time,
		"error_count": error_count,
		"score": score
	}
	
	# 3. 实例化结算场景
	var result_instance = result_scene.instantiate()
	if not result_instance:
		push_error("❌ 结算场景实例化失败！")
		return
	result_instance.set_result_data(result_data)
	
	# 4. 彻底清理旧场景
	var root_node = get_tree().root
	for child in root_node.get_children():
		if child.name != "Global":
			child.queue_free()
	print("🗑️ GameSession已清理旧场景")
	
	# 5. 切换到结算场景
	root_node.add_child(result_instance)
	get_tree().current_scene = result_instance
	# 仅设置锚点（无其他易报错属性）
	if result_instance is Control:
		result_instance.anchor_left = 0.0
		result_instance.anchor_top = 0.0
		result_instance.anchor_right = 1.0
		result_instance.anchor_bottom = 1.0
	print("✅ 已跳转到结算场景")
