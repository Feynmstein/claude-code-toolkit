---
name: docs-as-testing
description: 可执行文档作为被动集成测试层——写文档发现的 Bug 单元测试永远找不到
metadata:
  type: reference
---

## 可执行文档 = 被动集成测试

### 核心发现

单元测试覆盖"你想到要测的"，可执行文档覆盖"用户真的会跑的"。**两者之间的缝隙是 Bug 藏身处**。

### playout 实战证据

273 个单元测试全绿，但写用户指南时验证代码示例发现了 3 个问题：

| 发现 | 根因 |
|------|------|
| `Logo` 加载 AttributeError | `poly.points` 只读 property + numpy `*=` 的交互，无测试覆盖 |
| Logo 资源路径 FileNotFoundError | `parents[2]` 指向 src/ 而非项目根，Logo 零测试覆盖 |
| IQASZ DXF 解析失败 | ezdxf 拒绝非标准层名，read_dxf 从未用真实 malformed 文件测试 |

### 落地做法

1. **CLAUDE.md 中要求**：文档中的每个代码示例必须可自动运行验证
2. **项目标配**：至少一个端到端集成测试（构造→导出→读回→验证）
3. **文档驱动开发**：写完新功能后立即写一个"5 分钟快速上手"示例，跑通它

[[claude-md-four-laws]] [[project-separation]]
