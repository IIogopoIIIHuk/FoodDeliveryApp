import SwiftUI

func configureAuthModule() -> AuthView {
    let interactor = AuthInteractor()
    let presenter = AuthPresenter()
    
    interactor.presenter = presenter
    
    let view = AuthView(interactor: interactor, presenter: presenter)
    
    return view
}

@main
struct FoodDeliveryApp: App {
    @StateObject var appStateManager = AppStateManager()

    var body: some Scene {
        WindowGroup {
            if !appStateManager.isSplashShown {
                SplashView()
                    .environmentObject(appStateManager)
            } else if appStateManager.isAuthenticated {
                MainView()
                    .environmentObject(appStateManager)
            } else {
                configureAuthModule()
                    .environmentObject(appStateManager)
            }
        }
    }
}



