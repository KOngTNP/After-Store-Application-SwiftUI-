//
//  MainView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 4/4/2566 BE.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    init() {
            UITabBar.appearance().backgroundColor = UIColor.white
        }
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                OrderView()
                    .tabItem {
                        Image(systemName: "checklist.unchecked")
                        Text("Order")
                    }
                    .tag(1)
                ProductView()
                    .tabItem {
                        Image(systemName: "gift")
                        Text("Product")
                    }
                    .tag(2)
                AccountView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(3)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
//        .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
