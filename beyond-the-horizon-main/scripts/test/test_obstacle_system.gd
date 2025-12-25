# 测试障碍物系统的脚本
extends Node

# 测试标志
var test_passed: bool = true

func _ready() -> void:
	print("开始测试障碍物系统...")
	_test_obstacle_generation()
	_test_collision_detection()
	_test_obstacle_cleanup()
	print("障碍物系统测试完成！")

# 测试障碍物生成
func _test_obstacle_generation() -> void:
	print("测试障碍物生成...")
	
	# 创建测试障碍物
	var obstacle_scene = load("res://scenes/prefabs/obstacle.tscn")
	if obstacle_scene == null:
		print("❌ 障碍物场景加载失败")
		test_passed = false
		return
	
	var obstacle = obstacle_scene.instantiate()
	if obstacle == null:
		print("❌ 障碍物实例化失败")
		test_passed = false
		return
	
	# 检查障碍物脚本
	if not obstacle.has_method("_randomize_obstacle_type"):
		print("❌ 障碍物缺少随机类型选择方法")
		test_passed = false
		return
	
	# 检查障碍物类型列表
	var obstacle_types = obstacle.get("OBSTACLE_TYPES")
	if obstacle_types == null or obstacle_types.size() != 6:
		print("❌ 障碍物类型列表不正确")
		test_passed = false
		return
	
	print("✅ 障碍物生成测试通过")
	obstacle.queue_free()

# 测试碰撞检测
func _test_collision_detection() -> void:
	print("测试碰撞检测...")
	
	# 创建测试玩家
	var player_scene = load("res://scenes/prefabs/player.tscn")
	if player_scene == null:
		print("❌ 玩家场景加载失败")
		test_passed = false
		return
	
	var player = player_scene.instantiate()
	if player == null:
		print("❌ 玩家实例化失败")
		test_passed = false
		return
	
	# 检查玩家碰撞区域
	var collision_area = player.get_node_or_null("CollisionArea")
	if collision_area == null:
		print("❌ 玩家缺少碰撞区域")
		test_passed = false
		return
	
	print("✅ 碰撞检测测试通过")
	player.queue_free()

# 测试障碍物清理
func _test_obstacle_cleanup() -> void:
	print("测试障碍物清理...")
	
	# 创建测试障碍物
	var obstacle_scene = load("res://scenes/prefabs/obstacle.tscn")
	var obstacle = obstacle_scene.instantiate()
	
	# 检查清理方法
	if not obstacle.has_method("_check_if_off_screen"):
		print("❌ 障碍物缺少屏幕外检查方法")
		test_passed = false
		return
	
	print("✅ 障碍物清理测试通过")
	obstacle.queue_free()

# 获取测试结果
func get_test_result() -> bool:
	return test_passed
