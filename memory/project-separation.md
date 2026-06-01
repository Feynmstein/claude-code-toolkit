---
name: project-separation
description: 工程项目与学习项目的分离原则
metadata:
  type: reference
---

## 项目分离原则

### 核心原则：一个 project = 一个目的 = 一份 CLAUDE.md

- **工程 project**：放代码、测试、工程相关的 CLAUDE.md
- **学习 project**：放笔记、经验总结、通用模板

### 为什么必须分离

1. CLAUDE.md 每次对话自动注入——两个目的混在一起会互相污染上下文
2. 上下文窗口是稀缺资源——不相关文件白白消耗 token
3. 知识需要独立空间——学习产出属于"元认知"，不应掺杂在工程文件里

### 实际操作

- 工程 project 中做代码工作
- 学习 project 中做经验总结和记忆管理
- 定期将工程 project 中的工作经验回流到学习 project 的记忆系统

### playout 实战验证

playout 重写在 `D:\Project\playout` 中完成（独立工程 project），经验总结在 `D:\Project\management` 中（学习 project）。验证可行。

[[claude-md-four-laws]] [[plan-mode-when]]
