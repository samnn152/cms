//
//  LoginStore.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//
import Foundation
internal import Combine

final class ResetPasswordStore : ObservableObject {
	private let authService: AuthServiceProtocol
	
	@Published var state = ResetPasswordState()
	
	init(authService: AuthServiceProtocol) {
		self.authService = authService
	}
	
	func submitStep() {
		switch self.state.step {
			case .submitUsername:
				requestResetPassword()
			case .submitNewPassword:
				submitNewPassword()
		}
	}
	
	private func requestResetPassword() {
		let identifier = state.username.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !identifier.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập email hoặc MSSV.")
			return
		}

		state.status = .loading

		authService.requestPasswordReset(identifier: identifier) { [weak self] result in
			switch result {
			case .success:
				self?.state.status = .idle
				self?.state.step = .submitNewPassword
			case let .failure(error):
				self?.state.status = .error(code: 1, message: self?.errorMessage(for: error) ?? error.fallbackMessage)
			}
		}
	}
	
	private func submitNewPassword() {
		let identifier = state.username.trimmingCharacters(in: .whitespacesAndNewlines)
		let verificationCode = state.verificationCode.trimmingCharacters(in: .whitespacesAndNewlines)

		guard !identifier.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập email hoặc MSSV.")
			return
		}

		guard !verificationCode.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập mã xác thực.")
			return
		}

		guard !state.password.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập mật khẩu mới.")
			return
		}

		guard state.password.count >= 8 else {
			state.status = .error(code: 1, message: "Mật khẩu mới cần ít nhất 8 ký tự.")
			return
		}

		guard state.password == state.passwordConfirmation else {
			state.status = .error(code: 1, message: "Mật khẩu nhập lại không khớp.")
			return
		}

		state.status = .loading

		authService.resetPassword(identifier: identifier, verificationCode: verificationCode, newPassword: state.password) { [weak self] result in
			switch result {
			case let .success(user):
				self?.state.loggedAccountName = user.displayName
				self?.state.avatarURL = user.avatarURL
				self?.state.status = .success
			case let .failure(error):
				self?.state.status = .error(code: 1, message: self?.errorMessage(for: error) ?? error.fallbackMessage)
			}
		}
	}

	private func errorMessage(for error: AuthError) -> String {
		switch error {
		case .invalidCredentials:
			return "Mã xác thực không hợp lệ."
		default:
			return error.fallbackMessage
		}
	}
}
