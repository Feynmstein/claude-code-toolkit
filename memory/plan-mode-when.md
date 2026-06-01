---
name: plan-mode-when
description: Plan Mode 的正确使用场景和反模式
metadata:
  type: reference
---

## Plan Mode 使用决策

### 什么时候该用（四条标准，全中才进入）

1. 涉及**多个文件的新功能或新架构**（不只是一个函数/一个类）
2. 存在**多种合理的技术方案**（不同架构、不同依赖）
3. 需要**用户在写代码前审批方向**（架构决策不可逆）
4. 用户的**偏好会影响实现方向**

### 什么时候不该用

- 修 typo、加简单测试、改一行代码
- 需求已经非常明确、没有歧义的任务
- 纯探索性调研（先用 Explore agent 搜索，再决定要不要 Plan）

### playout 实战验证

playout 重写前进入 Plan Mode 产生了 398 行的架构计划 + 8 Phase 依赖图。最终按计划执行，208 测试通过。**时机正确**。

### Plan Mode 的局限性

- 无法覆盖实现细节（如循环导入的具体解决方式）
- 测试密度的分布容易失衡（core 层测试多、component 层测试少）
- 计划是静态的，中途需要偏离时需退出重规划

[[claude-md-four-laws]] [[project-separation]]
