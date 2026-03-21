//
//  HeaderView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct LoginHeaderView: View {
	@ObservedObject var store: LoginStore
	
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
				Text("Đăng nhập")
					.font(.largeTitle)
					.bold()
				Text(store.state.loggedAccountName != nil ? "Chào mừng quay trở lại": "Đã là GDGOC Huster?")
					.font(.body)
			}
		}.frame(minHeight: 144)
	}
}
