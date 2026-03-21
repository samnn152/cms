//
//  FooterView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct LoginFooterView: View {
	@EnvironmentObject
	private var router: AppRouter

	var body: some View {
		HStack {
			Text("Chưa có tài khoản")
			Button("Đăng ký") {
				router.push(to: .register)
			}
		}.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .bottom))
		.lineLimit(nil)
			.multilineTextAlignment(.leading)
	}
}
