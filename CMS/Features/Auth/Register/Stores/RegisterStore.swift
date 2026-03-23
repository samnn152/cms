//
//  LoginStore.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//
import Foundation
internal import Combine

final class RegisterStore : ObservableObject {
	private let authService: AuthServiceProtocol
	
	@Published var state: RegisterState = RegisterState()
	
	init(authService: AuthServiceProtocol) {
		self.authService = authService
	}
	
	func register() {
		let email = state.email.trimmingCharacters(in: .whitespacesAndNewlines)
		let studentID = state.studentID.trimmingCharacters(in: .whitespacesAndNewlines)

		guard !email.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập email.")
			return
		}

		guard !state.password.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập mật khẩu.")
			return
		}

		guard state.password.count >= 8 else {
			state.status = .error(code: 1, message: "Mật khẩu cần ít nhất 8 ký tự.")
			return
		}

		guard state.password == state.confirmPassword else {
			state.status = .error(code: 1, message: "Mật khẩu nhập lại không khớp.")
			return
		}

		state.status = .loading

		authService.register(
			email: email,
			studentID: studentID.isEmpty ? nil : studentID,
			password: state.password
		) { [weak self] result in
			switch result {
			case .success:
				self?.state.status = .success
			case let .failure(error):
				self?.state.status = .error(code: 1, message: self?.errorMessage(for: error) ?? error.fallbackMessage)
			}
		}
	}

	private func errorMessage(for error: AuthError) -> String {
		switch error {
		case let .unknown(code, _) where code == 409:
			return "Email này đã được sử dụng."
		default:
			return error.fallbackMessage
		}
	}
}
