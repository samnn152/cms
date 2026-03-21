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
	
	var body: some View {
		VStack(spacing: 8) {
			Circle()
				.frame(width: 96, height: 96)
			TextField("Email", text: $store.state.email)
				.frame(height: 40)
			TextField("MSSV (Không bắt buộc)", text: $store.state.studentID)
				.frame(height: 40)
			SecureField("Mật khẩu", text: $store.state.password)
				.frame(height: 40)
			SecureField("Nhập lại mật khẩu", text: $store.state.confirmPassword)
				.frame(height: 40)
			Button("Đăng ký") {
				
			}.buttonStyle(.borderedProminent)
		}
		VStack(spacing: 8){
			Text("Hoặc đăng ký bằng")
				.font(.callout)
			HStack(spacing: 16) {
				Circle().frame(width: 48, height: 48)
				Circle().frame(width: 48, height: 48)
				Circle().frame(width: 48, height: 48)
			}
		}
	}
}
