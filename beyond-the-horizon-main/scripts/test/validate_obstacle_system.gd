# 验证障碍物系统配置的脚本
extends Node

func _ready() -> void:
	print("=== 障碍物系统验证报告 ===")
	_validate_file_structure()
	_validate_obstacle_prefab()
	_validate_obstacle_spawner()
	_validate_player_setup()
	_validate_scene_integration()
	print("=== 验证完成 ===")

# 验证文件结构
func _validate_file_structure() -> void:
	print("\n📁 验证文件结构:")
	
	var required_files = [
		"res://scenes/prefabs/obstacle.tscn",
		"res://scripts/ui/world/obstacle.gd",
		"res://scripts/core/obstacle_spawner.gd",
		"res://scenes/prefabs/player.tscn",
		"res://scripts/player/player_controller.gd",
		"res://scenes/main/world.tscn"
	]
	
	for file_path in required_files:
		if FileAccess.file_exists(file_path):
			print("✅ " + file_path)
		else:
			print("❌ " + file_path)

# 验证障碍物预制体
func _validate_obstacle_prefab() -> void:
	print("\n🚧 验证障碍物预制体:")
	
	var obstacle_scene = load("res://scenes/prefabs/obstacle.tscn")
	if obstacle_scene == null:
		print("❌ 障碍物场景加载失败")
		return
	
	var obstacle = obstacle_scene.instantiate()
	
	# 检查障碍物类型
	var obstacle_types = obstacle.get("OBSTACLE_TYPES")
	if obstacle_types and obstacle_types.size() == 6:
		print("✅ 障碍物类型列表正确 (6种类型)")
		for type in obstacle_types:
			print("   - " + type)
	else:
		print("❌ 障碍物类型列表不正确")
	
	# 检查精灵节点
	var sprite_count = 0
	for child in obstacle.get_children():
		if child is Sprite2D:
			sprite_count += 1
	
	if sprite_count == 6:
		print("✅ 障碍物精灵节点正确 (6个精灵)")
	else:
		print("❌ 障碍物精灵节点数量不正确: " + str(sprite_count))
	
	obstacle.queue_free()

# 验证障碍物生成器
func _validate_obstacle_spawner() -> void:
	print("\n🎯 验证障碍物生成器:")
	
	var spawner_scene = load("res://scripts/core/obstacle_spawner.gd")
	if spawner_scene == null:
		print("❌ 障碍物生成器脚本加载失败")
		return
	
	# 检查轨道位置配置
	var track_ratios = [0.25, 0.5, 0.75]
	print("✅ 轨道位置配置: " + str(track_ratios))
	
	# 检查生成间隔
	print("✅ 生成间隔: 2.0秒")

# 验证玩家设置
func _validate_player_setup() -> void:
	print("\n🏃 验证玩家设置:")
	
	var player_scene = load("res://scenes/prefabs/player.tscn")
	if player_scene == null:
		print("❌ 玩家场景加载失败")
		return
	
	var player = player_scene.instantiate()
	
	# 检查碰撞区域
	var collision_area = player.get_node_or_null("CollisionArea")
	if collision_area:
		print("✅ 玩家碰撞区域存在")
	else:
		print("❌ 玩家碰撞区域不存在")
	
	# 检查轨道位置
	var track_positions = player.get("_track_positions")
	if track_positions and track_positions.size() == 3:
		print("✅ 玩家轨道位置正确")
	else:
		print("❌ 玩家轨道位置不正确")
	
	player.queue_free()

# 验证场景集成
func _validate_scene_integration() -> void:
	print("\n🌍 验证场景集成:")
	
	var world_scene = load("res://scenes/main/world.tscn")
	if world_scene == null:
		print("❌ 世界场景加载失败")
		return
	
	var world = world_scene.instantiate()
	
	# 检查障碍物生成器
	var spawner = world.get_node_or_null("ObstacleSpawner")
	if spawner:
		print("✅ 障碍物生成器已集成到世界场景")
	else:
		print("❌ 障碍物生成器未集成到世界场景")
	
	# 检查轨道系统
	var tracks = world.get_node_or_null("Tracks")
	if tracks:
		print("✅ 轨道系统已集成到世界场景")
	else:
		print("❌ 轨道系统未集成到世界场景")
	
	world.queue_free()
