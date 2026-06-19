---
name: convention-drift
description: 文档约定必然漂移——ExpToolKit 实战证明，需要"文档合规自检"作为反制
metadata:
  type: feedback
---

# 约定漂移与自检反制

## 现象

ExpToolKit Phase 1–10 的文档产出逐渐偏离了 Phase 1 时制定的约定：

- Phase 1 严格遵守了 `phase-N-notes.md` 模式
- Phase 2–4 只有 report，没有 design doc 或 notes
- Phase 5+ design→report 模式成为新常态，notes 被放弃
- Phase 7 缺 report，Phase 9 缺 design

**每次偏差都很小**，没有人决定"从今天起我们不写 design doc 了"。但累积 10 个 Phase 后，文档债已经形成。

## 根因

约定的执行依赖人的记忆，而人的记忆随时间衰减。Phase 1 时约定是新鲜的，到 Phase 5 时，上次读约定文档已经是几周前的事。

## 反制：文档合规自检

在每个 Phase report 末尾强制加入 5 行 checklist：

```markdown
## 文档合规自检
- [ ] 设计文档已产出
- [ ] TASK.md 已更新
- [ ] CLAUDE.md "当前阶段" 已更新
- [ ] requirements.md 无过时
```

**为什么有效**：自检是 report 模板的一部分——AI 生成 report 时自动执行，不依赖人的记忆。

**Why:** 约定如果不内嵌到执行模板中，必然被稀释。模板化是约定落地的唯一可靠方式。

**How to apply:** 在 CLAUDE.md 中将文档产出要求写为模板而非建议——"report 必须包含文档合规自检节"而非"建议同步文档"。[[prompt-toolkit-update]]
