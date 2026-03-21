import SwiftUI

struct ResetPasswordView: View {
	@StateObject
	private var store: ResetPasswordStore
	
	@EnvironmentObject
	private var router: AppRouter
	
	init() {
		_store = .init(wrappedValue: ResetPasswordStore(
			authService: MockAuthService()
		))
	}
	
	var body: some View {
		ZStack {
			ResetPasswordBackgroundView()
			VStack(alignment: .leading, spacing: 16) {
				ResetPasswordHeaderView(store: store)
				ResetPasswordBodyView(store: store)
			}.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.padding(.horizontal, 16)
		}
	}
}

#Preview {
	ResetPasswordView()
}
