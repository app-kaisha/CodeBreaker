//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 21/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                GameChooser()
                    .modelContainer(for: CodeBreaker.self)
                // inject geometry frame into all envrionments
                    .environment(\.sceneFrame, geometry.frame(in: .global))
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

extension EnvironmentValues {
    @Entry var sceneFrame: CGRect = UIScreen.main.bounds
}
