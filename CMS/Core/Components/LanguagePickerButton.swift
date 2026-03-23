import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
	case vietnamese = "vi"
	case english = "en"
	case japanese = "ja"

	var id: String { rawValue }

	var displayName: String {
		switch self {
		case .vietnamese:
			return "Tiếng Việt"
		case .english:
			return "English"
		case .japanese:
			return "日本語"
		}
	}

	var flag: String {
		switch self {
		case .vietnamese:
			return "🇻🇳"
		case .english:
			return "🇺🇸"
		case .japanese:
			return "🇯🇵"
		}
	}

	var isAvailable: Bool {
		switch self {
		case .vietnamese:
			return true
		case .english, .japanese:
			return false
		}
	}

	var menuTitle: String {
		if isAvailable {
			return "\(flag) \(displayName)"
		}

		return "\(flag) \(displayName) (Sắp có)"
	}
}

struct LanguagePickerButton: View {
	@AppStorage("preferred_language_code")
	private var preferredLanguageCode = AppLanguage.vietnamese.rawValue

	private var selectedLanguage: AppLanguage {
		AppLanguage(rawValue: preferredLanguageCode) ?? .vietnamese
	}

	var body: some View {
		Menu {
			ForEach(AppLanguage.allCases) { language in
				Button {
					preferredLanguageCode = language.rawValue
				} label: {
					Text(language.menuTitle)
				}
				.disabled(!language.isAvailable)
			}
		} label: {
			ZStack(alignment: .bottomTrailing) {
				LanguageFlagIcon(language: selectedLanguage)

				Circle()
					.fill(.white)
					.frame(width: 14, height: 14)
					.overlay {
						Image(systemName: "chevron.down")
							.font(.system(size: 7, weight: .bold))
							.foregroundStyle(Color.blue.opacity(0.75))
					}
					.offset(x: 1, y: 1)
			}
			.frame(width: 40, height: 40)
			.contentShape(Circle())
		}
		.accessibilityLabel(Text("Ngôn ngữ"))
		.accessibilityValue(Text(selectedLanguage.displayName))
		.accessibilityHint(Text("Mở danh sách ngôn ngữ"))
	}
}

private struct LanguageFlagIcon: View {
	let language: AppLanguage

	var body: some View {
		ZStack {
			switch language {
			case .vietnamese:
				Color(red: 0.85, green: 0.11, blue: 0.16)
				StarShape()
					.fill(Color(red: 1, green: 0.86, blue: 0.12))
					.padding(10)
			case .english:
				AmericanFlagBackground()
			case .japanese:
				Color.white
				Circle()
					.fill(Color(red: 0.74, green: 0.1, blue: 0.19))
					.padding(10)
			}
		}
		.frame(width: 40, height: 40)
		.clipShape(Circle())
		.overlay(
			Circle()
				.stroke(.white.opacity(0.78), lineWidth: 1)
		)
		.shadow(color: .black.opacity(0.08), radius: 10, y: 4)
	}
}

private struct AmericanFlagBackground: View {
	var body: some View {
		GeometryReader { geometry in
			let stripeCount = 7
			let stripeHeight = geometry.size.height / CGFloat(stripeCount)
			let cantonWidth = geometry.size.width * 0.54
			let cantonHeight = geometry.size.height * 0.52

			ZStack(alignment: .topLeading) {
				VStack(spacing: 0) {
					ForEach(0..<stripeCount, id: \.self) { index in
						Rectangle()
							.fill(index.isMultiple(of: 2) ? Color(red: 0.72, green: 0.08, blue: 0.14) : .white)
							.frame(height: stripeHeight)
					}
				}

				Rectangle()
					.fill(Color(red: 0.11, green: 0.23, blue: 0.56))
					.frame(width: cantonWidth, height: cantonHeight)
					.overlay {
						VStack(spacing: 3) {
							ForEach(0..<3, id: \.self) { _ in
								HStack(spacing: 3) {
									ForEach(0..<4, id: \.self) { _ in
										Circle()
											.fill(.white.opacity(0.95))
											.frame(width: 2.6, height: 2.6)
									}
								}
							}
						}
					}
			}
		}
	}
}

private struct StarShape: Shape {
	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let outerRadius = min(rect.width, rect.height) / 2
		let innerRadius = outerRadius * 0.42
		let adjustment = -CGFloat.pi / 2

		var path = Path()

		for index in 0..<10 {
			let angle = (CGFloat(index) * .pi / 5) + adjustment
			let radius = index.isMultiple(of: 2) ? outerRadius : innerRadius
			let point = CGPoint(
				x: center.x + cos(angle) * radius,
				y: center.y + sin(angle) * radius
			)

			if index == 0 {
				path.move(to: point)
			} else {
				path.addLine(to: point)
			}
		}

		path.closeSubpath()
		return path
	}
}
