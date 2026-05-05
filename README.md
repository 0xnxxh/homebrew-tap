# Sitoi's Homebrew Tap

[![GitHub](https://img.shields.io/badge/GitHub-Sitoi%2Fhomebrew--tap-blue?logo=github)](https://github.com/Sitoi/homebrew-tap)

自定义 Homebrew Cask 仓库，收录了官方 Homebrew 暂未收录的应用。

## 使用方法

首先添加本 tap：

```sh
brew tap Sitoi/tap
```

然后安装所需应用：

```sh
brew install --cask <cask-name>
```

## 应用列表

| 应用 | 描述 | 安装命令 |
| --- | --- | --- |
| [ClashBar](https://github.com/Sitoi/ClashBar) | 基于 Mihomo 的菜单栏代理客户端 | `brew install --cask clashbar` |

## ClashBar

<img src="https://raw.githubusercontent.com/Sitoi/ClashBar/main/.github/assets/preview.png" alt="ClashBar Preview" width="600" />

**ClashBar** 是一款基于 SwiftUI + AppKit 构建的 macOS 菜单栏代理客户端，底层使用 [Mihomo](https://github.com/MetaCubeX/mihomo) 内核。

### 安装

```sh
brew tap Sitoi/tap
brew install --cask clashbar
```

### 要求

- macOS Ventura (13.0) 及以上

### 卸载

```sh
brew uninstall --cask clashbar

# 彻底清除所有数据
brew uninstall --zap --cask clashbar
```

### 常见问题

如果安装后出现"已损坏，无法打开"的提示，请在终端执行：

```sh
xattr -cr /Applications/ClashBar.app
```

详见 [ClashBar 常见问题](https://github.com/Sitoi/ClashBar?tab=readme-ov-file#-%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)。

## License

MIT

