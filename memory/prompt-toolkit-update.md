---
name: prompt-toolkit-update
description: 提炼出可迁移经验时主动提示更新 toolkit 并提交
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 134063b5-e7bf-4a08-bccf-c7c4abf14760
---

## 规则

每次在对话中提炼出可迁移的 Claude Code 使用经验（新技巧、新教训、新框架、新规则），在总结完毕后**主动提示用户**：

> 是否将本次经验更新到 toolkit 项目并提交至 GitHub？

不要等用户自己想起来——主动提醒。

**Why:** toolkit 是可迁移资产包，需要持续积累。经验刚提炼出来时更新成本最低（上下文新鲜），拖延容易遗忘。

**How to apply:** 在每次涉及经验总结的对话末尾，检查是否有新的可迁移内容——如果有且尚未写入 toolkit，主动提示。

**关联记忆：**
- [[project-separation]] — toolkit 独立于 management project，有自己的 git 仓库
- [[claude-md-four-laws]] — toolkit 中的 conventions.md 遵循相同原则
