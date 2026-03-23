import SwiftUI

enum SocialProvider: String, CaseIterable, Identifiable {
	case google
	case apple
	case facebook

	var id: String { rawValue }

	var displayName: String {
		switch self {
		case .google:
			return "Google"
		case .apple:
			return "Apple"
		case .facebook:
			return "Facebook"
		}
	}

	var backendProvider: String { rawValue }
}

struct SocialAuthButtonsRow: View {
	let action: (SocialProvider) -> Void

	var body: some View {
		HStack(spacing: 16) {
			ForEach(SocialProvider.allCases) { provider in
				SocialAuthButton(provider: provider) {
					action(provider)
				}
			}
		}
	}
}

struct SocialAuthButton: View {
	let provider: SocialProvider
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			providerMark
				.frame(width: 48, height: 48)
		}
		.buttonStyle(.plain)
		.accessibilityLabel(Text(provider.displayName))
	}

	@ViewBuilder
	private var providerMark: some View {
		switch provider {
		case .google:
			ZStack {
				Circle()
					.fill(.white)
					.shadow(color: .black.opacity(0.08), radius: 8, y: 3)
				Image("SocialGoogleLogo")
					.resizable()
					.scaledToFit()
					.padding(11)
			}
		case .apple:
			ZStack {
				Circle()
					.fill(.white)
					.shadow(color: .black.opacity(0.12), radius: 8, y: 3)
				Image("SocialAppleLogo")
					.resizable()
					.scaledToFit()
					.padding(11)
			}
		case .facebook:
			Image("SocialFacebookLogo")
				.resizable()
				.scaledToFit()
				.shadow(color: .black.opacity(0.12), radius: 8, y: 3)
		}
	}
}
