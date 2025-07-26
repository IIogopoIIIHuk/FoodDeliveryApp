import Foundation
import Combine
import SwiftUI

class AppStateManager: ObservableObject {
    @Published var isAuthenticated: Bool = false {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isLoggedIn")
            print("AppStateManager: isAuthenticated didSet -> \(isAuthenticated)")
        }
    }
    
    
    @Published var mainScreenMessage: String?

    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isLoggedIn")
        print("AppStateManager: Initial isAuthenticated: \(self.isAuthenticated)")
    }
    
    func logout() {
        isAuthenticated = false
        mainScreenMessage = nil
        print("AppStateManager: Logout performed.")
    }
}
