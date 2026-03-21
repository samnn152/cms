//
//  HeaderView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct ResetPasswordHeaderView: View {
	@ObservedObject var store: ResetPasswordStore
	
	@EnvironmentObject
	private var router: AppRouter
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack {
				Image("ImageLogoFull")
				Spacer()
				Circle()
					.fill(.gray)
					.frame(width: 40, height: 40)
			}
			VStack(alignment: .leading) {
				HStack {
					Button {
						router.pop()
					} label: {
						Image(systemName: "chevron.left")
					}
					Text("Quên mật khẩu")
						.font(.largeTitle)
						.bold()
				}
				Text("Nhập mật khẩu mới và xác thực")
					.font(.body)
			}
		}.frame(minHeight: 144)
	}
}
