# 知乎内部 MCP 服务

知乎内部 MCP（Model Context Protocol）服务器，提供丰富的内部工具调用能力。

**官网**：https://mcp.in.zhihu.com/

## Token 获取方式

1. 访问 https://cloud.in.zhihu.com/
2. 点击左下角头像，鼠标放置在 "SHERMAN CLI下载"
3. 复制登录秘钥
4. 配置到 `mcp.json` 的 token 参数

## 可用 MCP 服务

| 服务名 | 功能说明 |
|-------|---------|
| **fs-dayu** | dayu_parse_url, dayu_route_metrics |
| **容器相关** | get_container_log |
| **fs-klara-model** | 模型服务相关工具 |
| **网关** | list_app_routes |
| **fs-data-mcp-server** | 数据搜索（metric、report、table）|
| **fs-niz** | niz_list_unit |
| **fs-gitlab** | GitLab 集成（MR 操作等）|
| **Faas** | 函数开发相关工具 |
| **构建系统** | 构建镜像和代理列表 |
| **性能分析** | Go profiling 工具 |
| **fs-firing-tool** | 告警相关工具 |
| **云管系统** | get_ip_info |
| **fs-sysops** | 服务器查询工具 |
| **fs-ad-ray** | 广告追踪工具 |
| **部署系统** | 应用和容器管理工具 |
| **sequential-thinking** | 思维链工具 |
| **otel** | 可观测性（日志、指标查询等）|
| **fs-one-mcp** | Epic 和任务管理工具 |
| **MCP 工具市场** | 探索和检查 MCP Server |

## 配置方法

### Cursor 安装

1. 打开 Cursor Settings → Features → MCP Server
2. 点击添加新的 MCP Server
3. 配置 JSON 格式：

```json
{
  "mcpServers": {
    "服务名": {
      "url": "https://mcp.in.zhihu.com/服务路径/sse",
      "headers": {
        "Authorization": "Bearer your-token"
      }
    }
  }
}
```

### Claude Code 安装

1. 编辑 `~/.claude/settings.json`（或项目级 `.claude/mcp.json`）
2. 添加 mcpServers 配置：

```json
{
  "mcpServers": {
    "服务名": {
      "url": "https://mcp.in.zhihu.com/服务路径/sse",
      "headers": {
        "Authorization": "Bearer your-token"
      }
    }
  }
}
```

3. 重启 Claude Code 使配置生效

## 通用配置示例

```json
{
  "mcpServers": {
    "fs-gitlab": {
      "url": "https://mcp.in.zhihu.com/fs-gitlab/sse",
      "headers": {
        "Authorization": "Bearer your-token"
      }
    },
    "fs-data": {
      "url": "https://mcp.in.zhihu.com/fs-data-mcp-server/sse",
      "headers": {
        "Authorization": "Bearer your-token"
      }
    },
    "otel": {
      "url": "https://mcp.in.zhihu.com/otel/sse",
      "headers": {
        "Authorization": "Bearer your-token"
      }
    }
  }
}
```
