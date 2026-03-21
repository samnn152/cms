import SwiftUI

struct LoginView: View {
	@StateObject
	private var store: LoginStore
	
	init() {
		_store = .init(wrappedValue: LoginStore(
			authService: MockAuthService(),
			savedUsersService: MockSavedUsersService()
		))
	}
	
	var body: some View {
		ZStack {
			LoginBackgroundView()
			VStack(alignment: .leading, spacing: 16) {
				LoginHeaderView(store: store)
				LoginBodyView(store: store)
				LoginFooterView()
			}.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.padding(.horizontal, 16)
		}
	}
}

#Preview {
	LoginView()
}
