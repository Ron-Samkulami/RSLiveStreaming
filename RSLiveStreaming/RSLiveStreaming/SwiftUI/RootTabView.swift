//
//  RootTabView.swift
//  RSLiveStreaming
//

import SwiftUI

/// 使用 `UITabBarController` 作为根，这样各 Tab 内 `UINavigationController` push 时
/// `hidesBottomBarWhenPushed` 与 `tabBarController` 行为与纯 UIKit 一致；SwiftUI `TabView` 无法实现这一点。
struct RootTabView: View {
    var body: some View {
        RootTabBarControllerRepresentable()
    }
}

private struct RootTabBarControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBar = UITabBarController()

        func tab(
            _ root: UIViewController,
            title: String,
            imageName: String
        ) -> UINavigationController {
            let nav = TabNavigationEmbed.navigationWrapping(root: root)
            nav.tabBarItem = UITabBarItem(
                title: title,
                image: UIImage(named: imageName),
                selectedImage: nil
            )
            return nav
        }

        tabBar.viewControllers = [
            tab(LiveStreamingViewController(), title: "直播", imageName: "video"),
            tab(NearByViewController(), title: "附近", imageName: "location"),
            tab(MessagesViewController(), title: "消息", imageName: "message_blue"),
            tab(MyFollowViewController(), title: "关注", imageName: "heart_red"),
            tab(MainProfileHosting.makeRootViewController(), title: "我", imageName: "me"),
        ]

        return tabBar
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}
}
