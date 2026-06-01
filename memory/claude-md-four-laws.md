---
name: claude-md-four-laws
description: 编写 CLAUDE.md 的四条核心原则
metadata:
  type: reference
---

## CLAUDE.md 编写四原则

1. **写约束，不写教程** — Claude 不需要教它通用编程技能，需要的是**这个项目的特殊规则**。例如写"旋转用弧度制"比写"如何用 NumPy 做旋转矩阵"有效。

2. **写反模式，不写最佳实践** — 告诉 Claude **别做什么**。例如"不在原包目录中直接修改"、"不引入新的重量级依赖"。

3. **短小精干** — CLAUDE.md 每次会话都自动注入上下文。篇幅越长 = 每次对话的背景 token 消耗越大。控制在 80 行以内为宜。

4. **保持更新** — 阶段变了、架构调整了、发现新禁区了，立即更新 CLAUDE.md。过时的 CLAUDE.md 比没有更危险。

**验证方法**：重写 playout 后逐条对照，CLAUDE.md 中的 7 条核心约定在新代码中 100% 得到执行。

[[project-separation]] [[plan-mode-when]]
