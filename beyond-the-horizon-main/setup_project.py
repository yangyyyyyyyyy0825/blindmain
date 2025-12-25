#!/usr/bin/env python3
"""
Beyond the Horizon - 项目快速设置脚本

这个脚本会自动创建项目所需的目录结构，并生成一些基础配置文件。
运行此脚本后，开发者可以立即开始按照开发指南进行开发。

使用方法:
    python setup_project.py
"""

import os
import json
from pathlib import Path

def create_directory_structure():
    """创建项目目录结构"""
    print("📁 创建项目目录结构...")
    
    directories = [
        # 资源目录
        'assets/fonts',
        'assets/icons',
        
        # 音频目录
        'audio/bgm',
        'audio/sfx/ambience',
        'audio/sfx/obstacles',
        'audio/sfx/ui',
        
        # 场景目录
        'scenes/main',
        'scenes/prefabs',
        'scenes/ui',
        
        # 脚本目录
        'scripts/core',
        'scripts/systems',
        'scripts/ui',
        'scripts/utils',
        
        # 资源配置目录
        'resources',
        
        # 导出目录
        'exports/windows',
        'exports/linux',
        'exports/mac'
    ]
    
    for directory in directories:
        Path(directory).mkdir(parents=True, exist_ok=True)
        print(f"  ✅ 创建目录: {directory}")

def create_scene_config():
    """创建场景配置文件"""
    print("\n📋 创建场景配置文件...")
    
    scenes_config = [
        {
            "name": "安静小区",
            "duration": 15,
            "base_speed": 100,
            "density": 0.6,
            "obstacles": ["bike", "trash"],
            "description": "清晨的小区街道，行人稀少"
        },
        {
            "name": "早市街道",
            "duration": 20,
            "base_speed": 150,
            "density": 0.8,
            "obstacles": ["bike", "cart", "stand"],
            "description": "热闹的早市，摊位林立"
        },
        {
            "name": "商业区",
            "duration": 15,
            "base_speed": 200,
            "density": 1.0,
            "obstacles": ["car", "bike", "cone"],
            "description": "繁忙的商业区，车流密集"
        },
        {
            "name": "学校门口",
            "duration": 10,
            "base_speed": 120,
            "density": 0.7,
            "obstacles": ["bike", "child"],
            "description": "放学时的校门口，孩子们嬉戏"
        }
    ]
    
    with open('resources/scenes_config.json', 'w', encoding='utf-8') as f:
        json.dump(scenes_config, f, ensure_ascii=False, indent=2)
    
    print("  ✅ 创建文件: resources/scenes_config.json")

def create_feedback_texts():
    """创建反馈文案配置"""
    print("\n📝 创建反馈文案配置...")
    
    feedback_config = {
        "smooth": [
            "他稳稳地走过了这条街，就像每天一样。",
            "一切都那么顺利，仿佛这条路走了千百遍。",
            "今天的天气很好，街道也格外友好。",
            "小林的心情不错，步伐也轻快了许多。"
        ],
        "hard": [
            "他在煎饼摊前绊了一下，但很快就站稳了。",
            "路上的车子有点多，但他还是小心地通过了。",
            "今天的挑战不小，好在都有惊无险。",
            "虽然有些波折，但最终还是安全到达了。"
        ],
        "failed": [
            "今天的路似乎特别难走，需要更多练习。",
            "也许明天会是更好的一天。",
            "遇到困难是正常的，重要的是不要放弃。",
            "每一次挫折都是成长的机会。"
        ],
        "statistics": {
            "total_blind_population": "中国约有1731万视障人士",
            "daily_challenges": "每一次出行都是一次挑战",
            "accessibility_importance": "无障碍设施对视障群体至关重要"
        },
        "action_calls": [
            "关注视障群体，共建无障碍社会",
            "了解视障人士的日常生活需求",
            "支持无障碍设施建设",
            "用理解和尊重，让城市更温暖"
        ]
    }
    
    with open('resources/feedback_config.json', 'w', encoding='utf-8') as f:
        json.dump(feedback_config, f, ensure_ascii=False, indent=2)
    
    print("  ✅ 创建文件: resources/feedback_config.json")

def create_gitignore():
    """创建 .gitignore 文件"""
    print("\n🚫 创建 .gitignore 文件...")
    
    gitignore_content = """# Godot specific files
.import/
export/
godot/

# Scene files (optional - uncomment if you want to ignore .tscn files)
# *.tscn

# Script files (optional - uncomment if you want to ignore .gd files)
# *.gd

# Resource files
*.res
*.tres

# Asset files
*.png.import
*.jpg.import
*.ogg.import
*.otf.import
*.ttf.import

# OS specific files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/

# Python files (for this setup script only)
__pycache__/
*.pyc

# Export builds
*.zip
*.exe
*.app
*.deb
*.rpm
"""
    
    with open('.gitignore', 'w', encoding='utf-8') as f:
        f.write(gitignore_content)
    
    print("  ✅ 创建文件: .gitignore")

