//
//  SplashView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//
import SwiftUI
import NavigationStackBackport

struct SplashView: View {
	@EnvironmentObject
	private var router: AppRouter
	
	@State
	private var isLoaded: Bool = false
	
	var body: some View {
		ZStack {
			if !router.initialized {
				ZStack {
						GeometryReader {geometry in
							let radius = (geometry.size.height - 48) * 0.75 + 32 + 5
								return Circle()
									.fill(.blue)
									.frame(width: radius * 2, height: radius * 2)
									.position(x: geometry.size.width / 2, y: geometry.size.height)
						}.ignoresSafeArea()
						VStack {
							Image("ImageLogoFull").frame(height: 40)
						}.frame(maxHeight: .infinity, alignment: .top)
					}.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
							router.go(to: .login)
						}
					}
			}
			else {
				EmptyView()
			}
		}
	}
}

#Preview {
	SplashView()
}
