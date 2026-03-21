//
//  MainTabView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//


import SwiftUI

struct HomeView: View {
	
    var body: some View {
        TabView {
            Text("Home")
                .tabItem { Label("Home", systemImage: "house") }

            Text("Events")
                .tabItem { Label("Events", systemImage: "calendar") }

            Button("Logout") {

						}
            .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}
