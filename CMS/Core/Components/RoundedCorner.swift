//
//  RoundedCorner.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 21/2/26.
//
import SwiftUI

struct RoundedCorner: Shape {
		var radius: CGFloat
		var corners: UIRectCorner

		func path(in rect: CGRect) -> Path {
				let path = UIBezierPath(
						roundedRect: rect,
						byRoundingCorners: corners,
						cornerRadii: CGSize(width: radius, height: radius)
				)
				return Path(path.cgPath)
		}
}
