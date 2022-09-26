//
//  Item.swift
//  Food Order
//
//  Created by MacOS on 9/21/22.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_ratings: String
    
    var isAdded: Bool = false
}
