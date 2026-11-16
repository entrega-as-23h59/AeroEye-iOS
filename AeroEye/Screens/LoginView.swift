//
//  LoginView.swift
//  AeroEye
//

import SwiftUI
import UIKit

struct LoginView: View {
    var onSignIn: () -> Void

    @State private var identifier = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isSubmitting = false
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case identifier
        case password
    }

    private var canSubmit: Bool {
        !identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer(minLength: 40)

                    brandHeader

                    form

                    footer

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 26)
                .frame(maxWidth: 460)
                .frame(width: proxy.size.width)
                .frame(minHeight: proxy.size.height)
            }
        }
        .background(background)
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            AeroTheme.canvas

            LinearGradient(
                colors: [Color(hex: 0xEBEFF8), AeroTheme.canvas, AeroTheme.canvas],
                startPoint: .top,
                endPoint: .bottom
            )

            Circle()
                .fill(
                    RadialGradient(
                        colors: [AeroTheme.navy.opacity(0.10), AeroTheme.navy.opacity(0)],
                        center: .center,
                        startRadius: 0,
                        endRadius: 280
                    )
                )
                .frame(width: 560, height: 560)
                .offset(x: 160, y: -380)
                .blur(radius: 18)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    // MARK: - Header

    private var brandHeader: some View {
        VStack(spacing: 18) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(AeroTheme.navyGradient)
                    .frame(width: 68, height: 68)
                    .shadow(color: AeroTheme.navy.opacity(0.26), radius: 18, x: 0, y: 10)

                Image(systemName: "camera.aperture")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(spacing: 7) {
                Text("AeroEye")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AeroTheme.ink)

                Text("Machine monitoring, from the air.")
                    .font(.system(size: 15))
                    .foregroundColor(AeroTheme.secondary)
            }
        }
        .padding(.bottom, 36)
    }

    // MARK: - Form

    private var form: some View {
        VStack(spacing: 14) {
            fieldContainer(
                icon: "envelope",
                isFocused: focusedField == .identifier
            ) {
                TextField("Email or username", text: $identifier)
                    .focused($focusedField, equals: .identifier)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .font(.system(size: 16))
                    .foregroundColor(AeroTheme.ink)
                    .accentColor(AeroTheme.navy)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
            }

            passwordContainer

            signInButton

            demoNote
        }
    }

    private var passwordContainer: some View {
        fieldContainer(
            icon: "lock",
            isFocused: focusedField == .password
        ) {
            HStack(spacing: 10) {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                .focused($focusedField, equals: .password)
                .textContentType(.password)
                .font(.system(size: 16))
                .foregroundColor(AeroTheme.ink)
                .accentColor(AeroTheme.navy)
                .submitLabel(.go)
                .onSubmit(signIn)

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AeroTheme.tertiary)
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
            }
        }
    }

    private func fieldContainer<Content: View>(
        icon: String,
        isFocused: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isFocused ? AeroTheme.navy : AeroTheme.tertiary)
                .frame(width: 20)

            content()
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(AeroTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(
                    isFocused ? AeroTheme.navy : AeroTheme.hairline,
                    lineWidth: isFocused ? 1.5 : 1
                )
        )
        .shadow(
            color: isFocused ? AeroTheme.navy.opacity(0.08) : .clear,
            radius: 8,
            x: 0,
            y: 3
        )
        .animation(.easeOut(duration: 0.15), value: isFocused)
    }

    private var signInButton: some View {
        Button(action: signIn) {
            HStack(spacing: 10) {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .font(.system(size: 17, weight: .semibold))

                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(AeroTheme.navyGradient)
            )
            .shadow(color: AeroTheme.navy.opacity(0.22), radius: 16, x: 0, y: 8)
            .opacity(canSubmit ? 1 : 0.42)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!canSubmit || isSubmitting)
        .padding(.top, 6)
    }

    private var demoNote: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle")
                .font(.system(size: 11, weight: .medium))

            Text("Demo build — any email and password will sign you in.")
                .font(.system(size: 12.5))
                .multilineTextAlignment(.center)
        }
        .foregroundColor(AeroTheme.tertiary)
        .padding(.top, 8)
    }

    private var footer: some View {
        Text("AEROEYE INDUSTRIAL SYSTEMS")
            .font(.system(size: 10.5, weight: .medium))
            .tracking(1.2)
            .foregroundColor(AeroTheme.tertiary.opacity(0.8))
            .padding(.top, 44)
    }

    // MARK: - Actions

    private func signIn() {
        guard canSubmit, !isSubmitting else { return }

        focusedField = nil
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        withAnimation(.easeInOut(duration: 0.15)) {
            isSubmitting = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            isSubmitting = false
            onSignIn()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onSignIn: {})
    }
}
