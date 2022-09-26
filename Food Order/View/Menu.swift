//
//  Menu.swift
//  Food Order
//
//  Created by MacOS on 9/20/22.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    var body: some View {
        VStack (spacing: 15) {
            HStack(spacing: 5) {
                Text("Welcome,")
                    .font(.body)
                    .foregroundColor(.black)
                
                Text("Minh!")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            Divider()
            
            NavigationLink(destination: CartView(homeData: homeData)) {
                HStack(spacing: 15) {
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Version 1.0")
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
        }
        .padding(10)
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(homeData: HomeViewModel())
    }
}
