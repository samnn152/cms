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
	
	var loggedAccountName: String? {
		store.state.loggedAccountName
	}
	
	var body: some View {
		VStack(spacing: 8) {
			Circle()
				.frame(width: 96, height: 96)
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
			if loggedAccountName == nil {
				TextField("Tên đăng nhập", text: $store.state.username)
					.frame(height: 40)
			}
			SecureField("Mật khẩu", text: $store.state.password)
				.frame(height: 40)
			HStack {
				Button("Đăng nhập") {
					
				}.buttonStyle(.borderedProminent)
				Spacer()
				Button("Quên mật khẩu") {
					router.push(to: .forgotPassword)
				}
			}
		}
		VStack(spacing: 8){
			Text("Hoặc đăng nhập bằng")
				.font(.callout)
			HStack(spacing: 16) {
				Circle().frame(width: 48, height: 48)
				Circle().frame(width: 48, height: 48)
				Circle().frame(width: 48, height: 48)
			}
		}
	}
}

struct LoginChangeAccountView: View {
	@ObservedObject var store: LoginStore
	
	@StateObject
	private var savedUserListStore: SavedUserListStore = SavedUserListStore(
	  savedUsersService: MockSavedUsersService()
	)
	
	@EnvironmentObject
	private var router: AppRouter
	
	var body: some View {
		VStack {
			Text("Chọn tài khoản")
			LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
				ForEach(savedUserListStore.state.data) { user in
					Button {
						store.changeAccount(user: user)
						router.pushReplacement(to: .login)
					} label: {
						VStack {
							Circle().frame(width: 48, height: 48)
							Text(user.displayName)
						}
					}
				}
			}
		}
	}
}
