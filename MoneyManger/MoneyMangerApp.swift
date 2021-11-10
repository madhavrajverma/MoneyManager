//
//  MoneyMangerApp.swift
//  MoneyManger
//
//  Created by Madhav Raj Verma on 09/11/21.
//

import SwiftUI
import CoreData

@main
struct MoneyMangerApp: App {
    let persistanController = PersistenceController.shared
    @AppStorage("passCode") var passCode :Bool = false
    @AppStorage("isFirstTime") var isOnboarding : Bool = true
    
    init() {
        moneyData()
    }
    var body: some Scene {
        WindowGroup {
            if passCode {
                PassCodeView()
                    .environment(\.managedObjectContext, persistanController.container.viewContext)
            }else if isOnboarding == true {
                AddNameView()
                    .environment(\.managedObjectContext, persistanController.container.viewContext)
            }else {
                ContentView()
                    .environment(\.managedObjectContext, persistanController.container.viewContext)
            }
        }
        
    }
        
    func moneyData() {
        let moneyData = MoneyData(context: persistanController.container.viewContext)
        moneyData.expense = 0
        moneyData.balance = 0
        moneyData.income = 0
        
        persistanController.save()
    }
    
    
    
}
