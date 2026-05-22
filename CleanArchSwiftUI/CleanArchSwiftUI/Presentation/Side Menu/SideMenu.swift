//
//  SideMenu.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 17/05/26.
//

import SwiftUI

enum MenuOption: Identifiable, CaseIterable {
   case home
   case profile
   case changePassword
   case notifications
   case privacySettings
   case helpSupport
   case logout

   var id: Self { self }

   var title: String {
      switch self {
         case .home:             return "Home"
         case .profile:          return "My Profile"
         case .changePassword:   return "Change Password"
         case .notifications:    return "Notifications"
         case .privacySettings:  return "Privacy & Security"
         case .helpSupport:      return "Help & Support"
         case .logout:           return "Log Out"
      }
   }

   var icon: String {
      switch self {
         case .home:             return "house.fill"
         case .profile:          return "person.fill"
         case .changePassword:   return "lock.rotation"
         case .notifications:    return "bell.fill"
         case .privacySettings:  return "shield.lefthalf.filled"
         case .helpSupport:      return "questionmark.circle.fill"
         case .logout:           return "rectangle.portrait.and.arrow.right"
      }
   }

   var isDestructive: Bool { self == .logout }
   var isGroupSeparatorBefore: Bool { self == .logout }
}

struct SideMenuView: View {
   let user: User
   var onOptionSelected: (MenuOption) -> Void

   @State private var selectedOption: MenuOption? = .home
   @State private var appeared = false

   var body: some View {
      ZStack {
         // Background gradient
         LinearGradient(
            colors: [
               Color(hex: "0F1923"),
               Color(hex: "1A2535")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
         )
         .ignoresSafeArea()

         // Decorative accent circle
         Circle()
            .fill(Color(hex: "4F8EF7").opacity(0.08))
            .frame(width: 300, height: 300)
            .offset(x: -60, y: -180)
            .blur(radius: 40)

         VStack(alignment: .leading, spacing: 0) {

            // MARK: - User Header
            userHeader
               .padding(.top, 60)
               .padding(.horizontal, 24)
               .padding(.bottom, 32)

            Divider()
               .background(Color.white.opacity(0.08))
               .padding(.horizontal, 24)

            // MARK: - Menu Items
            ScrollView(.vertical, showsIndicators: false) {
               VStack(alignment: .leading, spacing: 4) {
                  ForEach(Array(MenuOption.allCases.enumerated()), id: \.element.id) { index, option in
                     if option.isGroupSeparatorBefore {
                        Divider()
                           .background(Color.white.opacity(0.08))
                           .padding(.horizontal, 24)
                           .padding(.vertical, 8)
                     }

                     MenuRowView(
                        option: option,
                        isSelected: selectedOption == option
                     ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                           selectedOption = option
                        }
                        onOptionSelected(option)
                     }
                     .padding(.horizontal, 12)
                     .opacity(appeared ? 1 : 0)
                     .offset(x: appeared ? 0 : -20)
                     .animation(
                        .spring(response: 0.5, dampingFraction: 0.8)
                        .delay(Double(index) * 0.06),
                        value: appeared
                     )
                  }
               }
               .padding(.vertical, 16)
            }

            Spacer()

            // MARK: - Footer
            footer
               .padding(.horizontal, 24)
               .padding(.bottom, 40)
         }
      }
      .onAppear {
         withAnimation { appeared = true }
      }
   }

   // MARK: - User Header

   private var userHeader: some View {
      HStack(spacing: 14) {
         // Avatar
         ZStack {


            Text("\(user.firstName) \(user.lastName)")
               .font(.system(size: 20, weight: .semibold, design: .rounded))
               .foregroundColor(AppTheme.surface)
         }
         .opacity(appeared ? 1 : 0)
         .scaleEffect(appeared ? 1 : 0.7)
         .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: appeared)

         // Name + Email
         VStack(alignment: .leading, spacing: 3) {
            Text(user.firstName)
               .font(.system(size: 17, weight: .semibold, design: .rounded))
               .foregroundColor(.white)

            Text(user.email)
               .font(.system(size: 13, weight: .regular))
               .foregroundColor(Color.white.opacity(0.45))
               .lineLimit(1)
         }
         .opacity(appeared ? 1 : 0)
         .offset(x: appeared ? 0 : -10)
         .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.15), value: appeared)

         Spacer()
      }
   }

   // MARK: - Footer

   private var footer: some View {
      Text("Version 2.4.1")
         .font(.system(size: 11, weight: .medium))
         .foregroundColor(Color.white.opacity(0.2))
   }
}


struct MenuRowView: View {
   let option: MenuOption
   let isSelected: Bool
   let action: () -> Void

   @State private var isPressed = false

   var body: some View {
      Button(action: action) {
         HStack(spacing: 14) {
            // Icon container
            ZStack {
               RoundedRectangle(cornerRadius: 10, style: .continuous)
                  .fill(iconBackground)
                  .frame(width: 36, height: 36)

               Image(systemName: option.icon)
                  .font(.system(size: 15, weight: .medium))
                  .foregroundColor(iconColor)
            }

            Text(option.title)
               .font(.system(size: 15, weight: isSelected ? .semibold : .regular, design: .rounded))
               .foregroundColor(labelColor)

            Spacer()

            if isSelected && !option.isDestructive {
               Circle()
                  .fill(Color(hex: "4F8EF7"))
                  .frame(width: 6, height: 6)
            }
         }
         .padding(.horizontal, 12)
         .padding(.vertical, 11)
         .background(rowBackground)
         .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      }
      .buttonStyle(PressableButtonStyle())
   }

   private var iconBackground: Color {
      if option.isDestructive {
         return Color(hex: "FF4B4B").opacity(0.15)
      }
      return isSelected
      ? Color(hex: "4F8EF7").opacity(0.18)
      : Color.white.opacity(0.06)
   }

   private var iconColor: Color {
      if option.isDestructive { return Color(hex: "FF6B6B") }
      return isSelected ? Color(hex: "4F8EF7") : Color.white.opacity(0.5)
   }

   private var labelColor: Color {
      if option.isDestructive { return Color(hex: "FF6B6B") }
      return isSelected ? .white : Color.white.opacity(0.65)
   }

   private var rowBackground: Color {
      isSelected && !option.isDestructive
      ? Color(hex: "4F8EF7").opacity(0.08)
      : Color.clear
   }
}

struct PressableButtonStyle: ButtonStyle {
   func makeBody(configuration: Configuration) -> some View {
      configuration.label
         .scaleEffect(configuration.isPressed ? 0.97 : 1)
         .opacity(configuration.isPressed ? 0.85 : 1)
         .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
   }
}

//struct SideMenu_Previews: PreviewProvider {
//    static var previews: some View {
//       SideMenuView()
//    }
//}
