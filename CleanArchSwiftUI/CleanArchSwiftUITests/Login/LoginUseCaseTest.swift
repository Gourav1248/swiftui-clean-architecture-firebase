//
//  LoginUseCaseTest.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 25/05/26.
//
//  WHAT IS TESTED: LoginUseCase — pure business logic layer
//  NO ViewModel, NO Firebase, NO UI
//
//  TEST NAMING CONVENTION:
//  test_[method]_[condition]_[expectedResult]
//

import XCTest
@testable import CleanArchSwiftUI

final class LoginUseCaseTest: XCTestCase {

    // MARK: - System Under Test
    var sut: LoginUseCase!
    var mockRepository: MockAuthRepository!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        mockRepository = MockAuthRepository()
        sut = LoginUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // =========================================================
    // MARK: - ✅ SUCCESS CASES
    // =========================================================

    /// Valid email + valid password → repository called → User returned
    func test_execute_withValidCredentials_returnsUser() async throws {
        // Arrange
        let expectedUser = TestDataFactory.makeUser()
        mockRepository.stubbedSignInResult = .success(expectedUser)

        // Act
        let result = try await sut.execute(
            email: TestDataFactory.validEmail,
            password: TestDataFactory.validPassword
        )

        // Assert
        XCTAssertEqual(result.uid,   expectedUser.uid)
        XCTAssertEqual(result.email, expectedUser.email)
    }

    /// UseCase should trim whitespace before passing to repository
    func test_execute_trimsEmailWhitespace_beforeCallingRepository() async throws {
        // Arrange
        mockRepository.stubbedSignInResult = .success(TestDataFactory.makeUser())
        let emailWithSpaces = "  \(TestDataFactory.validEmail)  "

        // Act
        _ = try await sut.execute(email: emailWithSpaces, password: TestDataFactory.validPassword)

        // Assert — repository ko trimmed email milni chahiye
        XCTAssertEqual(mockRepository.capturedSignInEmail, TestDataFactory.validEmail)
    }

    /// Repository exactly once call hona chahiye
    func test_execute_callsRepository_exactlyOnce() async throws {
        // Arrange
        mockRepository.stubbedSignInResult = .success(TestDataFactory.makeUser())

        // Act
        _ = try await sut.execute(
            email: TestDataFactory.validEmail,
            password: TestDataFactory.validPassword
        )

        // Assert
        XCTAssertEqual(mockRepository.signInCallCount, 1)
    }

    /// Correct credentials repository ko pass hone chahiye
    func test_execute_passesCorrectCredentials_toRepository() async throws {
        // Arrange
        mockRepository.stubbedSignInResult = .success(TestDataFactory.makeUser())

        // Act
        _ = try await sut.execute(
            email: TestDataFactory.validEmail,
            password: TestDataFactory.validPassword
        )

        // Assert
        XCTAssertEqual(mockRepository.capturedSignInEmail,    TestDataFactory.validEmail)
        XCTAssertEqual(mockRepository.capturedSignInPassword, TestDataFactory.validPassword)
    }

    // =========================================================
    // MARK: - ❌ VALIDATION FAILURES (UseCase guard block)
    //         Repository ko call NAHI karna chahiye
    // =========================================================

    /// Empty email → throws invalidCredentials, repository NOT called
    func test_execute_withEmptyEmail_throwsInvalidCredentials() async {
        // Arrange — no stub needed, guard fires first

        do {
            _ = try await sut.execute(email: "", password: TestDataFactory.validPassword)
            XCTFail("Expected AuthError.invalidCredentials to be thrown")
        } catch let error as AuthError {
            // Assert error type
            XCTAssertEqual(error, AuthError.invalidCredentials)
            // Assert repository NOT called
            XCTAssertEqual(mockRepository.signInCallCount, 0)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    /// Whitespace-only email → same as empty after trim
    func test_execute_withWhitespaceOnlyEmail_throwsInvalidCredentials() async {
        do {
            _ = try await sut.execute(email: "   ", password: TestDataFactory.validPassword)
            XCTFail("Expected error")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.invalidCredentials)
            XCTAssertEqual(mockRepository.signInCallCount, 0)
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }

    /// Empty password → throws invalidCredentials, repository NOT called
    func test_execute_withEmptyPassword_throwsInvalidCredentials() async {
        do {
            _ = try await sut.execute(email: TestDataFactory.validEmail, password: "")
            XCTFail("Expected AuthError.invalidCredentials")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.invalidCredentials)
            XCTAssertEqual(mockRepository.signInCallCount, 0)
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }

    /// Both empty → throws invalidCredentials
    func test_execute_withBothFieldsEmpty_throwsInvalidCredentials() async {
        do {
            _ = try await sut.execute(email: "", password: "")
            XCTFail("Expected error")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.invalidCredentials)
            XCTAssertEqual(mockRepository.signInCallCount, 0)
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }

    // =========================================================
    // MARK: - ❌ REPOSITORY / NETWORK FAILURES
    //         UseCase should propagate these errors as-is
    // =========================================================

    /// Repository throws invalidCredentials (wrong password from Firebase)
    func test_execute_whenRepositoryThrowsInvalidCredentials_propagatesError() async {
        // Arrange
        mockRepository.stubbedSignInResult = .failure(AuthError.invalidCredentials)

        do {
            _ = try await sut.execute(
                email: TestDataFactory.validEmail,
                password: TestDataFactory.wrongPassword
            )
            XCTFail("Expected error")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.invalidCredentials)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    /// Repository throws networkUnavailable
    func test_execute_whenRepositoryThrowsNetworkError_propagatesError() async {
        // Arrange
        mockRepository.stubbedSignInResult = .failure(AuthError.networkUnavailable)

        do {
            _ = try await sut.execute(
                email: TestDataFactory.validEmail,
                password: TestDataFactory.validPassword
            )
            XCTFail("Expected network error")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.networkUnavailable)
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }

    /// Repository throws unknown error
    func test_execute_whenRepositoryThrowsUnknownError_propagatesError() async {
        // Arrange
        mockRepository.stubbedSignInResult = .failure(AuthError.unknown)

        do {
            _ = try await sut.execute(
                email: TestDataFactory.validEmail,
                password: TestDataFactory.validPassword
            )
            XCTFail("Expected error")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.unknown)
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }

    // =========================================================
    // MARK: - 🔁 REPEATED CALLS
    // =========================================================

    /// Multiple successful calls — each should work independently
    func test_execute_calledMultipleTimes_eachCallSucceeds() async throws {
        // Arrange
        mockRepository.stubbedSignInResult = .success(TestDataFactory.makeUser())

        // Act
        _ = try await sut.execute(email: TestDataFactory.validEmail, password: TestDataFactory.validPassword)
        _ = try await sut.execute(email: TestDataFactory.validEmail, password: TestDataFactory.validPassword)

        // Assert
        XCTAssertEqual(mockRepository.signInCallCount, 2)
    }
}
