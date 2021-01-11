//
//  IOS_Final_DemoApp.swift
//  IOS_Final_Demo
//
//  Created by 翁星宇 on 2021/1/11.
//

import SwiftUI

@main
struct IOS_Final_DemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
