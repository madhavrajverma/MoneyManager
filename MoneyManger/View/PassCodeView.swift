//
//  PassCodeView.swift
//  PassCodeView
//
//  Created by Madhav Raj Verma on 10/11/21.
//

import SwiftUI
import LocalAuthentication

struct PassCodeView: View {
    @State private var passCode:String = ""
    @State private var unclocked:Bool  = false
    @State private var openAlert:Bool = false
    var body: some View {
        VStack {
            if unclocked {
               ContentView()
            } else {
               Text("")
            }
        }.alert(isPresented: $openAlert, content: {
            Alert(title: Text("Error"), message: Text("Unable To recognize your Biometric"), dismissButton: .cancel())
        })
        .onAppear {
            
            authenticate()
        }
        
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.unclocked = true
                    } else {
                        self.openAlert = true
                    }
                }
            }
        } else {
            // no biometrics
            self.openAlert = true
        }
    }
}

struct PassCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PassCodeView()
    }
}
