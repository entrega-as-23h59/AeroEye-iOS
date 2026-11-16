//
//  RootView.swift
//  AeroEye
//

import SwiftUI

struct RootView: View {
    @State private var isAuthenticated = false

    var body: some View {
        ZStack {
            if isAuthenticated {
                MainTabView(onSignOut: signOut)
                    .transition(.opacity)
            } else {
                LoginView(onSignIn: signIn)
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.light)
    }

    private func signIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isAuthenticated = true
        }
    }

    private func signOut() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isAuthenticated = false
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
