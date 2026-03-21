//
//  LoginBackgroundView.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct LoginBackgroundView: View {
	var body: some View {
		ZStack {
			Color.blue.ignoresSafeArea()
			GeometryReader { geometry in
				let hGutter = 16.0
				let hSpacing = (geometry.size.height - hGutter * 3) / 4
				let wGutter = 16.0
				let wSpacing = (geometry.size.width - wGutter * 4) / 3
				
				let firstCirclePosition = CGPoint(
					x: 0,
					y: hSpacing
				)
				let firstCircleRadius = 1.5 * hSpacing + 2 * hGutter
				
				let secondCirclePosition = CGPoint(
					x: 3 * wGutter + 2 * wSpacing,
					y: geometry.size.height
				)
				let secondCircleRadius = 1.5 * hSpacing + hGutter
				
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
	LoginBackgroundView()
}
