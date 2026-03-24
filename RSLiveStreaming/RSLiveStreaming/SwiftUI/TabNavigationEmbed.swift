//
//  TabNavigationEmbed.swift
//  RSLiveStreaming
//

import SwiftUI

/// 用代码创建的根控制器外包一层 `UINavigationController`，替代各模块 Storyboard。
struct TabNavigationEmbed: UIViewControllerRepresentable {
    let makeRoot: () -> UIViewController

    init(_ makeRoot: @escaping () -> UIViewController) {
        self.makeRoot = makeRoot
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        Self.navigationWrapping(root: makeRoot())
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    /// 供 `UITabBarController` 等场景复用，使 `hidesBottomBarWhenPushed` 生效（SwiftUI `TabView` 下无效）。
    static func navigationWrapping(root: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        nav.navigationBar.prefersLargeTitles = false
        return nav
    }
}
