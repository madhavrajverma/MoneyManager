//
//  text+extension.swift
//  text+extension
//
//  Created by Madhav Raj Verma on 09/11/21.
//

import Foundation
import SwiftUI


extension Date {
    func formmatedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd"
        return formatter.string(from: self)
    }
}

extension Double {
    static func formmatedPrice(price:Double) -> String {
        let roundPrice =  String(format: "%.2f", price)
         return ("$\(roundPrice)")
    }
}


//MARK: -  Cutsom Placholder for textField

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
