//
//  Account.swift
//  Bizzy
//
//  Created by Henry Warren on 5/18/20.
//  Copyright © 2020 Bizzy Inc. All rights reserved.
//

import Foundation
import FirebaseUI
import CryptoKit
import AuthenticationServices
import SwiftUI
var accountName = "Sign In"
var loggedIn = true
let reference = DatabaseManager.root.collection(DatabaseKeys.CollectionPath.users).document()
let uid = reference.documentID

// SignInWithApple()
final class SignInWithApple: UIViewRepresentable {
  // 2
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    // 3
    return ASAuthorizationAppleIDButton()
  }
  
  // 4
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
  }
}
struct signIn {
    let provider = FUIOAuth.appleAuthProvider()
    private func randomNonceString(length: Int = 32) -> String {
           precondition(length > 0)
           let charset: Array<Character> =
               Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
           var result = ""
           var remainingLength = length
           
           while remainingLength > 0 {
               let randoms: [UInt8] = (0 ..< 16).map { _ in
                   var random: UInt8 = 0
                   let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                   if errorCode != errSecSuccess {
                       fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                   }
                   return random
               }
               
               randoms.forEach { random in
                   if remainingLength == 0 {
                       return
                   }
                   
                   if random < charset.count {
                       result.append(charset[Int(random)])
                       remainingLength -= 1
                   }
               }
           }
           
           return result
       }
       //sha256 converter
       private func sha256(_ input: String) -> String {
           let inputData = Data(input.utf8)
           let hashedData = SHA256.hash(data: inputData)
           let hashString = hashedData.compactMap {
               return String(format: "%02x", $0)
           }.joined()
           
           return hashString
       }
}
struct signInView: View {
    var body: some View {
    //randomNonceString
        ZStack{
        VStack (alignment: .leading) {
            Spacer()
            SignInWithApple()
                .frame(width:280,height:60)
            }
            MenuButton()
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        signInView().environmentObject(ViewRouter())
    }
}
