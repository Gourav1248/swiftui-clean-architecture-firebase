//
//  DependencyContainer.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 25/05/26.
//

import Foundation

final class DependencyContainer {
   //MARK: Data Layer:
   private lazy var storeRepository: StoreRepositoryProtocol = {
      StoreRepository()
   }()

   private lazy var categoryRepository: CategoryRepositoryProtocol = {
      CategoryRepository()
   }()

   private lazy var authRepository: AuthRepositoryProtocol = {
      FirebaseAuthRepository()
   }()

   //MARK: Auth Feature

   @MainActor
   func makeLoginViewModel() -> LoginViewModel {
      LoginViewModel(loginUseCase: LoginUseCase(repository: authRepository))
   }

   @MainActor
   func makeSignUpViewModel() -> SignUpViewModel {
      SignUpViewModel(signUpUseCase: SignUpUseCase(repository: authRepository))
   }

   @MainActor
   func makeHomeViewModel() -> HomeViewModel {
      HomeViewModel(storeUseCase: StoresUseCase(repository: storeRepository))
   }

   @MainActor
   func makeCategoryViewModel() -> CategoryViewModel {
      CategoryViewModel(useCase: CategoryUseCase(categoryRepository: categoryRepository))
   }

   @MainActor
   func makeStoreMapViewModel() -> StoreMapViewModel {
      StoreMapViewModel(
         storesUseCase: StoresUseCase(repository: storeRepository) // reuse
      )
   }
}
