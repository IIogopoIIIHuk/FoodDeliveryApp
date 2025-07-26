//
//  ProfileView.swift
//  FoodDeliveryApp
//
//  Created by Александр Мамчиц on 7/26/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    
    var body: some View {
        VStack {
            
            Text("Профиль")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button("Выйти") {
                print("ProfileView: Logout button tapped. Logging out...")
                appStateManager.logout()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 50)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundMain)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppStateManager())
    }
}
