//
//  ContentView.swift
//  afterstore
//
//  Created by KOng's Macbook Pro on 28/4/2566 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int {
                    MainView(userId: userId)
                } else {
                    LoginView()
                }
    }
}
