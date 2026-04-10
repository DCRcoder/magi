# MCP Atlassian 工具介绍与使用

MCP Atlassian 是一个 Model Context Protocol (MCP) 服务器，可以集成 Atlassian 产品，包括 Confluence 和 Jira。通过此集成，可以管理 Confluence Cloud 和 Server/Data Center 部署。

**参考文档**：https://wiki.in.zhihu.com/pages/viewpage.action?pageId=620201453

## 工具功能

| 工具名 | 功能说明 |
|-------|---------|
| **confluence_search** | 使用 CQL（Confluence 查询语言）搜索 Confluence 内容 |
| **confluence_get_page** | 获取特定 Confluence 页面的内容 |
| **confluence_get_page_children** | 获取特定 Confluence 页面的子页面 |
| **confluence_get_page_ancestors** | 获取特定 Confluence 页面的父页面 |
| **confluence_get_comments** | 获取特定 Confluence 页面的评论 |
| **confluence_create_page** | 创建一个新的 Confluence 页面 |
| **confluence_update_page** | 更新现有的 Confluence 页面 |
| **confluence_delete_page** | 删除现有的 Confluence 页面 |
| **confluence_attach_content** | 将内容附加到 Confluence 页面 |

## 安装方法

### 使用 uv（推荐）

```bash
brew install uv
uvx mcp-atlassian
```

### 使用 pip

```bash
pip install mcp-atlassian
```

### 使用 Docker

```bash
git clone https://github.com/sooperset/mcp-atlassian.git
cd mcp-atlassian
docker build -t mcp/atlassian .
```

### 使用 Smithery

```bash
npx -y @smithery/cli install mcp-atlassian --client claude
```

> 注意：如果使用 uvx 安装失败，可以尝试添加参数：
> `uv tool install --with "pydantic<2.12" mcp-atlassian`

## 配置

### 获取 API 令牌

**对于 Confluence Cloud：**
1. 前往 https://id.atlassian.com/manage-profile/security/api-tokens
2. 点击 **创建 API 令牌** 并命名
3. 立即复制令牌

**对于 Confluence Server/Data Center：**
1. 转到你的个人资料（头像）→ **个人资料** → **个人访问令牌**
2. 点击 **创建令牌**，命名并设置过期时间
3. 立即复制令牌

### 命令行参数配置

**对于 Confluence Cloud：**

```bash
uvx mcp-atlassian \
  --confluence-url https://your-company.atlassian.net/wiki \
  --confluence-username your.email@company.com \
  --confluence-token your_api_token
```

**对于 Confluence Server/Data Center：**

```bash
uvx mcp-atlassian \
  --confluence-url https://confluence.your-company.com \
  --confluence-personal-token your_token
```

### 可选参数

| 参数 | 说明 |
|-----|------|
| `--transport` | 选择传输类型（`stdio` [默认] 或 `sse`）|
| `--port` | SSE 传输的端口号（默认值：8000）|
| `--[no-]confluence-ssl-verify` | 切换 Confluence Server/DC 的 SSL 验证 |
| `--confluence-spaces-filter` | 过滤 Confluence 搜索结果的空格键的逗号分隔列表 |
| `--verbose` / `-v` / `-vv` | 增加日志记录详细程度 |

## Cursor 安装

1. 打开 Cursor Settings
2. 导航到 **Features** > **MCP Servers**（或直接到 **MCP**）
3. 点击 **+ Add new global MCP server**
4. 这将创建或编辑 `~/.cursor/mcp.json` 文件

**JSON 配置示例：**

```json
{
  "mcpServers": {
    "mcp-atlassian": {
      "command": "uvx",
      "args": [
        "mcp-atlassian",
        "--confluence-url=https://your-company.atlassian.net/wiki",
        "--confluence-personal-token=<token>=your_api_token"
      ]
    }
  }
}
```

## Claude Code 安装

编辑 Claude 的配置文件 `~/.claude/settings.json`（或项目级 `.claude/mcp.json`）

**JSON 配置示例：**

```json
{
  "mcpServers": {
    "mcp-atlassian": {
      "command": "uvx",
      "args": [
        "mcp-atlassian",
        "--confluence-url=https://your-company.atlassian.net/wiki",
        "--confluence-username=your.email@company.com",
        "--confluence-token=your_api_token"
      ]
    }
  }
}
```

## 使用场景

- **搜索 Confluence 内容**：使用 `confluence_search` 工具通过 CQL 查询来查找特定的页面或信息
- **获取页面内容**：使用 `confluence_get_page` 工具来检索特定页面的内容
- **创建新页面**：使用 `confluence_create_page` 工具来创建新的 Confluence 页面
- **更新现有页面**：使用 `confluence_update_page` 工具来修改现有页面的内容
- **管理页面结构**：使用 `confluence_get_page_children` 和 `confluence_get_page_ancestors` 工具来浏览和管理页面层次结构

## 知乎内部配置

对于知乎内部 Confluence（wiki.in.zhihu.com），配置命令示例：

```bash
uvx mcp-atlassian --confluence-url=https://wiki.in.zhihu.com --confluence-personal-token=<your_personal_token>
```

在 Cursor 或 Claude Code 中的配置只需替换对应的 URL 和令牌即可。
