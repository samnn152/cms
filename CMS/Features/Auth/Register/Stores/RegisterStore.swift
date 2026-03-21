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
		state.status = .loading
	}
}
