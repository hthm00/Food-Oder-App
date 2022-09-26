//
//  HomeViewModel.swift
//  Food Order
//
//  Created by MacOS on 9/19/22.
//

import SwiftUI
import CoreLocation
import Firebase

// Fetching user location
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate  {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    // Location
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var hasLocation = true;
    
    // Menu
    @Published var showMenu = false;
    
    // Item
    @Published var items: [Item] = []
    @Published var filteredItems: [Item] = []
    
    // Cart
    @Published var cartItems: [Cart] = []
    @Published var hasOrdered = false
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Check location permission
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Authorized")
            self.hasLocation = true
            manager.requestLocation()
        case .denied:
            print("Denied")
            self.hasLocation = false
        default:
            self.hasLocation = false
            print("Unknown")
            
            // Ask for permission
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Read user location
        self.userLocation = locations.last
        self.getLocation()
        self.login()
    }
    
    func getLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (result, error) in
            guard let data = result else {return}
            var address = ""
            
            address += data.first?.name ?? ""
            address += ", "
            address += data.first?.locality ?? ""
            
            self.userAddress = address
            
        }
    }
    
    // Access database
    func login() {
        Auth.auth().signInAnonymously() { (res, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            print("Success = \(res!.user.uid)")
            self.fetchData()
        }
    }
    
    // Fetching Items
    func fetchData() {
        let dataBase = Firestore.firestore()
        
        dataBase.collection("Items").getDocuments { snap, err in
            guard let itemData = snap else {return}
            
            self.items = itemData.documents.compactMap({ doc -> Item? in
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                let ratings = doc.get("item_ratings") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            })
            
            self.filteredItems = self.items
        }
    }
    
    // Filter data
    func filterData() {
        withAnimation(.linear) {
            self.filteredItems = self.items.filter({ item in
                return item.item_name.lowercased().contains(self.search.lowercased())
            })
        }
        
    }
    
    // Update Cart
    func addToCart(item: Item) {
        self.items[getIndex(item: item, isCartIndex: false)].isAdded.toggle()
        self.filteredItems[getFilteredItemsIndex(item: item, isCartIndex: false)].isAdded.toggle()
        
        if item.isAdded {
            //remove
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
        } else {
            self.cartItems.append(Cart(item: item, quantity: 1))
        }
        
    }
    
    // Get index of item in items
    func getIndex(item: Item, isCartIndex: Bool) -> Int {
        let index = self.items.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { item1 -> Bool in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    // Get index of item in filteredItems
    func getFilteredItemsIndex(item: Item, isCartIndex: Bool) -> Int {
        let index = self.filteredItems.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    // Convert from float to $ currency
    func getPrice(value: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: value)) ?? ""
    }

    // Calculate total price
    func calTotalPrice() -> String {
        var price: Float = 0
        
        cartItems.forEach { item in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        return getPrice(value: price)
    }
    
    // Update order onto Firestore
    
    func updateOrder() {
        let db = Firestore.firestore()
        
        if hasOrdered {
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete { err in
                if err != nil {
                    self.hasOrdered = true
                }
                self.hasOrdered = false
            }
            return
        }
        
        var details : [[String: Any]] = []
        
        cartItems.forEach { cart in
            details.append([
                "item_name": cart.item.item_name,
                "item_quantiy": cart.quantity,
                "item_cost": cart.item.item_cost
            ])
        }
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "order_food": details,
            "total": calTotalPrice(),
            "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        ]) { err in
            if err != nil {
                return
            }
            self.hasOrdered = true
            print("Sucessful")
        }
    }
}