def create_development_todos():
    """创建开发任务清单"""
    print("\n📋 创建开发任务清单...")
    
    todo_content = """# Beyond the Horizon - 开发任务清单

## 🎯 Day 1: 项目基础搭建
- [ ] 创建Main.tscn根场景
- [ ] 搭建World.tscn游戏世界
- [ ] 创建Player.tscn玩家角色
- [ ] 实现GameSession.gd基础框架
- [ ] 验收：能显示玩家和3条轨道

## 🎯 Day 2: 障碍物系统
- [ ] 创建Obstacle.tscn预制体
- [ ] 实现ObstacleSpawner.gd
- [ ] 添加障碍物移动逻辑
- [ ] 测试生成频率和移动速度
- [ ] 验收：障碍物从右向左移动

## 🎯 Day 3: 输入与反馈系统
- [ ] 实现InputHandler.gd
- [ ] 创建MistakeTracker.gd
- [ ] 设置A/S/D按键映射
- [ ] 添加失误视觉反馈
- [ ] 验收：能响应输入清除障碍

## 🎯 Day 4: 视觉效果
- [ ] 实现迷雾效果系统
- [ ] 创建ParticleClear.tscn
- [ ] 添加VisualEffects.gd
- [ ] 调整视觉参数平衡
- [ ] 验收：迷雾和粒子特效正常

## 🎯 Day 5: 音频系统
- [ ] 实现AudioManager.gd
- [ ] 下载和处理音频资源
- [ ] 集成音效触发点
- [ ] 测试音频播放效果
- [ ] 验收：所有音效正常播放

## 🎯 Day 6: 场景管理
- [ ] 实现SceneManager.gd
- [ ] 创建scenes_config.json
- [ ] 实现场景切换逻辑
- [ ] 测试场景切换流畅性
- [ ] 验收：场景正常切换

## 🎯 Day 7: UI完善
- [ ] 实现HUD.tscn界面
- [ ] 创建HUDController.gd
- [ ] 实现ChallengeSelect.tscn
- [ ] 测试UI实时更新
- [ ] 验收：UI功能完整

## 🎯 Day 8: 结局系统
- [ ] 实现VictoryEvaluator.gd
- [ ] 创建ResultPanel.tscn
- [ ] 设计结局UI布局
- [ ] 添加行动呼吁内容
- [ ] 验收：结局系统正常

## 🎯 Day 9: 测试与发布
- [ ] 性能分析与优化
- [ ] 完整功能测试
- [ ] 打包配置设置
- [ ] 最终代码审查
- [ ] 验收：可发布的完整版本

---

## 📊 进度统计
总任务: 45个  
已完成: 0个 (0%)  
进行中: 0个 (0%)  
剩余: 45个 (100%)

---

## 🔗 相关文档
- [详细开发指南](DEVELOPMENT_GUIDE.md)
- [资源下载清单](RESOURCE_CHECKLIST.md)
- [团队协作方案](TEAM_COLLABORATION.md)
"""
    
    with open('DEVELOPMENT_TODOS.md', 'w', encoding='utf-8') as f:
        f.write(todo_content)
    
    print("  ✅ 创建文件: DEVELOPMENT_TODOS.md")

def print_next_steps():
    """打印下一步操作指南"""
    print("\n" + "="*60)
    print("🎉 项目设置完成！")
    print("="*60)
    
    print("\n📋 下一步操作指南:")
    print("1. 📖 阅读开发文档:")
    print("   - README.md - 项目总览")
    print("   - DEVELOPMENT_GUIDE.md - 详细开发指南")
    print("   - RESOURCE_CHECKLIST.md - 资源下载清单")
    print("   - TEAM_COLLABORATION.md - 团队协作方案")
    
    print("\n2. 🎨 下载资源文件:")
    print("   - 按照 RESOURCE_CHECKLIST.md 下载图标、音效和字体")
    print("   - 将资源文件放置到对应目录")
    
    print("\n3. 🚀 开始开发:")
    print("   - 打开 Godot 4.5.1")
    print("   - 打开 project.godot 文件")
    print("   - 按照 DEVELOPMENT_GUIDE.md 的 Day 1 开始开发")
    
    print("\n4. 👥 团队协作:")
    print("   - 参考 TEAM_COLLABORATION.md 分工")
    print("   - 建立每日晨会/晚会机制")
    print("   - 使用 Git 进行版本控制")
    
    print("\n📞 需要帮助？")
    print("   - 查看 Godot 官方文档: https://docs.godotengine.org/")
    print("   - 查看 Godot 中文社区: https://godot.cn/")
    
    print("\n🌟 祝你们开发顺利！")
    print("   这个项目不仅有技术挑战，更有深刻的社会意义。")
    print("="*60)

def main():
    """主函数"""
    print("🚀 Beyond the Horizon - 项目快速设置")
    print("="*60)
    
    try:
        create_directory_structure()
        create_scene_config()
        create_feedback_texts()
        create_gitignore()
        create_development_todos()
        
        print_next_steps()
        
    except Exception as e:
        print(f"\n❌ 设置过程中出现错误: {e}")
        print("请检查文件权限和磁盘空间，然后重试。")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())
