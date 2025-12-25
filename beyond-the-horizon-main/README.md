# Beyond the Horizon - 项目总览

## 🌟 项目简介

**Beyond the Horizon** 是一个关于视障人士导航体验的 Godot 4.5 游戏。通过模拟视障人士在街道上行走60秒的体验，提高公众对视障群体日常挑战的认识。

### 🎯 游戏概念
玩家扮演视障人士"小林"，在有限时间内穿越多个街道场景，通过听觉提示和简单操作避开障碍物，体验视障人士的日常生活挑战。

### 🎮 核心玩法
- **60秒挑战**: 在限定时间内穿越街道
- **三轨道操作**: 使用 A/S/D 键清除对应轨道的障碍物
- **听觉导航**: 依赖音效提示识别障碍物
- **迷雾视野**: 模拟视力受限的视觉体验
- **多场景切换**: 体验不同难度的街道环境

---

## 📋 文档导航

### 🚀 快速开始
- **[详细开发指南](DEVELOPMENT_GUIDE.md)** - 9天完整开发计划，每日任务详解
- **[资源下载清单](RESOURCE_CHECKLIST.md)** - 所有免费资源的下载链接和处理指南
- **[团队协作方案](TEAM_COLLABORATION.md)** - 2人分工协作详细方案

### 📖 项目文档
- **[人机交互选题](c:/Users/HONOR/Desktop/人机交互选题.md)** - 原始需求文档和技术设计

---

## 🏗️ 技术架构

### 🛠️ 开发环境
- **引擎**: Godot 4.5.1
- **语言**: GDScript
- **平台**: Windows/Mac/Linux (可导出)
- **许可证**: MIT

### 📁 项目结构
```
beyond-the-horizon/
├── assets/                 # 资源文件
│   ├── fonts/             # 字体 (思源黑体)
│   └── icons/             # 图标 (Game-Icons.net)
├── audio/                 # 音频文件
│   ├── bgm/              # 背景音乐
│   └── sfx/              # 音效
│       ├── ambience/     # 环境音
│       ├── obstacles/    # 障碍音效
│       └── ui/           # UI音效
├── resources/            # 配置资源
│   └── scenes_config.json # 场景配置
├── scenes/               # 场景文件
│   ├── main/            # 主要场景
│   ├── prefabs/         # 预制体
│   └── ui/              # UI场景
└── scripts/             # 脚本文件
    ├── core/            # 核心逻辑
    ├── systems/         # 系统模块
    ├── ui/              # UI脚本
    └── utils/           # 工具类
```

---

## 🎮 游戏流程

### 📋 交互逻辑
1. **启动游戏** → 显示挑战选择界面
2. **进入游戏** → 播放开场语音，显示迷雾场景
3. **游戏过程** → 障碍物生成，玩家响应操作
4. **结束游戏** → 显示评级和个性化反馈
5. **返回菜单** → 选择重新开始或退出

### 🎯 核心机制
- **障碍物系统**: 随机生成，类型多样
- **输入响应**: A/S/D三键操作
- **失误追踪**: 记录错误操作，影响最终评级
- **场景切换**: 动态难度调整
- **情感反馈**: 个性化结局文案

---

## 👥 开发团队

### 🎯 目标开发者
- 2位无Godot经验但有编程基础的开发者
- 支持分工协作，并行开发

### ⏰ 开发周期
- **总时长**: 9天
- **每日工作量**: 6-8小时
- **协作模式**: 并行开发 + 每日集成

### 🏆 预期成果
- 完整可发布的游戏
- 详细的技术文档
- 高效的协作经验

---

## 🎨 资源概览

### 🖼️ 图标资源
- **来源**: Game-Icons.net
- **类型**: 8种障碍物图标
- **格式**: 64x64 PNG
- **许可**: CC BY 3.0

### 🔊 音频资源
- **来源**: Kenney + Freesound
- **类型**: UI音效、环境音、障碍音
- **格式**: OGG (统一处理)
- **许可**: CC0 + CC BY 3.0

### 📝 字体资源
- **来源**: 思源黑体 (Adobe)
- **格式**: OTF
- **许可**: SIL OFL 1.1

---

## 🚀 快速上手

