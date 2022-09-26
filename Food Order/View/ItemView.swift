//
//  ItemView.swift
//  Food Order
//
//  Created by MacOS on 9/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    var item: Item
    var body: some View {
        VStack {
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                .cornerRadius(10)
            
            HStack (spacing: 8) {
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                ForEach(1...5, id: \.self) {index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.item_ratings) ?? 0 ? .orange : .gray)
                }
            }
            
            HStack {
                Text(item.item_details)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                Spacer(minLength: 0)
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: Item(id: "sad", item_name: "Name", item_cost: 10, item_details: "Long description", item_image: "https://raw.githubusercontent.com/SDWebImage/SDWebImageSwiftUI/master/Example/Screenshot/Demo-iOS.jpg", item_ratings: "4"))
    }
}
