import SwiftUI

struct SplashView: View {
    @State private var logoOffset: CGFloat = 0
    @State private var showAuthView = false
    @EnvironmentObject var appStateManager: AppStateManager

    var body: some View {
        ZStack {
            Color.splash.ignoresSafeArea()

            if showAuthView {
                AuthView(
                    interactor: configureAuthInteractor(),
                    presenter: AuthPresenter()
                )
                .transition(.opacity)
                .zIndex(1)
            }

            if !showAuthView {
                Image("TopPizzaSplashLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 322, height: 103)
                    .offset(y: logoOffset)
                    .transition(.opacity)
                    .onAppear {
                        animateSplash()
                    }
            }
        }
    }

    private func animateSplash() {
        withAnimation(.easeOut(duration: 1.35)) {
            logoOffset = -UIScreen.main.bounds.height / 6.5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeInOut(duration: 2.5)) {
                showAuthView = true
            }
        }
    }
}

private func configureAuthInteractor() -> AuthBusinessLogic {
    return AuthInteractor()
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(AppStateManager())
    }
}
