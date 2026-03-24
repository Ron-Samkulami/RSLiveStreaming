//
//  RSLiveStreamingApp.swift
//  RSLiveStreaming
//

import SwiftUI

@main
struct RSLiveStreamingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    appDelegate.saveContext()
                }
        }
    }
}
