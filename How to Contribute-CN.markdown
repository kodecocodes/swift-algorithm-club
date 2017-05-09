# 如何做贡献

想要帮助 Swift 算法俱乐部？非常好！

## 可以贡献些什么？

看看这个[列表](README.markdown)。任何还没有链接的算法或者数据结构可以。

在[构建中](Under%20Contruction-CN.markdown)的算法也在继续。欢迎提出建议和反馈！

随时欢迎新的算法和数据结构（即使不在列表里）。

我们始终都对提高现有实现和更好的描述感兴趣。欢迎提供让代码更像 Swift 或者更像标准库的建议。

单元测试。错别字修正。所有贡献都是有用的。:-)

## 请遵循下面的流程

为了保证仓库的高质量，当提交贡献的时候请遵循下面的流程：

1. 提交一个请求来“声明”一个算法或者数据结构。这样就不会有多个人做同一件事情。
2. 写代码要参考 [编码规范](https://github.com/raywenderlich/swift-style-guide)
3. 写一个算法如何实现的解释。包括 **大量示例**。图片更好。参考[快速排序](Quicksort/README-CN.markdown)
4. 在解释的最后写上你的名字，像 *作者：Your Name* 这样
5. 附上一个 playground 或者单元测试
6. 运行 [SwiftLint](https://github.com/realm/SwiftLint) 
	 - [安装](https://github.com/realm/SwiftLint#installation)
	 - 打开命令行并且运行 `swiftlint` 命令

```
cd path/to/swift-algorithm-club
swiftlint
```

只要你知道，我可能会编辑你的文本和代码的语法等，为了保证更好的质量。

对于单元测试：

- 将测试工程添加到 `.travis.yml` 以便他们在 [Travis-CI](https://travis-ci.org/raywenderlich/swift-algorithm-club) 运行。添加一行这样的嗲吗到 `.travis.yml`：

```
- xctool test -project ./Algorithm/Tests/Tests.xcodeproj -scheme Tests
```

- 配置工程的 scheme 以便在 Travis-CI 上运行： 
    - Open **Product -> Scheme -> Manage Schemes...**
    - Uncheck **Autocreate schemes**
    - Check **Shared**

![Screenshot of scheme settings](Images/scheme-settings-for-travis.png)

## 想聊天？

这不只是一个有大量代码的仓库...如果你想学习一个算法是如何工作的或者想要讨论更好的解决问题的办法，那么开启一个[Github issue](https://github.com/raywenderlich/swift-algorithm-club/issues) 来讨论吧！