### 📦 环境准备
1. **安装 Godot 4.5.1**
   - 访问 [Godot官网](https://godotengine.org/)
   - 下载对应平台的安装包
   - 完成基础配置

2. **克隆项目**
   ```bash
   git clone <repository-url>
   cd beyond-the-horizon
   ```

3. **打开项目**
   - 启动 Godot 编辑器
   - 打开 `project.godot` 文件

### 📋 开发步骤
1. **准备资源** - 按照[资源清单](RESOURCE_CHECKLIST.md)下载所需资源
2. **分工协作** - 参考[协作方案](TEAM_COLLABORATION.md)进行任务分配
3. **按日开发** - 遵循[开发指南](DEVELOPMENT_GUIDE.md)的9天计划
4. **集成测试** - 每日进行代码集成和功能测试
5. **打包发布** - 最终导出为可执行文件

---

## 📊 开发进度

### 🎯 里程碑
| 日期 | 目标 | 负责人 |
|------|------|--------|
| Day 1 | 基础场景搭建 | 两人共同 |
| Day 3 | 核心玩法实现 | 开发者A |
| Day 5 | 完整游戏体验 | 两人共同 |
| Day 7 | UI系统完善 | 开发者B |
| Day 9 | 项目完成发布 | 两人共同 |

### 📈 每日检查点
- ✅ **晨会**: 任务计划确认
- ✅ **中午**: 进度同步检查  
- ✅ **晚间**: 代码集成测试
- ✅ **验收**: 每日目标达成

---

## 🎮 游戏特色

### 🌟 社会意义
- **提高认知**: 增进公众对视障群体的理解
- **情感共鸣**: 通过亲身体验建立同理心
- **行动呼吁**: 鼓励关注无障碍设施建设

### 🎯 技术亮点
- **多感官体验**: 视觉 + 听觉的双重反馈
- **动态难度**: 场景自适应难度调整
- **情感化设计**: 个性化反馈和文案
- **无障碍设计**: 考虑不同用户需求

### 🏆 创新点
- **迷雾机制**: 模拟视力受限的真实体验
- **音效导航**: 纯听觉信息处理挑战
- **场景叙事**: 通过环境变化讲述故事
- **数据驱动**: 基于真实统计的反馈系统

---

## 🔧 技术细节

### 🎮 核心系统
- **游戏会话管理** (`GameSession.gd`)
- **障碍物生成器** (`ObstacleSpawner.gd`)
- **输入处理系统** (`InputHandler.gd`)
- **场景管理器** (`SceneManager.gd`)
- **音频管理器** (`AudioManager.gd`)

### 🎨 视觉系统
- **迷雾效果** (Light2D + CanvasLayer)
- **粒子特效** (GPUParticles2D)
- **UI动画** (Tween + AnimationPlayer)
- **场景过渡** (自定义着色器)

### 🔊 音频系统
- **空间音频** (AudioStreamPlayer2D)
- **动态混音** (AudioBus)
- **音效池** (对象池模式)
- **环境音效** (循环播放)

---

## 📚 学习资源

### 🎓 Godot 学习
- [Godot官方文档](https://docs.godotengine.org/)
- [Godot中文教程](https://godot.cn/)
- [GDScript语法参考](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)

### 🎮 游戏开发
- [游戏设计模式](https://gameprogrammingpatterns.com/)
- [独立游戏开发指南](https://indiegamegirl.com/)
- [游戏用户体验设计](https://www.uxdesign.cc/)

### ♿ 无障碍设计
- [游戏无障碍指南](https://gameaccessibilityguidelines.com/)
- [无障碍设计原则](https://www.w3.org/WAI/WCAG21/quickref/)
- [视障用户体验](https://webaim.org/techniques/lowvision/)

---

## 🤝 贡献指南

### 📋 如何贡献
1. **Fork** 项目到个人仓库
2. **创建** 功能分支 (`git checkout -b feature/AmazingFeature`)
3. **提交** 更改 (`git commit -m 'Add some AmazingFeature'`)
4. **推送** 到分支 (`git push origin feature/AmazingFeature`)
5. **创建** Pull Request

### 📝 代码规范
- 遵循 GDScript 官方编码规范
- 添加适当的注释和文档
- 保持代码简洁和可读性
- 编写必要的测试用例

### 🎨 设计规范
- 保持视觉风格一致性
- 遵循无障碍设计原则
- 优化用户体验流程
- 考虑不同平台适配

---

## 📄 许可证

本项目采用 **MIT 许可证** - 查看 [LICENSE](LICENSE) 文件了解详情。

### 📦 资源许可
- **图标**: CC BY 3.0 (Game-Icons.net)
- **音效**: CC0 + CC BY 3.0 (Kenney + Freesound)
- **字体**: SIL OFL 1.1 (Source Han Sans)

---

## 📞 联系方式

### 💬 项目讨论
- **Issues**: [GitHub Issues](https://github.com/your-repo/beyond-the-horizon/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/beyond-the-horizon/discussions)

### 📧 邮件联系
- **项目维护者**: [your-email@example.com]
- **技术支持**: [support@example.com]

---

## 🙏 致谢

### 🎨 资源提供者
- **Game-Icons.net** - 提供免费图标资源
- **Kenney** - 提供优质游戏资源包
- **Freesound** - 提供音效资源
- **Adobe** - 提供思源黑体

### 👥 社区支持
- **Godot Engine** - 强大的开源游戏引擎
- **开发者社区** - 技术支持和经验分享
- **测试用户** - 宝贵的反馈和建议

---

## 🚀 开始你的旅程！

**Beyond the Horizon** 不仅仅是一个游戏项目，更是一次有意义的社会实践。通过这个项目，我们希望能够：

- 🌟 **提升技术能力**: 掌握 Godot 游戏开发技能
- 🤝 **锻炼协作能力**: 学习高效的团队协作
- ❤️ **传递社会价值**: 为视障群体发声
- 🎮 **创造优质体验**: 打造有意义的游戏作品

**准备好开始这段旅程了吗？**

👉 **查看 [开发指南](DEVELOPMENT_GUIDE.md) 开始第一步！**

---

**让我们一起用技术创造价值，用游戏传递温暖。** 🌈❤️
