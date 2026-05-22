//
//  CategoryCellView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 18/05/26.
//

// Presentation/CategoryList/Views/CategoryCellView.swift

import SwiftUI

struct CategoryCellView: View {

   let category: Category

   var body: some View {
      VStack(spacing: 10) {
         AsyncImage(url: URL(string: category.imageUrl)) { phase in
            switch phase {
               case .success(let image):
                  image
                     .resizable()
                     .scaledToFill()
               case .failure:
                  Image(systemName: "photo")
                     .foregroundColor(Color(hex: "#9E9E9E")) // AppLightGray
               case .empty:
                  ProgressView()
                     .tint(Color(hex: "#3D5AFE")) // AppPrimaryBlue
               @unknown default:
                  EmptyView()
            }
         }
         .frame(width: 60, height: 60)
         .clipShape(RoundedRectangle(cornerRadius: 14))
         .background(
            RoundedRectangle(cornerRadius: 14)
               .fill(Color(hex: "#EDE7FF")) // AppLavender
         )

         Text(category.name)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color(hex: "#1A1A2E")) // AppText
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(width: 72)
      }
      .padding(.vertical, 8)
   }
}

//struct CategoryCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryCellView()
//    }
//}
