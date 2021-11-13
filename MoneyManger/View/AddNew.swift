//
//  AddNew.swift
//  AddNew
//
//  Created by Madhav Raj Verma on 09/11/21.
//

import SwiftUI



struct AddNew: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    @FetchRequest(entity: MoneyData.entity(), sortDescriptors: []) var moneyDatas: FetchedResults<MoneyData>

    
    let segmentedMenuType:[String]  = ["Income" ,"Expense"]

    @Environment(\.presentationMode) var presentationMode
    
    @State private var title:String = ""
    @State private var date = Date()
    @State private var categoy: String  = ""
    @State private var selectedMenu:String = "Income"
    @State private var isCategoryView:Bool = false
    @State private var price: String = ""
    @State private  var isSaveBarDisabled:Bool = true
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.green
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
       
    }
      
    
    var body: some View {
        VStack {
            cancelButton
        Spacer()
            VStack {
                Picker("", selection: $selectedMenu) {
                    ForEach(segmentedMenuType, id: \.self) { menu in
                        Text(menu)
                            .font(.largeTitle)
                            .textCase(.uppercase)
                            
                    }
                }.padding()
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                
            }
            
         Spacer()
            VStack {
                TextField("",text:$price)
                    .placeholder(when: price.isEmpty, placeholder: {
                        Text("$0.0")
                            .foregroundColor(selectedMenu == "Income" ? Color.green : Color.red)
                    })
                    .keyboardType(.decimalPad)
                    .font(.largeTitle)
                    .foregroundColor(selectedMenu == "Income" ? Color.green : Color.red)
                    .frame(maxWidth:UIScreen.main.bounds.width / 4 )
                    .onChange(of: price) { new in
                        isSaveBarDisabled = false
                    }
                
                TextField("Note",text: $title)
                    .padding()
                
                Divider()
                HStack {
                    
                    Text("Date")
                        .padding(.leading)
                    Spacer()
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .foregroundColor(.green)
                        .padding(.trailing)
                }
                .padding(.vertical)
                
                Divider()
                
                HStack {
                    Text("Category")
                        .padding(.leading)
                    Spacer()
                    Button(action:{
                        isCategoryView = true
                    }){
                        if categoy.isEmpty {
                            Image(systemName: "circle.grid.3x3")
                                .padding(.trailing)
                        }else {
                            Text(categoy)
                                .padding(.trailing)
                        }

                    }.foregroundColor(.green)
                }.padding(.vertical)
                
              saveButton
            }
            
            Spacer()
        }.sheet(isPresented: $isCategoryView) {
            CategoriyView(selectedCategory: $categoy)
        }
    }
    
    
    var saveButton:some View {
        Button(action:{
            
            let transcation = Transcation(context:managedObjectContext)
            transcation.note = title
            transcation.price = Double(price) ?? 00
            transcation.date = date
            transcation.category = categoy
           
            transcation.id = UUID()
            
            let newPrice = Double(price) ?? 0
            
            
            if selectedMenu == "Income" {
                transcation.type = TranscationType.Income.rawValue
                managedObjectContext.performAndWait {
                    moneyDatas[0].income += newPrice
                    moneyDatas[0].balance += newPrice
                }
                
            }else {
                transcation.type = TranscationType.Expense.rawValue
                managedObjectContext.performAndWait {
                    moneyDatas[0].expense += newPrice
                    moneyDatas[0].balance -= newPrice
                }
               
            }
            
            PersistenceController.shared.save()
            presentationMode.wrappedValue.dismiss()
            
        }) {
            Text("Save")
                .font(.title2)
                .foregroundColor(Color.white)
                .padding()
                .padding(.horizontal)
                .background(Color.green.cornerRadius(10))
        }.shadow(color: Color.gray, radius: 8, x: 5, y: 5)
            .disabled(isSaveBarDisabled)
    }
    
    
    var cancelButton: some View {
        HStack {
            Button(action:{
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Cancel")
                }
            }
            .foregroundColor(Color.green)
            Spacer()
        }
        .padding(.leading)
    }
}



struct Income_Previews: PreviewProvider {
    static var previews: some View {
        AddNew()
    }
}



let Categories = [
    "Vechicle" : "car.fill",
    "Travel":"airplane",
    "Food" : "leaf",
    "Health": "heart.text.square",
    "Shooping" : "cart",
    "Income" :"dollarsign.circle",
    "Others":"list.dash"
]



struct CategoriyView:View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCategory :String
    var body: some View {
        List {
            ForEach(Categories.keys.sorted(), id:\.self) {
                category in
                 Text(category)
                    .padding(.trailing)
                    .onTapGesture {
                        selectedCategory = Categories[category] ?? ""
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
}
