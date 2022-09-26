//
//  Cart.swift
//  Food Order
//
//  Created by MacOS on 9/21/22.
//

import SwiftUI

struct Cart: Identifiable {
    var id =  UUID().uuidString
    var item: Item
    var quantity: Int
}

