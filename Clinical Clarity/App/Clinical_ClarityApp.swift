//
//  Clinical_ClarityApp.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 09/07/26.
//

import SwiftUI

@main
struct Clinical_ClarityApp: App {
    
    @StateObject private var authManager: AuthManager
    @StateObject private var appFlow: AppFlowManager
    
    init() {
        let auth = AuthManager()
        _authManager = StateObject(wrappedValue: auth)
        _appFlow = StateObject(wrappedValue: AppFlowManager(authManager: auth))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
                .environmentObject(appFlow)
        }
    }
}
