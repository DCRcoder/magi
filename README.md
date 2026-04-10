# AI 团队工程实践

通过工程手段解决 AI 编程的不确定性问题，最大程度提升开发质量。

## 核心概念

| 概念 | 说明 |
|-----|------|
| **AGENTS.md** | 项目总览文档，放在项目根目录，供 AI 理解项目概况 https://github.com/agentsmd/agents.md |
| **Rules** | 可复用的规则集，存放在 `rules/` 目录，AI 编写代码时自动遵循 |
| **Skills** | 特定场景的工作流，如 `skills/spec-dev`、`skills/knowledge-doc` |

## 目录结构

```
explore-code/
├── AGENTS.md            # 项目总览文档（模板）
├── AGENTS_demo.md       # 项目总览文档（示例）
├── README.md           # 本文件
├── skills/             # Skills 目录
│   ├── spec-dev/       # 规范先行开发流程
│   └── knowledge-doc/   # 业务知识库管理
├── rules/              # Rules 目录（待补充）
└── tools/              # Tools 目录（待补充）
```

## Tools

| 工具 | 说明 | 地址 |
|-----|------|------|
| **openspec** | 规范管理工具，用于创建和管理 SPEC 规范文档 | https://github.com/Fission-AI/OpenSpec |
| **GitNexus** | 代码知识库工具，建立变量、函数之间的引用关系 | https://github.com/abhigyanpatwari/GitNexus |

## Skills

### spec-dev

规范优先的开发工作流。

**触发条件**：用户提到"实现 XXX"、"开始做 XXX"、"开发 XXX 功能"

**流程**：需求 → proposal.md → design.md → tasks.md → spec.md → 实现 → 更新业务文档

**关键原则**：
- 规范是代码的"宪法"，修改代码前先修改规范
- 实现完成后必须更新业务文档，形成闭环

### knowledge-doc

业务知识库管理。

**核心理念**：文档以代码为基础，真实反映代码实现逻辑。文档跟着代码走，代码变更后必须同步更新。

**目录结构**：
```
doc/
├── 业务文档.md              # 入口索引
├── 版本记录.md              # 变更历史
└── {模块}.md               # 领域文档
```

## Rules

待项目补充。

## AI 工具使用

### AGENTS.md

| 工具 | 使用方式 |
|-----|---------|
| Claude Code | 需要在 `CLAUDE.md` 通过 `@` 引用 `AGENTS.md`|
| Cursor | cursor 兼容 `AGENTS.md` 自动识别并预加载到上下文中 |

### Rules

| 工具 | 控制方式 |
|-----|---------|
| Claude Code | 通过 frontmatter 的 `paths` 字段限定范围 |
| Cursor | 通过 frontmatter 的 `globs` 字段限定范围 |

## 开发流程对比

| 维度 | 经典流程 | 规范先行流程 |
|-----|---------|-------------|
| 需求追溯 | 分散在各处文档 | openspec 统一管理 |
| 设计确认 | 口头或会议确认 | 文档化、可引用 |
| 开发约束 | 依赖人工Review | 规范即约束 |
| 问题回溯 | 难以追溯 | 规范注释记录 |
| 知识积累 | 散落或丢失 | 规范 + 业务文档沉淀 |

## MCP 服务

MCP（Model Context Protocol）服务集成，提供丰富的内部和外部工具调用能力。详见各子目录下的 README。

### 目录结构

```
mcp/
├── zhihu/    # 知乎内部 MCP 服务
├── wiki/     # MCP Atlassian（Confluence）工具
└── gitlab/  # GitLab MCP Server
```

### MCP 服务一览

| MCP 服务 | 说明 | 主要功能 |
|---------|------|---------|
| **知乎内部 MCP** | 知乎内部 MCP 服务器 | GitLab、容器管理、数据搜索、告警、任务管理、可观测性等 |
| **MCP Atlassian** | Confluence 文档管理 | 搜索页面、获取/创建/更新/删除页面、管理评论等 |
| **GitLab MCP** | GitLab 集成 | MR 操作、项目管理、CI/CD 流水线、里程碑等 |

### 知乎内部 MCP 服务

提供 19 个内部服务，详见 [mcp/zhihu/README.md](mcp/zhihu/README.md)

| 服务 | 功能 |
|-----|------|
| fs-gitlab | GitLab 集成（MR 操作等）|
| fs-data-mcp-server | 数据搜索（metric、report、table）|
| otel | 可观测性（日志、指标查询等）|
| 部署系统 | 应用和容器管理 |
| fs-firing-tool | 告警相关工具 |
| fs-one-mcp | Epic 和任务管理 |
| 容器相关 | get_container_log |
| ... | 更多服务见详细文档 |

### MCP Atlassian（Confluence）

Confluence 文档管理工具，详见 [mcp/wiki/README.md](mcp/wiki/README.md)

| 工具 | 功能 |
|-----|------|
| confluence_search | 使用 CQL 搜索 Confluence 内容 |
| confluence_get_page | 获取页面内容 |
| confluence_create_page | 创建新页面 |
| confluence_update_page | 更新页面 |
| confluence_delete_page | 删除页面 |
| confluence_get_page_children | 获取子页面 |
| confluence_get_comments | 获取评论 |

### GitLab MCP

GitLab 项目管理和 MR 操作，详见 [mcp/gitlab/README.md](mcp/gitlab/README.md)

支持 PAT、OAuth 认证方式，可进行 MR 操作、项目管理、CI/CD 流水线管理等。
