//
//  LoginBackgroundView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct ResetPasswordBackgroundView: View {
	var body: some View {
		ZStack {
			Color.blue.ignoresSafeArea()
			GeometryReader { geometry in
				let hGutter = 16.0
				let hSpacing = (geometry.size.height - hGutter * 3) / 4
				
				let firstCirclePosition = CGPoint(
					x: geometry.size.width / 2,
					y: hSpacing - 12
				)
				let firstCircleRadius = 1.5 * hSpacing + 2 * hGutter
				
				let secondCircleRadius = firstCircleRadius
				
				let secondCirclePosition = CGPoint(
					x: geometry.size.width / 2,
					y: geometry.size.height + secondCircleRadius - hSpacing
				)
				
				ZStack {
					Circle()
						.fill(.white)
						.frame(width: firstCircleRadius * 2, height: firstCircleRadius * 2)
						.position(firstCirclePosition)
					Circle()
						.fill(.white)
						.frame(width: secondCircleRadius * 2, height: secondCircleRadius * 2)
						.position(secondCirclePosition)
				}
			}.ignoresSafeArea()
		}
	}
}

#Preview {
	ResetPasswordBackgroundView()
}
