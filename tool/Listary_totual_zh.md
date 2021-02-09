# Listary 官方文档中文版

**Listary 是 Windows 上的一款革命性的搜索和应用启动软件。**

翻译：**CNife**

在这里查看[英文文档](http://www.listary.com/docs)。



## 1. 上手指南

### 1.1 下载安装

在[这里](http://www.listary.com/download)下载最新版本的 Listary 。比起便捷版本，强烈建议使用安装版本，更新更加容易。

安装后，会进入快速上手的教程，建议 Listary 的新手跟着教程走一遍。在此之后，也可以通过右键系统托盘中的 Listary 图标进入教程。

![tutorial-tray-icon](http://www.listary.com/wp-content/uploads/tutorial-tray-icon.png)

### 1.2 即打即搜

点击观看 Youtube 视频：[即打即搜－Listary](https://youtu.be/9Yo-Asib2Sg)

在 **Windows 资源管理器**中，不需要按下任何快捷键，直接**输入关键词**就可以启动 Listary 搜索。

Listary 使用类似 Google 的关键词搜索方式，使用空格分开多个关键词。例如，如果你想搜索 `ListaryDemoVideo.mp4` ，可以输入 `listary demo`、`demo listary` 或者  `listary video` 等。更多搜索方式，参见 高级搜索表达式。![find-as-you-type-explorer](http://www.listary.com/wp-content/uploads/find-as-you-type-explorer-1.png)

### 1.3 启动应用

无论何时何地，都可以**连按两次 Ctrl 键**来启动 Listary ，搜索你的应用和文件。

当搜索词中**没有空格**的时候，Listary 会将应用程序列在前排；如果只搜索文件，只需键入**一个空格**即可。

![launch-apps3](http://www.listary.com/wp-content/uploads/launch-apps3.png)

### 1.4 Listary 的两种模式

你可能注意到了，Listary 有两种模式。当用即打即搜启动搜索时，Listary 出现在 *资源管理器的右下角*，这是 **文件管理器模式**；当用 `Ctrl X 2` 的快捷键启动时，Listary 出现在*屏幕的正中间*，这是**启动器模式**。

- **文件管理器模式**：这个模式只可用于搜索文件，Listary 搜索框出现在当前的文件管理器窗口中（如，Windows 资源管理器），搜索到的文件夹将在这个窗口中打开。启动应用、网络搜索等功能将被*禁用*。
- **启动器模式**：这个模式中，所有功能都会启用。Listary 搜索框出现在屏幕正中间，文件夹将在新的文件管理器窗口中打开。

### 1.5 基本快捷键

- `在文件管理器中直接输入`：启动 Listary 搜索；
- `连按两次 Ctrl 键`：在任何地方启动 Listary 搜索；
- `Esc`：隐藏 Listary 搜索框，或取消动作；
- `↓ 键` 或 `Ctrl + N`：选择下一项；
- `↑ 键` 或 `Ctrl + P`：选择上一项；
- `→ 键` 或 `Ctrl + O`：打开选中项的动作菜单。

### 1.6 网络搜索

输入 `gg php tutorial` ，即可使用 Google 搜索 `php tutorial` 。在 `Listary 设置`－`关键字`－`Web` 中查看支持的搜索引擎，也可添加你自己的网址。

该功能仅可在**启动器**模式中使用。

### 1.7 快速切换

点击观看 Youtube 视频 ：[快速切换 - Listary](https://youtu.be/9T9-OtRVeUw)

### 1.8 动作菜单

点击观看 Youtube 视频：[动作菜单－Listary](https://youtu.be/e_gzDH-7ZLA)

### 1.9 鼠标操作

Listary 主要是用来配合键盘操作的，但配合鼠标操作同样十分方便。**双击资源管理器或桌面上的空白区域** 即可弹出 Listary 快捷菜单。

![doc-double-click](http://www.listary.com/wp-content/uploads/doc-double-click.png)



## 2. 高级搜索表达式

### 2.1 指定上层文件夹名称

你可以让 Listary 只列出**上层文件夹名称**中包含特定关键词的结果，当搜索结果过多时，可使用该方法来快速缩小搜索范围。

这是 [Listary 专业版](http://www.listary.com/pro) 的功能。

#### 用法

在一个关键词后加上 `\` 符号，即表明该关键词是上层文件夹路径的一部分。这个表达式可出现在搜索词中的**任何地方**。

#### 例子

**在 `Windows` 文件夹中搜索 `notepad.exe`：**

- `win\note`
- `win\ note`
- `note win\`

**在 `My Documents` 文件夹中搜索 `Photo.jpg`：**

- `photo doc\`
- `photo doc\my\`
- `my\doc\photo`

**在 `D:\  ` 盘中搜索 `Photo.jpg`：**

- `d:\photo`
- `photo d:\`

### 2.2 搜索过滤

搜索过滤让你可以在指定的文件夹内按指定扩展名搜索文件或文件夹。

#### 用法

在过滤词后加上 `:` 即可使用搜索过滤，可用于搜索词的**任何地方**。可在 `Listary 选项`－`搜索`中添加自定义过滤词。

#### 默认搜索过滤词

- `folder`：文件夹
- `file`：文件
- `doc`：文档
- `pic`：图片
- `audio`：音频
- `video`：视频

#### 例子

搜索名称中带有 `game` 的文件夹：

- `folder:game`
- `game folder:`




## 3. 快捷键

### 3.1 启动 Listary 的快捷键

- `Ctrl X 2`：建议，所有 Windows 版本都可以使用
- `Win + F`：Windows 10（有冲突）
- `Win + G`：Windows 8
- `Win + S`：Windows 7 / XP

可在 `Listary 选项`－`快捷键` 中修改。

### 3.2 搜索结果快捷键

可使用下列快捷键定位搜索结果，在 `Listary 选项`－`快捷键` 中修改。

- `↓ 键` 或 `Ctrl + N`：选择下一项；
- `↑ 键` 或 `Ctrl + P`：选择上一项；
- `→ 键` 或 `Ctrl + O`：打开选中项的动作菜单。
- `Esc`：隐藏 Listary 搜索框，或取消动作；

### 3.3 智能命令快捷键

下列快捷键只可在以下两种情况下使用：

1. Listary 搜索框或快捷菜单已弹出。因为默认情况下，文件对话框正下方会出现 Listary 搜索框，所以可以直接在文件对话框中使用。
2. `Listary 选项`－`应用程序设置`中，当前程序在列表中且被选中。`Windows Explorer` 默认是选中的，所以可以在资源管理器中直接使用这些快捷键，不需启动 Listary。

- `Ctrl + G`：将文件对话框定位到当前打开的文件夹；
- `Ctrl + Shift + C`：复制选中文件的完整路径到剪贴板；
- `Ctrl + Shift + R`：在当前文件夹打开命令行窗口；
- `Ctrl + Shift + X`：显示 / 隐藏文件扩展名；
- `Ctrl + Shift + H`：显示 / 隐藏 隐藏文件；
- `Ctrl + Shift + O`：在文件管理器中打开文件对话框中选中的文件夹；
- `Ctrl + Shift + E`：新打开一个当前文件夹的窗口。

可在 `Listary 选项`－`菜单`－`智能命令`（下拉菜单）中修改上述快捷键。

### 3.4 动作快捷键

在 Listary 中**选中一个结果**后，可使用下列的快捷键：

- `Ctrl + Enter`：打开选中结果所在的文件夹；
- `Ctrl + Shift + C`：复制选中文件的完整路径到剪贴板；
- `Ctrl + C`：复制选中结果到剪贴板（保持文件格式）；
- `Alt + S`：打开选中结果的 <u>发送到</u> 菜单；



- `Alt + O`：打开选中结果的 <u>打开方式</u> 菜单。

可在 `Listary 选项`－`动作` 修改。



## 4. 在第三方文件管理器中使用 Listary

### 4.1 支持的文件管理器

Listary 支持多数流行的第三方文件管理器：

- Directory Opus
- Total Commander
- XYplorer
- xplorer2
- FreeCommander XE
- SpeedCommander
- One Commander

### 4.2 设置

打开 `Listary 选项`－`常规设置`－`默认文件管理器`，根据你的文件管理器修改设置。

最常用的设置：

路径：`C:\<你的文件管理器路径>.exe`

参数：`"%1"`

如果使用 Directory Opus 或 Total Commander，可在下拉菜单中直接选择预设。

涉及高级命令行参数，请参考所用文件管理器的文档。

![default-file-manager](http://www.listary.com/wp-content/uploads/default-file-manager.png)

### 4.3 第三方文件管理器中可用的 Listary 功能

大多数 Listary 的功能在支持的文件管理器中都可用：

- 搜索文件和文件夹。在第三方文件管理器中，可按 `Ctrl X 2` 快捷键启动 Listary 搜索。如果搜索结果是文件夹，Listary 会在当前文件管理器窗口中打开文件夹
- 快速切换
- 收藏和历史记录
- 智能命令
- 用鼠标中键弹出快捷菜单

即打即搜只在特定文件管理器中可用（如 Drectory Opus）。

### 4.4 修改 Listary 中某个文件管理器的设置

打开 `Listary 选项`－`应用程序设置`，在列表中找到该文件管理器，于右侧修改相关设置。



## 5. 备份和恢复 Listary 设置

当前，可以手动备份和恢复 Listary 设置。

所有 Listary 设置都存放在 `UserData` 文件夹，位于：

- Windows Vista / 7 / 8 / 10：`C:\Users\\AppData\Roaming\Listary\UserData`
- Windows XP：`C:\Documents and Settings\\Application Data\Listary\UserData`
- 便捷版本：`Listary.exe` 所在的文件夹

请在备份或恢复 Listary 设置前 **退出 Listary**。



## 6. 疑难排查

### 6.1 Listary 启动后闪退

请删除 `C:\Users\\AppData\Roaming\Listary\UserData\DiskSearch.db` ，并尝试重启 Listary。

### 6.2 使用键盘或触摸板时，Listary 意外启动搜索

打开 `Listary 选项`－`快捷键`，取消 <u>按下 Ctrl 两次，以显示 / 隐藏 Listary</u>。

请发送错误报告到[论坛](http://discussion.listary.com/)上，或填写[反馈表格](http://www.listary.com/contact)，谢谢！![doc-disable-double-ctrl](http://www.listary.com/wp-content/uploads/doc-disable-double-ctrl.png)

### 6.3 在程序中禁用 Listary

1. 在该程序中启动 Listary；
2. 移动鼠标指针到右侧三点上；
3. 点击第三个按钮；
4. 选择 `在该程序中禁用 Listary`

![doc-disable-listary1](http://www.listary.com/wp-content/uploads/doc-disable-listary1.png)

![doc-disable-listary2](http://www.listary.com/wp-content/uploads/doc-disable-listary2.png)

### 6.4 “在该程序中禁用 Listary” 未出现 

1. 打开 `Listary 选项`－`应用程序设置`；
2. 点击添加按钮，选择应用程序（如 “C:\Windows\System32\Taskmgr.exe”）；
3. 取消选择该项目；
4. 点击 `确认` 或 `应用`。

![doc-disable-listary3](http://www.listary.com/wp-content/uploads/doc-disable-listary3.png)