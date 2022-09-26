//
//  CartView.swift
//  Food Order
//
//  Created by MacOS on 9/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {present.wrappedValue.dismiss()}) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.orange)
                }
                
                Text("Cart")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing:0) {
                    ForEach(homeData.cartItems) { item in
                        HStack(spacing:15) {
                            WebImage(url: URL(string: item.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(item.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text(item.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack(spacing:15) {
                                    Text("\(homeData.getPrice(value: Float(truncating: item.item.item_cost)))")
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    Button(action: {
                                        if item.quantity > 1 {
                                            homeData.cartItems[homeData.getIndex(item: item.item, isCartIndex: true)].quantity -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text("\(item.quantity)")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .cornerRadius(15)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                    
                                    Button(action: {
                                        homeData.cartItems[homeData.getIndex(item: item.item, isCartIndex: true)].quantity += 1
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    
                                }
                                
                            }
                        }
                        .padding()
                        .contextMenu {
                            Button {
                                let cartIndex = homeData.getIndex(item: item.item, isCartIndex: true)
                                homeData.cartItems.remove(at: cartIndex)
                                let itemIndex = homeData.getIndex(item: item.item, isCartIndex: false)
                                homeData.items[itemIndex].isAdded = false
                                homeData.filteredItems[itemIndex].isAdded = false
                            } label: {
                                Text("Remove")
                            }

                        }
                    }
                }
                
            }
            
            Spacer(minLength: 0)
            
            VStack {
                HStack {
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(homeData.calTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top, .horizontal])
                
                Button(action: {
                    homeData.updateOrder()
                }) {
                    Text(homeData.hasOrdered ? "Cancel Order" : "Checkout")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(.orange)
                        .cornerRadius(15)
                }
            }
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

}

