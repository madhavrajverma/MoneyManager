//
//  AddNameView.swift
//  AddNameView
//
//  Created by Madhav Raj Verma on 11/11/21.
//

import SwiftUI

struct AddNameView: View {
    @State private var name :String = ""
    @AppStorage("name") var userName:String = ""
    @AppStorage("isFirstTime") var isFirstTime : Bool?
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                
                VStack {
                    Text("Money Manager")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                    
                    Image("money")
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 100 , maxWidth: 200, minHeight: 120, maxHeight: 200)
                      
                }
                    
                
                Spacer()
                
                VStack {
                    TextField("Enter Your Name",text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.3).opacity(0.2))
                        .cornerRadius(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(color: Color("shadowColor").opacity(0.3), radius: 15, x: 6, y: 6)
                                        .shadow(color: Color("shadowColor").opacity(0.3), radius: 15, x: -6, y: -6))
                       
                    Button(action:{
                        userName = name
                        isFirstTime = false
                    }) {
                        Text("Next")
                            .padding()
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(Color.green.cornerRadius(8))
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(color: Color("shadowColor").opacity(0.3), radius: 15, x: 6, y: 6)
                                            .shadow(color: Color("shadowColor").opacity(0.3), radius: 15, x: -6, y: -6))
                    }
                    .padding(.vertical)
                }
                Spacer()
            }
        }
    }
}

struct AddNameView_Previews: PreviewProvider {
    static var previews: some View {
        AddNameView()
    }
}
