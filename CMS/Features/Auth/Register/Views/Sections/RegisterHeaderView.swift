//
//  HeaderView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct RegisterHeaderView: View {
	@ObservedObject var store: RegisterStore
	
	@EnvironmentObject
	private var router: AppRouter
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack {
				Image("ImageLogoFull")
				Spacer()
				LanguagePickerButton()
			}
			VStack(alignment: .leading) {
				HStack {
					Button {
						router.pop()
					} label: {
						Image(systemName: "chevron.left")
					}
					Text("Đăng ký")
						.font(.largeTitle)
						.bold()
				}
				Text("Để trở thành GDGOC Huster ngay hôm nay")
					.font(.body)
			}
		}.frame(minHeight: 144)
	}
}
