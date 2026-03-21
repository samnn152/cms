import SwiftUI

struct RegisterView: View {
	@StateObject
	private var store: RegisterStore
	
	init() {
		_store = .init(wrappedValue: RegisterStore(
			authService: MockAuthService(),
		))
	}
	
	var body: some View {
		ZStack {
			RegisterBackgroundView()
			VStack(alignment: .leading, spacing: 16) {
				RegisterHeaderView(store: store)
				RegisterBodyView(store: store)
			}.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.padding(.horizontal, 16)
		}
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
	RegisterView()
}
