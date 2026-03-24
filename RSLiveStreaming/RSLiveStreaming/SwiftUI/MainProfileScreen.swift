//
//  MainProfileScreen.swift
//  RSLiveStreaming
//
//  「我」页：按旧版 Main.storyboard / MainPage 布局用 SwiftUI 还原头部与菜单列表。
//

import SwiftUI
import UIKit

// MARK: - 根界面（嵌入 UINavigationController）

struct MainProfileScreen: View {
    private let menuPrimary: [(title: String, symbol: String?)] = [
        ("我的勋章", "tag"),
        ("礼物贡献榜", "doc.text"),
        ("我的特权", "bookmark"),
        ("我的背包", "bag"),
        ("购物助手", "cart"),
    ]

    private let menuSecondary: [(title: String, asset: String)] = [
        ("派对房间", "collectionView"),
        ("主播中心", "me"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                MainProfileLegacyHeader()
                    .padding(.vertical, 8)

                VStack(spacing: 0) {
                    ForEach(Array(menuPrimary.enumerated()), id: \.offset) { idx, item in
                        MainProfileMenuRow(title: item.title, systemImage: item.symbol, assetImage: nil)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                        if idx < menuPrimary.count - 1 {
                            Divider().padding(.leading, 56)
                        }
                    }

                    Divider()
                        .padding(.vertical, 8)

                    ForEach(Array(menuSecondary.enumerated()), id: \.offset) { idx, item in
                        MainProfileMenuRow(title: item.title, systemImage: nil, assetImage: item.asset)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                        if idx < menuSecondary.count - 1 {
                            Divider().padding(.leading, 56)
                        }
                    }
                }
                .background(Color.white)
                .padding(.horizontal, 5)
                .padding(.bottom, 24)
            }
        }
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
    }
}

// MARK: - 与旧 Storyboard 一致的头部

private struct MainProfileLegacyHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            topIdentityRow
                .padding(.leading, 25)
                .padding(.top, 8)

            statsRow
                .padding(.top, 10)
                .padding(.horizontal, 0)

            iconStrip
                .padding(.top, 8)
                .padding(.horizontal, 5)

            balanceRow
                .padding(.top, 5)
                .padding(.horizontal, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// 头像 + 昵称 + 圆形徽章「25」+ ID
    private var topIdentityRow: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("placeHolder")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 40))

            VStack(alignment: .leading, spacing: 4) {
                Text("RonCoding")
                    .font(.system(size: 17))

                ZStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentColor)
                    Text("25")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 24, height: 24, alignment: .center)

                Text("ID:1402434985@qq.com")
                    .font(.system(size: 10))
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
        }
    }

    /// 第一行：1、2、4、25；第二行：好友、关注、粉丝、最近来访 同一水平线；中间两列共用 60pt 灰底（与旧版一致）
    private var statsRow: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let centerW = w * 0.5
            let side = (w - centerW) / 2
            let labelFont = Font.system(size: 12)
            let labelColor = Color(UIColor.tertiaryLabel)

            ZStack {
                HStack(spacing: 0) {
                    Color.clear.frame(width: side)
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color(UIColor.systemGray6))
                        .frame(width: centerW, height: 60)
                    Color.clear.frame(width: side)
                }

                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Text("1")
                            .font(.system(size: 15))
                            .frame(width: side, alignment: .center)

                        HStack(spacing: 0) {
                            Text("2")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity)
                            Text("4")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity)
                        }
                        .frame(width: centerW)
                        .padding(.top, 10)

                        Text("25")
                            .font(.system(size: 15))
                            .frame(width: side, alignment: .center)
                    }

                    HStack(spacing: 0) {
                        Text("好友")
                            .font(labelFont)
                            .foregroundColor(labelColor)
                            .frame(width: side, alignment: .center)

                        HStack(spacing: 0) {
                            Text("关注")
                                .font(labelFont)
                                .foregroundColor(labelColor)
                                .frame(maxWidth: .infinity)
                            Text("粉丝")
                                .font(labelFont)
                                .foregroundColor(labelColor)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(width: centerW)

                        Text("最近来访")
                            .font(labelFont)
                            .foregroundColor(labelColor)
                            .frame(width: side, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .top)
            }
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
        }
        .frame(height: 60)
    }

    /// 白底五列：等级 / 家族 / 贵族 / 真爱团 / 活动中心
    private var iconStrip: some View {
        HStack(spacing: 0) {
            iconColumn(title: "等级", imageName: "photo01", isSystem: false)
            iconColumn(title: "家族", imageName: "photo01", isSystem: false)
            iconColumn(title: "贵族", imageName: "shoppingCar", isSystem: false)
            iconColumn(title: "真爱团", imageName: "heart&+", isSystem: false)
            iconColumn(title: "活动中心", imageName: "collectionView", isSystem: false)
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }

    private func iconColumn(title: String, imageName: String, isSystem: Bool) -> some View {
        VStack(spacing: 5) {
            Group {
                if isSystem {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(height: 35)

            Text(title)
                .font(.system(size: 15))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }

    /// 余额 / 收益 双卡片
    private var balanceRow: some View {
        HStack(alignment: .top, spacing: 5) {
            balanceCard(
                title: "余额",
                subtitle: "您的钱包空空如也呢"
            )
            balanceCard(
                title: "收益",
                subtitle: "赚取您的第一桶金！"
            )
        }
    }

    private func balanceCard(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 17))
                .padding(.leading, 20)
                .padding(.top, 10)

            Spacer(minLength: 0)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(Color(UIColor.darkGray))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

// MARK: - 菜单行（仿 UITableView 样式）

private struct MainProfileMenuRow: View {
    let title: String
    let systemImage: String?
    let assetImage: String?

    var body: some View {
        HStack(spacing: 12) {
            if let sys = systemImage {
                Image(systemName: sys)
                    .font(.system(size: 20))
                    .frame(width: 28, alignment: .center)
            } else if let asset = assetImage {
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }

            Text(title)
                .font(.system(size: 17))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 供 Tab 使用的 UIKit 包装（导航栏按钮与旧版一致）

final class MainProfileHostingController: UIHostingController<MainProfileScreen> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(placeholder)),
            UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(placeholder)),
        ]
    }

    @objc private func placeholder() {}
}

enum MainProfileHosting {
    static func makeRootViewController() -> UIViewController {
        MainProfileHostingController(rootView: MainProfileScreen())
    }
}
