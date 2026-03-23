import SwiftUI

struct UserAvatarView: View {
	let avatarURL: String?
	var size: CGFloat

	private var imageURL: URL? {
		guard let avatarURL else {
			return nil
		}

		let trimmedURL = avatarURL.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmedURL.isEmpty else {
			return nil
		}

		return URL(string: trimmedURL)
	}

	var body: some View {
		ZStack {
			Circle()
				.fill(
					LinearGradient(
						colors: [.white.opacity(0.96), .blue.opacity(0.18)],
						startPoint: .top,
						endPoint: .bottom
					)
				)

			if let imageURL {
				AsyncImage(url: imageURL) { phase in
					switch phase {
					case let .success(image):
						image
							.resizable()
							.scaledToFill()
					default:
						placeholderIcon
					}
				}
			} else {
				placeholderIcon
			}
		}
		.frame(width: size, height: size)
		.clipShape(Circle())
		.overlay(
			Circle()
				.stroke(.white.opacity(0.65), lineWidth: 1)
		)
		.shadow(color: .black.opacity(0.08), radius: 10, y: 4)
	}

	private var placeholderIcon: some View {
		Image(systemName: "person.fill")
			.resizable()
			.scaledToFit()
			.foregroundStyle(Color.blue.opacity(0.55))
			.padding(size * 0.28)
	}
}
