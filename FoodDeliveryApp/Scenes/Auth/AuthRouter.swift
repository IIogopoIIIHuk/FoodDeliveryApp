import Foundation
//

class AuthRouter: AuthRoutingLogic, AuthDataPassing {
    var dataStore: AuthDataStore?
    
    func navigateToMainScreen() {
    }
}
//
extension Notification.Name {
    static let didAuthenticateSuccessfully = Notification.Name("didAuthenticateSuccessfully")
}
