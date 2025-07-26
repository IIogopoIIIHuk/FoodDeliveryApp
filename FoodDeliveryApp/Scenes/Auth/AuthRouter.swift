import Foundation

// Класс AuthRouter больше не используется в обновленной логике аутентификации
class AuthRouter: AuthRoutingLogic, AuthDataPassing {
    var dataStore: AuthDataStore?
    
    func navigateToMainScreen() {
        // Эта логика навигации была перенесена в AuthView
    }
}

extension Notification.Name {
    static let didAuthenticateSuccessfully = Notification.Name("didAuthenticateSuccessfully")
}
