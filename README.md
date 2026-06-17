# Claude Code Toolkit

本 Toolkit 是在实践 Claude Code 过程中积累的**可迁移资产**。它的目标：让你在新电脑、新项目上**快速获得已有的协作经验**，不需要从零摸索。

---

## 目录

- [里面有什么](#里面有什么)
- [快速上手：在新电脑上部署](#快速上手在新电脑上部署)
- [工作原理：每个资产如何生效](#工作原理每个资产如何生效)
- [日常使用：增量更新经验](#日常使用增量更新经验)
- [自己写 CLAUDE.md 速成指南](#自己写-claudemd-速成指南)
- [FAQ](#faq)

---

## 里面有什么

```
toolkit/
├── README.md                          ← 你正在读的文件
├── deploy.ps1                          ← 一键部署脚本
├── conventions.md                      ← 核心约定速查手册（给你自己读的）
│
├── memory/                             ← 跨项目的持久记忆
│   ├── MEMORY.md                       #   记忆索引（自动加载）
│   ├── claude-md-four-laws.md          #   CLAUDE.md 编写四原则
│   ├── plan-mode-when.md               #   Plan Mode 决策标准
│   ├── project-separation.md           #   项目分离原则
│   ├── docs-as-testing.md              #   可执行文档即测试
│   ├── api-migration-prompt.md         #   API 迁移提示词五要素
│   └── session-discipline.md           #   Session 管理三大纪律
│
├── templates/                          ← 可复用的项目模板
│   ├── CLAUDE-md-template.md           #   通用 CLAUDE.md 模板
│   └── settings-template.json          #   推荐的项目级 settings
│
└── notes/                              ← 实战经验案例
    ├── playout-lessons.md              #   playout 重写的 9 条可迁移经验
    └── opencode-experience.md          #   OpenCode 开发经验 9 条教训
```

---

## 快速上手：在新电脑上部署

### 前提条件

- 已安装 Claude Code
- 已安装 Git
- 已安装 PowerShell 5.1+（Windows 10+ 自带，无需额外安装）
- 如果脚本报 `cannot be loaded because running scripts is disabled`，先以管理员身份运行：
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### 首次部署（3 步）

**第 1 步**：获取 toolkit

```powershell
# 方式 A：从 GitHub clone（推荐）
git clone https://github.com/YOUR_ACCOUNT/claude-code-toolkit.git D:\claude-code-toolkit

# 方式 B：从 U 盘/共享文件夹拷贝
cp -r E:\claude-code-toolkit D:\claude-code-toolkit
```

**第 2 步**：部署到目标项目

```powershell
cd D:\claude-code-toolkit

# 部署到新项目（项目目录会被自动创建）
.\deploy.ps1 -ProjectPath "D:\Projects\my-new-project"

# 或者只部署记忆（不创建项目模板）
.\deploy.ps1 -ProjectPath "D:\Projects\my-new-project" -MemoryOnly
```

**第 3 步**：根据项目修改 CLAUDE.md

部署完成后，打开 `D:\Projects\my-new-project\CLAUDE.md`，把其中的占位符替换成你项目的实际内容。详见「自己写 CLAUDE.md 速成指南」。

### deploy.ps1 做了什么

```
1. 在目标项目创建目录结构和 .claude/ 文件夹
2. 拷贝 CLAUDE-md-template.md → <项目>/CLAUDE.md
3. 拷贝 settings-template.json → <项目>/.claude/settings.local.json
4. 拷贝 memory/*.md → ~/.claude/projects/<项目名>/memory/
5. 合并 MEMORY.md 索引（不删除本机已有条目）
6. 在项目目录创建 .gitignore（如不存在）
```

**关键特性**：
- **模板文件**：每次部署都会用最新版覆盖（CLAUDE.md 模板、settings 模板）
- **记忆文件**：新文件直接添加，已有文件比较修改时间后决定是否覆盖
- **MEMORY.md**：toolkit 中的新条目追加到本机已有索引，不删除已有行

---

## 工作原理：每个资产如何生效

理解以下链路，是高效使用本 toolkit 的关键。

### 资产 A：CLAUDE.md 模板

```
你写 CLAUDE.md  →  放到项目根目录  →  Claude 每次启动自动读取
```

**生效方式**：**零配置**。只要文件存在于项目根目录，Claude 自动将其注入系统提示。

**写什么**：项目的特殊规则和约束，不写通用教程。详见《conventions.md》。

### 资产 B：Memory 条目

```
memory/*.md  →  deploy.ps1 拷贝到  →  ~/.claude/projects/<项目>/memory/
                                  →  Claude 启动时读取 MEMORY.md 索引
                                  →  相关记忆被召回到 <system-reminder>
```

**生效方式**：需要通过 `deploy.ps1` 或手动拷贝到正确位置。

**注意**：Memory 是**按项目 slug 隔离**的。`D:\Projects\my-app` 的记忆不会出现在 `D:\Projects\other-app` 中。

### 资产 C：conventions.md

```
你阅读 conventions.md  →  内化为操作习惯  →  在每个项目中做出更好的决策
```

**生效方式**：**不直接影响 Claude**。它影响的是你——帮助你判断何时该用 Plan Mode、CLAUDE.md 该怎么写。

### 资产 D：settings-template.json

```
settings.local.json  →  放到 <项目>/.claude/  →  Claude 启动时读取
                                              →  控制权限弹窗频率、钩子行为
```

**生效方式**：文件存在于 `.claude/` 目录即生效。

---

## 日常使用：增量更新经验

### 场景 1：你在 management 电脑上学到了新经验

```powershell
# 1. 把新经验写入 toolkit
cd D:\Project\management\toolkit
#   编辑 conventions.md，或新增 memory/new-pattern.md

# 2. 更新 MEMORY.md 索引
#   在 MEMORY.md 中添加一行：
#   - [新模式的标题](new-pattern.md) — 一句话描述

# 3. 提交并推送
git add .
git commit -m "新增：测试密度应优先覆盖领域逻辑层"
git push
```

### 场景 2：在另一台电脑上拉取最新经验

```powershell
cd D:\claude-code-toolkit
git pull

# 重新部署到已有项目（记忆部分会自动合并）
.\deploy.ps1 -ProjectPath "D:\Projects\my-existing-project"
```

### 场景 3：查看两台电脑间的差异

```powershell
# 在较新的电脑上
cd D:\claude-code-toolkit
git log --oneline -10    # 查看最近的更新

# 在较旧的电脑上
cd D:\claude-code-toolkit
git fetch
git diff HEAD..origin/main --stat   # 看看差了多少
git pull                            # 拉取
```

---

## 自己写 CLAUDE.md 速成指南

### 第一步：填充项目目的

```markdown
## 项目目的

<一句话说清楚这个项目是干什么的>

<3-5 个要点说明当前阶段的目标>
```

### 第二步：设定技术约束

```markdown
## 技术约束

- Python 版本：>= 3.10
- 核心依赖：<列出>
- <任何特殊的版本或平台限制>
```

### 第三步：写架构约定

这是 CLAUDE.md 中**最有价值**的部分。每条约定遵循格式：**做什么 + 不做什么**。

```markdown
## 架构约定

### 1. <约定名称>
- <做法>
- <反模式：明确禁止的做法>

### 2. ...
```

### 第四步：写使用约定

```markdown
## 使用约定

- 对话以中文为主
- 实现前先讨论方案并获确认
- 每个模块完成后立即编写对应测试
- 修改代码后运行 <测试命令> 确认无回归
```

### 第五步：维护当前阶段

```markdown
## 当前阶段

- [x] 已完成事项
- [ ] 正在进行的核心任务
- [ ] 下一步计划
```

**每次阶段性完成后更新这一节**，这样下次打开 Claude Code 时它能自动知道进度。

---

## FAQ

### Q1：我已有项目，不想覆盖 CLAUDE.md 怎么办？

`deploy.ps1` 在目标项目**不存在** CLAUDE.md 时才会创建。如果已存在，它会跳过并提示。你也可以手动只部署记忆：

```powershell
.\deploy.ps1 -ProjectPath "D:\my-project" -MemoryOnly
```

### Q2：记忆文件和我本机的记忆冲突了怎么办？

`deploy.ps1` 对已有记忆文件的处理：
- 如果本机版本**更新**（修改时间更晚）→ 跳过，保留本机版本
- 如果 toolkit 版本**更新** → 备份本机版本（加 `.bak` 后缀），用 toolkit 版本覆盖
- MEMORY.md 索引**只追加不删除**——本机已有的行不会丢失

### Q3：我能不能在多个项目之间共享记忆？

可以，但需要用同一个 project slug。deploy.ps1 默认用项目文件夹名作为 slug。如果你想多个项目共享记忆，用 `-Slug` 参数指定相同的名称：

```powershell
.\deploy.ps1 -ProjectPath "D:\Project-A" -Slug "my-shared-memory"
.\deploy.ps1 -ProjectPath "D:\Project-B" -Slug "my-shared-memory"
```

**不推荐**：CLAUDE.md 按项目隔离已经足够，跨项目共享记忆会让上下文膨胀。

### Q4：这个 toolkit 不包含工程代码，为什么用 git 管理？

纯文本是最适合 git 跟踪的内容。CONVENTIONS 的演进、Memory 条目的增删改、模板的迭代——git 让你能看到**每次经验更新的 diff**。一年后你回头看 `git log`，就是一份完整的学习历程。

### Q5：toolkit 更新后，已经在用的项目需要重新部署吗？

取决于你更新了什么：
- 只更新了 memory → 必须重新跑 `deploy.ps1`（记忆是拷贝到 `~/.claude/` 的）
- 只更新了 conventions.md → 不需要重新部署（那是给你读的）
- 更新了 CLAUDE.md 模板 → 手动把改动同步到已有项目的 CLAUDE.md，不需要重跑整个脚本

### Q6：运行 deploy.ps1 出现乱码或解析错误（UnexpectedToken）？

这是 UTF-8 编码问题。`deploy.ps1` 包含中文字符，**必须以 UTF-8 with BOM 编码保存**，否则 Windows PowerShell 5.1 会按系统 ANSI 编码（GBK）解析，导致中文字符被错误切割成多个 token。

**诊断方法**：用记事本打开 `deploy.ps1` → 另存为 → 看底部编码是否显示 "UTF-8 with BOM"。

**修复方法**：
```powershell
# 用 PowerShell 重新保存为 UTF-8 with BOM
$content = [System.IO.File]::ReadAllText("D:\claude-code-toolkit\deploy.ps1", [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("D:\claude-code-toolkit\deploy.ps1", $content, [System.Text.UTF8Encoding]::new($true))
```

> **注意**：部分编辑器（如 VS Code）默认保存为 UTF-8 without BOM。如果你编辑了 `deploy.ps1`，保存时请确认编码为 **UTF-8 with BOM**。

### Q7：deploy.ps1 日志显示「记忆条目 : 0 新增」但明明有记忆文件？

这是 PowerShell 5.1 的 `Get-ChildItem -Exclude` 已知 bug —— 当 Path 不以 `\*` 结尾时，`-Exclude` 参数不生效。已在当前版本的 `deploy.ps1` 中修复（`"$memorySourceDir\*"`）。如果你遇到此问题，请 `git pull` 获取最新脚本。
