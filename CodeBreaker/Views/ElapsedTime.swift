//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by app-kaihatsusha on 27/02/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI



struct ElapsedTime: View {
    
    let startTime: Date
    let endTime: Date?
    
    var body: some View {
        if let endTime {
            Text(endTime, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        } else {
            Text(TimeDataSource<Date>.currentDate, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        }
        
    }
}

//#Preview {
//    ElapsedTime()
//}
