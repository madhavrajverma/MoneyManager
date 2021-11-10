//
//  ProfileScreen.swift
//  ProfileScreen
//
//  Created by Madhav Raj Verma on 09/11/21.
//

import SwiftUI

struct ProfileScreen: View {
    @State private var isSound:Bool = true
    @State private var isPasscode:Bool = false
    @AppStorage("passCode") var passCode :Bool = false
    @AppStorage("sound") var sound :Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @AppStorage("name") var userName:String?

    @FetchRequest(entity: MoneyData.entity(), sortDescriptors: []) var moneyDatas: FetchedResults<MoneyData>
    var body: some View {
        VStack {
            NavBar()
            
            List {
                HStack {
                    VStack {
                        Text(userName ?? "No Name")
                            .font(.title2)
                            .fontWeight(.bold)
                    
                        
                        HStack {
                            Text("INCOME")
                            Spacer()
                            Text("\(Double.formmatedPrice(price: moneyDatas[0].income))")
                                .foregroundColor(.green)
                        }.padding()
                    }
                    
                    
                    
                }
                
                
                Text("Transcations")
                Section(header: Text("Settings")) {
                    Text("Currency")
                    Text("Categories")
                    Text("Start of Month")
                    HStack {
                        
                        Text("Sound")
                        Spacer()
                        Toggle("", isOn: $sound)
                            .onChange(of: sound) { new in
                                if sound {
                                    postNotification()
                                }else {
                                    removeNotification()
                                }
                            }
                            
                        
                    }
                    
                    HStack {
                        
                        Text("Passcode Lock")
                        Spacer()
                        Toggle("", isOn: $passCode)
                           
                        
                    }
                }
                
                Section(header: Text("Data")) {
                    Text("Backup")
                }
                
                resetAllButton
                
            }
            .listStyle(InsetListStyle())
            
            
        }
    }
    
    
   
    
    
    
    var resetAllButton :some View {
        Button (action :{
            managedObjectContext.performAndWait {
                moneyDatas[0].income = 0
                moneyDatas[0].balance = 0
                moneyDatas[0].expense = 0
            }
            PersistenceController.shared.save()
        }) {
            HStack {
                Spacer()
                Text("Reset All Records")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding(.vertical)
                Spacer()
            }
        }
        
    }
    
    
    
    func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Remainder Message"
        content.body = "Have you update transcation Today"
        content.sound = .default
        content.badge = NSNumber(value:1)
        
        var date = DateComponents()
        date.hour = 8
        date.minute = 0
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let id = "daily-remainder"
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    
    }
    
    
    func removeNotification() {
        let id = "daily-remainder"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[id])
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
