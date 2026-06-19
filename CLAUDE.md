# Claude Code Toolkit — 可迁移资产维护

## 项目目的

本仓库是 Claude Code 使用经验的**可迁移资产包**。目标：在新电脑、新项目上一键部署已有的协作经验。

不是软件工程项目——它是元认知项目的**分发管道**。

## 核心约束

- **本目录内的约定必须与 conventions.md 自洽**——修改 memory 或 templates 时，检查是否违反了 conventions.md 中的原则
- **memory/ 一条记忆 = 一个独立知识点**——不合并无关主题，不拆碎同一主题
- **templates/ 保持通用**——模板中不出现 playout、management 等具体项目名
- **deploy.ps1 与 README 同步更新**——新增资产类型时两处都要改

## 更新流程

1. 在 management 项目中提炼出可迁移经验
2. 写入 toolkit 对应目录（memory / templates / conventions.md）
3. 更新 MEMORY.md 索引（如新增 memory 条目）
4. 更新 README.md（如新增资产目录）
5. 提交并推送

## 禁止

- 在本仓库中直接写工程代码
- 在模板中硬编码具体项目名
- 更新 deploy.ps1 后不更新 README 中的步骤说明
- 记忆条目超过 20 行（memory 文件自动注入上下文，越短越好）

## 当前阶段

- [x] 核心资产成型（7 条 memory + 3 类模板 + deploy 脚本）
- [x] P0/P1 同步修复（2026-06-19）
- [ ] 持续积累新经验
- [ ] 考虑 Unix/Mac 部署脚本（deploy.sh）
