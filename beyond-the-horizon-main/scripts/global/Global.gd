# Global.gd - 全局单例脚本，存储跨场景参数
extends Node

# 当前选中的难度（默认无）
var selected_difficulty: String = ""

# 难度规则配置（可灵活修改）
var difficulty_rules: Dictionary = {
	"speedrun": {
		"time_limit": 60.0,    # 时间限制60秒
		"error_limit": 5       # 失误数限制5次
	},
	"harmless": {
		"time_limit": INF,     # 无时间限制
		"error_limit": 1       # 失误数限制1次
	},
	"endless": {
		"time_limit": INF,     # 无时间限制
		"error_limit": INF     # 无失误数限制
	}
}
