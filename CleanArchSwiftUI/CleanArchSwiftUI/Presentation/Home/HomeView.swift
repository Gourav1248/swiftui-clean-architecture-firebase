//
//  HomeView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 15/05/26.
//

import SwiftUI

struct HomeView: View {

   // @StateObject = "create and own this ViewModel"
   @StateObject private var viewModel = HomeViewModel()
   @EnvironmentObject var loader: LoaderManager

   // Controls whether the side menu/filter sheet is showing
   @State private var showMenu: Bool = false

   var body: some View {
      NavigationStack {
         VStack(spacing: 0) {

            // ── Top Bar ──
            topBar

            // ── Search Bar ──
            searchBar
               .padding(.horizontal, 16)
               .padding(.vertical, 10)

            // ── Store List ──
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
            .refreshable {
               await  viewModel.refreshStoreList()
            }
            .padding(EdgeInsets(top: 0.0, leading: 3.0, bottom: 0.0, trailing: 3.0))
         }
         .background(Color(.white))
         .navigationBarHidden(true) // We built our own top bar
      }
      .task {
         await viewModel.fetchAllStores()
      }

      .onChange(of: viewModel.isLoading) { loading in
         if loading ?? false {
            loader.show(message: "Please wait.....fetching stores")
         } else {
            loader.hide()
         }
      }

      .onChange(of: viewModel.errorMessage) { error in

         if let error = error {
            print("Error: \(error)")
         }
      }


      .sheet(isPresented: $showMenu) {
         // Menu sheet — you can expand this later
         Text("Menu / Filters")
            .font(.title)
            .padding()
      }
   }

   // MARK: - Top Bar
   // "MARK:" is just a comment that organizes code into sections (visible in Xcode jump bar)
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

         // Menu Button
         Button {
            showMenu = true
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

   // MARK: - Search Bar
   private var searchBar: some View {
      HStack(spacing: 10) {
         Image(systemName: "magnifyingglass")
            .foregroundColor(.black)

         // Two-way binding: as user types, viewModel.searchText updates instantly
         TextField(
            "",
            text: $viewModel.searchText,
            prompt: Text("Search stores...")
               .foregroundColor(.gray.opacity(0.75))  // ✅ placeholder gray
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
