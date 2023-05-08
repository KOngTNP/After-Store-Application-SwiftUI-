import SwiftUI
import Combine

class UserAuth: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    var userId: Int? = nil
    
    func logUserIn(_ id: Int) {
        isLoggedIn = true
        userId = id
    }
    
    func logUserOut() {
        isLoggedIn = false
        userId = nil
    }
}
