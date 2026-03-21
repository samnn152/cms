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
	
	func submitStep() async {
		switch self.state.step {
			case .submitUsername:
				await self.requestResetPassword()
				state.step = .submitNewPassword
			case .submitNewPassword:
				await self.submitNewPassword()
		}
	}
	
	private func requestResetPassword() async {
		
	}
	
	private func submitNewPassword() async {
		
	}
}
