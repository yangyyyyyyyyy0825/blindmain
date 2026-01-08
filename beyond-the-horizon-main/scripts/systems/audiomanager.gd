extends Node

# 音频资源路径配置（已匹配你的实际目录：sfc 而非 sfx，且移除了不存在的voice文件）
const BGM_MAIN = preload("res://assets/audio/bgm/main_bgm.mp3")
const BGM_GAME = preload("res://assets/audio/bgm/game_bgm.wav")
const SFX_CLICK = preload("res://assets/audio/sfc/click.mp3")
const SFX_SUCCESS = preload("res://assets/audio/sfc/success.wav")

# 音频实例（避免重复创建）
var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()

# 音量配置（支持分离调节）
var bgm_volume: float = 0.7  # 背景音乐音量
var sfx_volume: float = 0.8  # 音效音量

func _ready():
	# 将音频播放器添加到全局节点
	add_child(bgm_player)
	add_child(sfx_player)
	# 初始化音量（线性值转分贝，Godot的音量单位）
	bgm_player.volume_db = linear_to_db(bgm_volume)
	sfx_player.volume_db = linear_to_db(sfx_volume)

# 播放背景音乐
func play_bgm(bgm_type: String):
	match bgm_type:
		"main":
			bgm_player.stream = BGM_MAIN
		"game":
			bgm_player.stream = BGM_GAME
	bgm_player.loop = true  # 背景音乐默认循环
	bgm_player.play()

# 停止背景音乐
func stop_bgm():
	bgm_player.stop()

# 播放音效
func play_sfx(sfx_type: String):
	match sfx_type:
		"click":
			sfx_player.stream = SFX_CLICK
		"success":
			sfx_player.stream = SFX_SUCCESS
	sfx_player.loop = false
	sfx_player.play()

# 调整音量（0-1 线性值转分贝）
func set_volume(audio_type: String, volume: float):
	volume = clamp(volume, 0.0, 1.0)  # 限制音量范围0-1，防止超出合理值
	match audio_type:
		"bgm":
			bgm_volume = volume
			bgm_player.volume_db = linear_to_db(volume)
		"sfx":
			sfx_volume = volume
			sfx_player.volume_db = linear_to_db(volume)

# 辅助函数：线性音量（0-1）转分贝（Godot 音量单位）
func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0  # 完全静音
	return 20.0 * log(linear) / log(10.0)
