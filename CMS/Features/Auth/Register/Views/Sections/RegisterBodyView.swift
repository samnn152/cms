//
//  LoginBodyView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct RegisterBodyView: View {
	@ObservedObject var store: RegisterStore
	
	@EnvironmentObject
	private var router: AppRouter
	
	var body: some View {
		VStack(spacing: 16) {
			RegisterFormView(store: store)
		}
		.padding(16)
		.frame(maxWidth: .infinity)
		.background(.regularMaterial)
		.clipShape(RoundedCorner(radius: 32, corners: [.topRight, .bottomLeft]))
	}
}

struct RegisterFormView: View {
	@ObservedObject var store: RegisterStore
	
	@EnvironmentObject
	private var router: AppRouter

	@Environment(\.openURL)
	private var openURL
	
	var body: some View {
		VStack(spacing: 20) {
			VStack(spacing: 8) {
				UserAvatarView(avatarURL: nil, size: 96)
				TextField("Email", text: $store.state.email)
					.textInputAutocapitalization(.never)
					.autocorrectionDisabled()
					.frame(height: 40)
				TextField("MSSV (Không bắt buộc)", text: $store.state.studentID)
					.textInputAutocapitalization(.never)
					.autocorrectionDisabled()
					.frame(height: 40)
				SecureField("Mật khẩu", text: $store.state.password)
					.frame(height: 40)
				SecureField("Nhập lại mật khẩu", text: $store.state.confirmPassword)
					.frame(height: 40)
				Button("Đăng ký") {
					store.register()
				}
				.buttonStyle(.borderedProminent)
				.disabled(store.state.status.isLoading)
			}

			VStack(spacing: 8) {
				Text("Hoặc đăng ký bằng")
					.font(.callout)
				SocialAuthButtonsRow { provider in
					openSocialLogin(provider)
				}
			}
		}
	}

	private func openSocialLogin(_ provider: SocialProvider) {
		guard let url = APIAuthService.makeOAuthStartURL(for: provider) else {
			return
		}

		openURL(url)
	}
}
