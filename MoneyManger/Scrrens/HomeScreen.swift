//
//  HomeScreen.swift
//  HomeScreen
//
//  Created by Madhav Raj Verma on 09/11/21.
//

import SwiftUI
import CoreData


struct HomeScreen: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Transcation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Transcation.date, ascending: true)]) var transcations: FetchedResults<Transcation>
    
    @FetchRequest(entity: MoneyData.entity(), sortDescriptors: []) var moneyDatas: FetchedResults<MoneyData>



    @State private var isAddNew:Bool = false
    
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    var body: some View {

        ZStack(alignment: .bottom) {
           // legend is optional
           
            VStack {
                NavBar()
                HStack {
                    Spacer()
                    VStack {
                        Text("INCOME")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(Double.formmatedPrice(price: moneyDatas[0].income))")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    VStack {
                        Text("EXPENSE")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(Double.formmatedPrice(price: moneyDatas[0].expense))")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    VStack {
                        Text("BALANCE")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(Double.formmatedPrice(price: moneyDatas[0].balance))")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }

                       .frame(width: UIScreen.main.bounds.width)
                
                List {
                    
                    
//                    Text("Total Amount\(Double.formmatedPrice(price:transactionsData.totalAmount))")
                    ForEach(transcations) { singleTranscation  in
                        ListView(appData: singleTranscation)
                            .padding(.vertical,6)
                          
                    }.onDelete { index in
                       deleteTransaction(at: index)
                    }
                }
            }
            
            
            Button(action:{
                self.isAddNew = true
            }) {
                Text("Add New")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .padding(.horizontal)
                    .background(Color.red.cornerRadius(8))
                    
                    
                
            }.padding()
        }.fullScreenCover(isPresented: $isAddNew)
            {
            AddNew()
        }
        
    }
    
    func deleteTransaction(at offsets :IndexSet) {
        for index in offsets {
            let transcation = transcations[index]
            managedObjectContext.delete(transcation)
        }
        PersistenceController.shared.save()
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


struct ListView:View {
     var appData:Transcation
    var body: some View {
        HStack {
            Image(systemName: appData.category ?? "")
            VStack(alignment:.leading) {
                Text(appData.note ?? "")
                    .font(.title)
                    .fontWeight(.regular)
                    
                Text(appData.date?.formmatedDate() ?? Date().formmatedDate())
                    .font(.caption)
                    .fontWeight(.light)
                    
            }
            
            Spacer()
            Text(Double.formmatedPrice(price: appData.price))
                .font(.title3)
                .foregroundColor(appData.type == TranscationType.Expense.rawValue ? Color.red : Color.green)
                .padding(.trailing)
        }
    }
}



struct NavBar:View {
    var body: some View {
        HStack {
            Spacer()
            Text("Wallet")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }.padding(.top,20)
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
    }
}
