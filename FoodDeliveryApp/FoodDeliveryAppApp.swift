import SwiftUI

// Фабричная функция для создания модуля аутентификации
func configureAuthModule() -> AuthView {
    let interactor = AuthInteractor()
    let presenter = AuthPresenter()
    
    // Связываем interactor с presenter
    interactor.presenter = presenter
    
    // Создаем View и передаем в него presenter и interactor
    let view = AuthView(interactor: interactor, presenter: presenter)
    
    return view
}

@main
struct FoodDeliveryApp: App {
    @StateObject var appStateManager = AppStateManager()

    var body: some Scene {
        WindowGroup {
            if appStateManager.isAuthenticated {
                MainView()
                    .environmentObject(appStateManager)
            } else {
                configureAuthModule()
                    .environmentObject(appStateManager)
            }
        }
    }
}

