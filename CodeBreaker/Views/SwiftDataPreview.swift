//
//  SwiftDataPreview.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 04/03/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import SwiftData

struct SwiftDataPreview: PreviewModifier {
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: CodeBreaker.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        // load up some sample data into container.mainContext
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    //static var swiftData: PreviewTrait<Preview.ViewTraits> = .modifier(SwiftDataPreview())
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview()) // Capital 'S' Self means the type I am in
}
