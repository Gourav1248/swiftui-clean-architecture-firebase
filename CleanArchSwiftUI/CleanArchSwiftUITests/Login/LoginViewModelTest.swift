//
//  LoginViewModelTest.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 25/05/26.
//
//  WHAT IS TESTED: LoginViewModel — @Published state, validation logic,
//                  UseCase interaction, error mapping
//
//  @MainActor — because LoginViewModel is @MainActor
//

import XCTest
import Combine
@testable import CleanArchSwiftUI

@MainActor
final class LoginViewModelTest: XCTestCase {

    // MARK: - SUT & Dependencies
    var sut: LoginViewModel!
    var mockUseCase: MockLoginUseCase!
    var cancellables: Set<AnyCancellable>!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        mockUseCase  = MockLoginUseCase()
        sut          = LoginViewModel(loginUseCase: mockUseCase)
        cancellables = []
    }

    override func tearDown() {
        sut          = nil
        mockUseCase  = nil
        cancellables = nil
        super.tearDown()
    }

    // =========================================================
    // MARK: - 🏁 INITIAL STATE
    // =========================================================

    func test_initialState_allPropertiesAreDefault() {
        XCTAssertEqual(sut.email,    "")
        XCTAssertEqual(sut.password, "")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.loginSucceeded)
        XCTAssertNil(sut.generalError)
        XCTAssertNil(sut.alertMessage)
        XCTAssertNil(sut.currentUser)
    }

    // =========================================================
    // MARK: - ✅ isFormValid COMPUTED PROPERTY
    // =========================================================

    func test_isFormValid_falseWhenEmailEmpty() {
        sut.email    = ""
        sut.password = TestDataFactory.validPassword
        XCTAssertFalse(sut.isFormValid)
    }

    func test_isFormValid_falseWhenPasswordLessThan6Chars() {
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.shortPassword  // "123"
        XCTAssertFalse(sut.isFormValid)
    }

    func test_isFormValid_falseWhenBothEmpty() {
        sut.email    = ""
        sut.password = ""
        XCTAssertFalse(sut.isFormValid)
    }

    func test_isFormValid_trueWhenEmailAndPasswordValid() {
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword
        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_trueWhenPasswordExactly6Chars() {
        sut.email    = TestDataFactory.validEmail
        sut.password = "abc123"
        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_falseWhenEmailIsWhitespaceOnly() {
        sut.email    = "   "
        sut.password = TestDataFactory.validPassword
        XCTAssertFalse(sut.isFormValid)
    }

    // =========================================================
    // MARK: - ❌ VALIDATION — login() blocked before UseCase
    //         validateFields() fails → alertMessage set, useCase NOT called
    // =========================================================

    func test_login_withEmptyEmail_setsAlertMessage_doesNotCallUseCase() async {
        // Arrange
        sut.email    = ""
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertNotNil(sut.alertMessage)
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
        XCTAssertFalse(sut.loginSucceeded)
    }

    func test_login_withInvalidEmailFormat_setsAlertMessage() async {
        // Arrange
        sut.email    = TestDataFactory.invalidEmail  // "not-an-email"
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertNotNil(sut.alertMessage)
        XCTAssertEqual(sut.alertMessage?.message, "Enter a valid email address")
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
    }

    func test_login_withEmptyPassword_setsAlertMessage() async {
        // Arrange
        sut.email    = TestDataFactory.validEmail
        sut.password = ""

        // Act
        await sut.login()

        // Assert
        XCTAssertNotNil(sut.alertMessage)
        XCTAssertEqual(sut.alertMessage?.message, "Password is required")
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
    }

    func test_login_withShortPassword_setsAlertMessage() async {
        // Arrange
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.shortPassword  // "123"

        // Act
        await sut.login()

        // Assert
        XCTAssertNotNil(sut.alertMessage)
        XCTAssertEqual(sut.alertMessage?.message, "Password must be at least 6 characters")
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
    }

    func test_login_withBothFieldsEmpty_setsAlertMessage() async {
        // Arrange
        sut.email    = ""
        sut.password = ""

        // Act
        await sut.login()

        // Assert
        XCTAssertNotNil(sut.alertMessage)
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
    }

    // =========================================================
    // MARK: - ✅ LOGIN SUCCESS
    // =========================================================

    func test_login_onSuccess_setsLoginSucceededTrue() async {
        // Arrange
        mockUseCase.stubbedResult = .success(TestDataFactory.makeUser())
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertTrue(sut.loginSucceeded)
    }

    func test_login_onSuccess_setsCurrentUser() async {
        // Arrange
        let expectedUser = TestDataFactory.makeUser()
        mockUseCase.stubbedResult = .success(expectedUser)
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertNotNil(sut.currentUser)
        XCTAssertEqual(sut.currentUser?.uid,   expectedUser.uid)
        XCTAssertEqual(sut.currentUser?.email, expectedUser.email)
    }

    func test_login_onSuccess_clearsGeneralError() async {
        // Arrange — simulate previous error
        sut.generalError = "Previous error"
        mockUseCase.stubbedResult = .success(TestDataFactory.makeUser())
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertNil(sut.generalError)
    }

    func test_login_onSuccess_isLoadingReturnsFalse() async {
        // Arrange
        mockUseCase.stubbedResult = .success(TestDataFactory.makeUser())
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertFalse(sut.isLoading)
    }

    func test_login_callsUseCase_withTrimmedEmail() async {
        // Arrange
        mockUseCase.stubbedResult = .success(TestDataFactory.makeUser())
        sut.email    = "  \(TestDataFactory.validEmail)  "
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert — ViewModel trims before passing to useCase
        XCTAssertEqual(mockUseCase.capturedEmail, TestDataFactory.validEmail)
    }

    // =========================================================
    // MARK: - ❌ LOGIN FAILURE — UseCase errors → generalError
    // =========================================================

    func test_login_onInvalidCredentials_setsGeneralError() async {
        // Arrange
        mockUseCase.stubbedResult = .failure(AuthError.invalidCredentials)
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.wrongPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertFalse(sut.loginSucceeded)
        XCTAssertEqual(sut.generalError, "Incorrect email or password. Please try again.")
        XCTAssertNil(sut.currentUser)
    }

    func test_login_onNetworkUnavailable_setsNetworkError() async {
        // Arrange
        mockUseCase.stubbedResult = .failure(AuthError.networkUnavailable)
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertFalse(sut.loginSucceeded)
        XCTAssertEqual(sut.generalError, "No internet connection. Please check your network.")
    }

    func test_login_onUnknownError_setsLocalizedErrorMessage() async {
        // Arrange
        mockUseCase.stubbedResult = .failure(AuthError.unknown)
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertFalse(sut.loginSucceeded)
        XCTAssertNotNil(sut.generalError)
    }

    func test_login_onFailure_isLoadingReturnsFalse() async {
        // Arrange
        mockUseCase.stubbedResult = .failure(AuthError.invalidCredentials)
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.wrongPassword

        // Act
        await sut.login()

        // Assert — isLoading MUST reset to false even on error
        XCTAssertFalse(sut.isLoading)
    }

    func test_login_onFailure_loginSucceededRemainssFalse() async {
        // Arrange
        mockUseCase.stubbedResult = .failure(AuthError.invalidCredentials)
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.wrongPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertFalse(sut.loginSucceeded)
    }

    // =========================================================
    // MARK: - ⏳ LOADING STATE via Combine
    // =========================================================

    func test_login_isLoading_sequenceIs_false_true_false() async {
        // Arrange — delay so we can observe intermediate state
        mockUseCase.stubbedDelay  = 0.1
        mockUseCase.stubbedResult = .success(TestDataFactory.makeUser())
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        var observed: [Bool] = []
        sut.$isLoading
            .sink { observed.append($0) }
            .store(in: &cancellables)

        // Act
        await sut.login()

        // Assert: initial false → true (loading) → false (done)
        XCTAssertEqual(observed, [false, true, false])
    }

    // =========================================================
    // MARK: - 📡 @Published Combine Expectations
    // =========================================================

    func test_loginSucceeded_publishesTrue_onSuccess() async {
        // Arrange
        mockUseCase.stubbedResult = .success(TestDataFactory.makeUser())
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        let expectation = XCTestExpectation(description: "loginSucceeded becomes true")

        sut.$loginSucceeded
            .dropFirst()
            .filter { $0 == true }
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        // Act
        await sut.login()

        // Assert
       wait(for: [expectation], timeout: 2.0)
    }

    func test_generalError_publishesValue_onFailure() async {
        // Arrange
        mockUseCase.stubbedResult = .failure(AuthError.invalidCredentials)
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.wrongPassword

        let expectation = XCTestExpectation(description: "generalError published")

        sut.$generalError
            .dropFirst()
            .compactMap { $0 }
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        // Act
        await sut.login()

        // Assert
       wait(for: [expectation], timeout: 2.0)
    }

    // =========================================================
    // MARK: - 🔁 UseCase Interaction Count
    // =========================================================

    func test_login_callsUseCase_exactlyOnce_perTap() async {
        // Arrange
        mockUseCase.stubbedResult = .success(TestDataFactory.makeUser())
        sut.email    = TestDataFactory.validEmail
        sut.password = TestDataFactory.validPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    func test_login_doesNotCallUseCase_whenValidationFails() async {
        // Arrange — invalid state
        sut.email    = TestDataFactory.invalidEmail
        sut.password = TestDataFactory.shortPassword

        // Act
        await sut.login()

        // Assert
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
    }
}

// =========================================================
// MARK: - MockLoginUseCase
//
// LoginUseCaseProtocol ka in-memory mock.
// Firebase ya network touch nahi karta.
// =========================================================

final class MockLoginUseCase: LoginUseCaseProtocol {

    // Stubs
    var stubbedResult: Result<User, Error> = .failure(AuthError.unknown)
    var stubbedDelay:  TimeInterval        = 0.0

    // Trackers
    private(set) var executeCallCount: Int    = 0
    private(set) var capturedEmail:    String?
    private(set) var capturedPassword: String?

    func execute(email: String, password: String) async throws -> User {
        capturedEmail    = email
        capturedPassword = password
        executeCallCount += 1

        if stubbedDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(stubbedDelay * 1_000_000_000))
        }

        switch stubbedResult {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }
}
