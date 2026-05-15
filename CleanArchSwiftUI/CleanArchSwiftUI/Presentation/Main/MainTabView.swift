//
//  MainTabView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 14/05/26.
//

import SwiftUI

struct MainTabView: View {

   // Tracks which tab is currently selected (0 = Home, 1 = Categories, 2 = Settings)
   @State private var selectedTab: Int = 0

   var body: some View {
      TabView(selection: $selectedTab) {

         // ── Tab 1: Home ──
         HomeView()
         Text("Home View")
            .tabItem {
               Label("Home", systemImage: "house.fill")
            }
            .tag(0)

         // ── Tab 2: Categories (placeholder for now) ──
         Text("Categories Coming Soon")
            .tabItem {
               Label("Categories", systemImage: "square.grid.2x2.fill")
            }
            .tag(1)

         // ── Tab 3: Settings (placeholder for now) ──
         Text("Settings Coming Soon")
            .tabItem {
               Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(2)
      }
      .tint(.indigo) // Active tab icon color
   }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
