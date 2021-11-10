//
//  ContentView.swift
//  MoneyManger
//
//  Created by Madhav Raj Verma on 09/11/21.
//

import SwiftUI
import LocalAuthentication
import UserNotifications

struct ContentView: View {
    
    @AppStorage("sound") var sound:Bool = false
    @AppStorage("passCode") var passCode :Bool = false
    
    var body: some View {
        TabView {
           HomeScreen()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
            
            ProfileScreen()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                }
        }.onAppear {
            NoticationAuthorization()
        }
}
    
    func NoticationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    

    
   

   
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
