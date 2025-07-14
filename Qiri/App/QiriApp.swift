//
//  QiriApp.swift
//  Qiri Watch App
//
//  Created by 김은찬 on 5/6/25.
//

import SwiftUI
import WatchConnectivity

@main
struct QiriApp: App {
    
    let wcSessionDelegate = WatchSessionDelegate.shared

    init() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = wcSessionDelegate
            session.activate()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
