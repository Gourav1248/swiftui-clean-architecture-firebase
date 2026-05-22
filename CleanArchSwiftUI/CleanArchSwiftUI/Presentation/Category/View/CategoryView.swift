//
//  CategoryView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 18/05/26.
//

import SwiftUI

// Presentation/CategoryList/CategoryListView.swift

struct CategoryView: View {

   @StateObject private var viewModel: CategoryViewModel
   @EnvironmentObject var loader: LoaderManager

   // Horizontal scroll, 2-column grid, or adapt as needed
   private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

   init(viewModel: CategoryViewModel) {
      _viewModel = StateObject(wrappedValue: viewModel)
   }

   var body: some View {
         VStack(spacing: 0) {

            topBar
            ScrollView {

               LazyVGrid(
                  columns: columns,
                  spacing: 16
               ) {

                  ForEach(viewModel.categories, id: \.id) { category in

                     CategoryCellView(category: category)
                  }
               }
               .padding(.horizontal, 12)
               .padding(.top, 12)
            }
         }
         .background(Color.white)
      .task {
         await viewModel.loadCategories()
      }
   }
   

   // MARK: - Subviews

   private var topBar: some View {
      HStack {
         Spacer()

         VStack(alignment: .leading, spacing: 2) {
            Text("Store Categories")
               .font(.system(size: 13))
               .foregroundColor(AppTheme.primary)
            Text("See your category")
               .font(.system(size: 22, weight: .bold))
               .foregroundColor(AppTheme.textPrimary)
         }

         Spacer()
      }
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .padding(.bottom, 8)
   }

   private func categoryGrid(_ categories: [Category]) -> some View {
      ScrollView(.horizontal, showsIndicators: false) {
         HStack(spacing: 4) {
            ForEach(categories) { category in
               CategoryCellView(category: category)
            }
         }
         .padding(.horizontal, 16)
      }
   }

   private func errorView(_ message: String) -> some View {
      Text(message)
         .font(.system(size: 13))
         .foregroundColor(Color.red.opacity(0.85)) // AppError
         .padding()
   }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}
