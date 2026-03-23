//
//  LoginBodyView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct LoginBodyView: View {
	@ObservedObject var store: LoginStore
	
	@EnvironmentObject
	private var router: AppRouter
	
	var body: some View {
		VStack(spacing: 16) {
			switch router.current {
			case .login:
				LoginFormView(store: store)
			case .changeAccount:
				LoginChangeAccountView(store: store)
			default:
				EmptyView()
			}
		}
		.padding(16)
		.frame(maxWidth: .infinity)
		.background(.regularMaterial)
		.clipShape(RoundedCorner(radius: 32, corners: [.topRight, .bottomLeft]))
	}
}

struct LoginFormView: View {
	@ObservedObject var store: LoginStore
	
	@EnvironmentObject
	private var router: AppRouter

	@Environment(\.openURL)
	private var openURL
	
	var loggedAccountName: String? {
		store.state.loggedAccountName
	}
	
	var body: some View {
		VStack(spacing: 20) {
			VStack(spacing: 8) {
				UserAvatarView(avatarURL: store.state.avatarURL, size: 96)
				if let loggedAccountName {
					HStack(spacing: 4) {
						Text(loggedAccountName)
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
				if loggedAccountName == nil {
					TextField("Email hoặc MSSV", text: $store.state.username)
						.textInputAutocapitalization(.never)
						.autocorrectionDisabled()
						.frame(height: 40)
				}
				SecureField("Mật khẩu", text: $store.state.password)
					.frame(height: 40)
				HStack {
					Button("Đăng nhập") {
						store.login()
					}
					.buttonStyle(.borderedProminent)
					.disabled(store.state.status.isLoading)

					Spacer()

					Button("Quên mật khẩu") {
						router.push(to: .forgotPassword)
					}
				}
			}

			VStack(spacing: 8) {
				Text("Hoặc đăng nhập bằng")
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

struct LoginChangeAccountView: View {
	@ObservedObject var store: LoginStore
	
	@StateObject
	private var savedUserListStore: SavedUserListStore = SavedUserListStore(
	  savedUsersService: LocalSavedUsersService()
	)
	
	@EnvironmentObject
	private var router: AppRouter
	
	var body: some View {
		VStack {
			Text("Chọn tài khoản")
			LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
				ForEach(savedUserListStore.state.data) { user in
					HStack {
						Button {
							store.changeAccount(user: user)
							router.pushReplacement(to: .login)
						} label: {
							VStack {
								UserAvatarView(avatarURL: user.avatarURL, size: 48)
								Text(user.displayName)
							}
						}
						Spacer()
						Button {
							savedUserListStore.delete(user: user)
						} label: {
							Image(systemName: "trash")
								.foregroundColor(.red)
						}
						.buttonStyle(.borderless)
					}
				}
			}
		}
	}
}
