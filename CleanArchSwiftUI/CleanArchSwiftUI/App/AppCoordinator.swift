//
//  AppCoordinator.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 10/05/26.
//

// App/AppCoordinator.swift

import SwiftUI

struct AppCoordinator: View {

   @StateObject private var router = AppRouter()
   @State private var showAuth: Bool = false
   @StateObject private var alertManager = AlertManager()  // ✅ add
   @StateObject var loaderManager = LoaderManager()

   var body: some View {
      ZStack {
         Group {
            if !showAuth {
               SplashView {
                  showAuth = true
               }
            } else if router.isAuthenticated {
               //HomeView()
               MainTabView()
            } else {
               NavigationStack(path: $router.path) {
                  LoginView()
                     .navigationBarHidden(true)
                     .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                           case .signup:
                              SignUpView()
                                 .navigationBarHidden(true)
                              //case .home:
                              
                              // HomeView()
                           case .login:
                              LoginView()
                        }
                     }

               }
               .environmentObject(router)  // ✅ poori app mein available
               .environmentObject(alertManager) // Available throughout the app
               .environmentObject(loaderManager) 
               .animation(.easeInOut, value: loaderManager.isLoading)

               if loaderManager.isLoading {
                  LoaderView(message: loaderManager.message)
                     .zIndex(999)
               }
            }
         }
      }
   }
}

struct SplashView: View {
   var onComplete: (() -> Void)? = nil

   var body: some View {
      // Apna actual splash UI yahan
      ZStack {
         Color.white.ignoresSafeArea()

         Image("AppLogo") // apna logo
            .resizable()
            .frame(width: 120, height: 120)
      }
      .onAppear {
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            onComplete?()
         }
      }
   }
}
