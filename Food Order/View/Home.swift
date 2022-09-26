//
//  Home.swift
//  Food Order
//
//  Created by MacOS on 9/19/22.
//

import SwiftUI

struct Home: View {
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                
                HStack(spacing: 15) {
                    Button(action: {
                        withAnimation(.easeIn) {
                            HomeModel.showMenu.toggle()
                        }
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.orange)
                    })
                    
                    Text("Today's Menu")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding([.horizontal,.top])
                
                Divider()
                
                HStack(spacing: 15) {
                    Button(action: {}, label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.gray)
                    })
                    
                    TextField("Search", text: $HomeModel.search)
                }
                .padding(.horizontal)
                
                Divider()
                HStack (spacing: 15){
                    Image(systemName: "location.fill")
                        .font(.body)
                        .foregroundColor(.orange)
                    
                    Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver To:")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    Text(HomeModel.userAddress)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Spacer()
                }
                .padding(.horizontal, 15)
                
                if HomeModel.items.isEmpty {
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 25) {
                            ForEach(HomeModel.filteredItems) { item in
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                                    ItemView(item: item)
                                    HStack {
                                        Text ("FREE DELIVERY")
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal)
                                            .background(Color.orange)
                                        Spacer(minLength: 0)
                                        
                                        Button(action: {
                                            HomeModel.addToCart(item: item)
                                        }) {
                                            Image(systemName: item.isAdded ? "checkmark" : "cart.badge.plus")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(item.isAdded ? Color.green : Color.orange)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding(.trailing, 10)
                                    .padding(.top, 10)
                                })
                                .frame(width: UIScreen.main.bounds.width - 30)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                
               
                
                Spacer()
            }
            
            // Menu
            HStack {
                Menu(homeData: HomeModel)
                    .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                
                Spacer(minLength: 0)
            }
            .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                // When tap outside
                .onTapGesture {
                    withAnimation(.easeIn) { HomeModel.showMenu.toggle()
                    }
                })
            
            
            if !HomeModel.hasLocation {
                Text("This app requires location service be turn on. Please allow or change permission in Settings.")
                    .foregroundColor(.black)
                    // Alert
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(.white)
                    .cornerRadius(10)
                    // Blocks view
                    .frame(minWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        .onAppear(perform: {
            // Ask for location permission
            HomeModel.locationManager.delegate = HomeModel
        })
        .onChange(of: HomeModel.search) { value in
            // Avoid continuous search request
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if value == HomeModel.search && HomeModel.search != "" {
                    HomeModel.filterData()
                }
            }
            
            if HomeModel.search == "" {
                // Reset
                withAnimation(.easeOut) {
                    HomeModel.filteredItems = HomeModel.items
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
