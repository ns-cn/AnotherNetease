//
//  YuApp.swift
//  Shared
//
//  Created by tangyujun on 2022/5/23.
//

import SwiftUI

@main
struct YuApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
#if os(macOS)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
