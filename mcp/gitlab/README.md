# GitLab MCP Server

GitLab MCP Server (@zereight/mcp-gitlab) 是一个全面的 GitLab MCP 服务器，支持通过 stdio、SSE 和 Streamable HTTP 与 AI 客户端交互。支持 PAT、OAuth、只读模式和远程授权，适用于 VS Code、Claude、Cursor、Copilot 等 MCP 客户端。

**GitHub**：https://github.com/zereight/gitlab-mcp

## 认证方式

| 方式 | 说明 |
|-----|------|
| **PAT** | 个人访问令牌，最简单的设置方式(推荐) |
| **OAuth2 - 本地浏览器** | 通过 GITLAB_USE_OAUTH 启用，更好的安全性 |
| **OAuth2 - MCP 代理** | 适用于 Claude.ai 等远程 MCP 客户端 |
| **远程授权** | 支持多用户部署，每个调用者提供自己的令牌 |

## 安装方式

### 使用 npx

```bash
npx -y @zereight/mcp-gitlab
```
## 环境变量

| 变量 | 说明 |
|-----|------|
| `GITLAB_PERSONAL_ACCESS_TOKEN` | GitLab 个人访问令牌 |
| `GITLAB_USE_OAUTH` | 设置为 "true" 启用 OAuth2 认证 |
| `GITLAB_OAUTH_CLIENT_ID` | OAuth 应用程序的客户端 ID |
| `GITLAB_OAUTH_CLIENT_SECRET` | OAuth 应用程序的客户端密钥 |
| `GITLAB_API_URL` | GitLab API 基础 URL（默认 https://gitlab.com/api/v4）|
| `GITLAB_PROJECT_ID` | 指定默认项目 |
| `GITLAB_READ_ONLY_MODE` | 设置为 "true" 启用只读模式 |
| `USE_GITLAB_WIKI` | 设置为 "true" 启用 Wiki API |
| `USE_MILESTONE` | 设置为 "true" 启用里程碑 API |
| `USE_PIPELINE` | 设置为 "true" 启用管道 API |

## Cursor 安装

1. 打开 Cursor Settings → Features → MCP Servers（或直接到 MCP）
2. 点击 **+ Add new global MCP server**
3. 这将创建或编辑 `~/.cursor/mcp.json` 文件

**PAT 配置示例：**

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "your_gitlab_token",
        "GITLAB_API_URL": "https://gitlab.com/api/v4"
      }
    }
  }
}
```

## Claude Code 安装

编辑 `~/.claude/settings.json`（或项目级 `.claude/mcp.json`）

**PAT 配置示例：**

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@zereight/mcp-gitlab"],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "your_gitlab_token",
        "GITLAB_API_URL": "https://gitlab.com/api/v4"
      }
    }
  }
}
```

## CLI 参数支持

对于不支持环境变量的客户端，可以使用 CLI 参数：

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "npx",
      "args": [
        "-y",
        "@zereight/mcp-gitlab",
        "--token=YOUR_GITLAB_TOKEN",
        "--api-url=https://gitlab.com/api/v4"
      ]
    }
  }
}
```

可用 CLI 参数：`--token`、`--api-url`、`--read-only=true`、`--use-wiki=true`、`--use-milestone=true`、`--use-pipeline=true`

## 获取 GitLab Token

1. 登录 GitLab
2. 进入 Settings → Access Tokens
3. 创建个人访问令牌，勾选 `api` scope
4. 复制令牌并妥善保存
