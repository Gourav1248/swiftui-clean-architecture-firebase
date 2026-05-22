//
//  HomeView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 15/05/26.
//

import SwiftUI

struct HomeView: View {
   @StateObject private var viewModel = HomeViewModel()
   @EnvironmentObject var loader: LoaderManager
   @State private var showMenu: Bool = false


   let currentUser = User(uid: "", firstName: "Gourav", lastName: "Joshi", email: "gouravjtest@gmail.com", phone: "", address: "", city: "", gender: "", isActive: true, createdAt: Date())


   var body: some View {
      ZStack(alignment: .leading) {

         // ── 1. Main Content ──
         NavigationStack {
            VStack(spacing: 0) {
               topBar
               searchBar
                  .padding(.horizontal, 16)
                  .padding(.vertical, 10)
               List {
                  ForEach(viewModel.stores, id: \.id) { obStore in
                     StoreCardView(store: obStore)
                  }
                  .listRowSeparator(.hidden)
                  .listRowInsets(EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                  .listRowBackground(Color.clear)
               }
               .listStyle(.plain)
               .scrollContentBackground(.hidden)
               .refreshable { await viewModel.refreshStoreList() }
               .padding(EdgeInsets(top: 0.0, leading: 3.0, bottom: 0.0, trailing: 3.0))
            }
            .background(Color.white)
            .navigationBarHidden(true)
         }
         .offset(x: showMenu ? 270 : 0)
         .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showMenu)

         // ── 2. Dark Overlay (tap to close) ──
         if showMenu {
            Color.black.opacity(0.4)
               .ignoresSafeArea()
               .offset(x: 270)
               .onTapGesture {
                  withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                     showMenu = false
                  }
               }
         }

         // ── 3. Side Menu ──
         if showMenu {
            SideMenuView(user: currentUser) { option in
               withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                  showMenu = false
               }
            }
            .frame(width: 270)
            .transition(.move(edge: .leading))
         }
      }
      .task { await viewModel.fetchAllStores() }
      .onChange(of: viewModel.isLoading) { loading in
         if loading ?? false {
            loader.show(message: "Please wait.....fetching stores")
         } else {
            loader.hide()
         }
      }
      .onChange(of: viewModel.errorMessage) { error in
         if let error = error { print("Error: \(error)") }
      }
   }

   // MARK: - Top Bar (same as before — no changes needed)
   private var topBar: some View {
      HStack {
         VStack(alignment: .leading, spacing: 2) {
            Text("Good Morning 👋")
               .font(.system(size: 13))
               .foregroundColor(AppTheme.primary)
            Text("Find a Store")
               .font(.system(size: 22, weight: .bold))
               .foregroundColor(AppTheme.textPrimary)
         }

         Spacer()

         // Menu Button ← showMenu = true yahan set hota hai
         Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
               showMenu = true
            }
         } label: {
            ZStack {
               RoundedRectangle(cornerRadius: 12)
                  .fill(Color.indigo.opacity(0.10))
                  .frame(width: 42, height: 42)
               Image(systemName: "line.3.horizontal")
                  .font(.system(size: 18, weight: .medium))
                  .foregroundStyle(Color.indigo)
            }
         }
      }
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .padding(.bottom, 8)
   }

   // MARK: - Search Bar (no changes)
   private var searchBar: some View {
      HStack(spacing: 10) {
         Image(systemName: "magnifyingglass")
            .foregroundColor(.black)
         TextField(
            "",
            text: $viewModel.searchText,
            prompt: Text("Search stores...")
               .foregroundColor(.gray.opacity(0.75))
         )
         .foregroundColor(.black)
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 12)
      .background(AppTheme.surface)
      .cornerRadius(14)
      .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
      .overlay(
         RoundedRectangle(cornerRadius: 12.0)
            .stroke(AppTheme.border, lineWidth: 1.5)
      )
   }
}
   

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
