//
//  LoginBodyView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct ResetPasswordBodyView: View {
	@ObservedObject var store: ResetPasswordStore
	
	@EnvironmentObject
	private var router: AppRouter
	
	var body: some View {
		VStack(spacing: 16) {
			ResetPasswordFormView(store: store)
		}
		.padding(16)
		.frame(maxWidth: .infinity)
		.background(.regularMaterial)
		.cornerRadius(32)
	}
}

struct ResetPasswordFormView: View {
	@ObservedObject var store: ResetPasswordStore
	
	@EnvironmentObject
	private var router: AppRouter
	
	var loggedAccountName: String? {
		store.state.loggedAccountName
	}
	
	var submitButtonLabel: String {
		switch store.state.step {
			case .submitUsername: return "Tiếp tục";
			case .submitNewPassword: return "Đổi mật khẩu"
		}
	}
	
	var body: some View {
		VStack(spacing: 8) {
			UserAvatarView(avatarURL: store.state.avatarURL, size: 96)
			if loggedAccountName != nil {
				HStack(spacing: 4) {
					Text(loggedAccountName!)
						.font(.title2).bold()
					Button {
						router.pushReplacement(to: .changeAccount)
					} label: {
						Image(systemName: "arrow.triangle.2.circlepath")
					}
				}
			}
		}
		VStack(spacing: 8) {
			TextField("Email hoặc MSSV", text: $store.state.username)
				.textInputAutocapitalization(.never)
				.autocorrectionDisabled()
				.frame(height: 40)
			if store.state.step == .submitNewPassword {
				VStack(spacing: 8) {
					SecureField("Mã xác thực", text: $store.state.verificationCode).frame(height: 40)
					SecureField("Mật khẩu", text: $store.state.password)
						.frame(height: 40)
					SecureField("Nhập lại mật khẩu", text: $store.state.passwordConfirmation)
						.frame(height: 40)
				}
			}
			Button(submitButtonLabel) {
				store.submitStep()
			}
			.buttonStyle(.borderedProminent)
			.disabled(store.state.status.isLoading)
		}
	}
}
