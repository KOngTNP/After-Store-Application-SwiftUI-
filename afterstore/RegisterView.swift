//
//  RegisterView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 4/4/2566 BE.
//

import SwiftUI
import CoreData
struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showLoginView = false
    var isSignInButtonDisabled: Bool {
            [email, password].contains(where: \.isEmpty)
        }
    var body: some View {
        NavigationView {
            VStack{ //Open VStack
                ZStack {
                    Circle()
                        .fill(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 0.5)))
                        .frame(width: 705, height: 705)
                        .position(x: 80, y: -180)
                    Image("AfterStore_Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        .padding(.bottom, 30.0)
                        .frame(width: 175)
                }
                
                ZStack{
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(width: 315, height: 499)
                        .cornerRadius(34)
                    VStack{
                        HStack{
                            NavigationLink(destination: LoginView()) {
                                Text("Sign In")
                                    .frame(width: 125, height: 34)
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                    .background(Color.white)
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                
                            }
                            
                            Button(action: {
                                // action to perform when the button is tapped
                            }) {
                                Text("Sign Up")
                                
                                    .frame(width: 125, height: 34)
                                    .foregroundColor(Color.white)
                                    .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                            }
                        }
                        .padding(.bottom, 40)
                        VStack{
                            TextField("Email", text: $email)
                                .padding(.leading, 40.0)
                            Divider()
                                .frame(width: 280.0)
                            Group {
                                if showPassword {
                                    TextField("Password", text: $password) // How to change the color of the TextField Placeholder
                                } else {
                                    SecureField("Password", text: $password)
                                }
                            }
                            .padding(.leading, 40.0)
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray) // how to change image based in a State variable
                            }
                            .padding(.leading, 250.0)
                            .padding(.top, -25.0)
                            Divider()
                                .frame(width: 280.0)
                            Group {
                                if showConfirmPassword {
                                    TextField("Confirm Password", text: $confirmPassword) // How to change the color of the TextField Placeholder
                                } else {
                                    SecureField("Confirm Password", text: $confirmPassword)
                                }
                            }
                            .padding(.leading, 40.0)
                            
                            Button {
                                showConfirmPassword.toggle()
                            } label: {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray) // how to change image based in a State variable
                            }
                            .padding(.leading, 250.0)
                            .padding(.top, -25.0)
                            Divider()
                                .frame(width: 280, height: 2)
                        }
                    }
                    .padding(.top, -220)
                    Button(action:registerUser) {
                        Text("Sign Up")
                            .frame(width: 225, height: 44)
                            .foregroundColor(Color.white)
                            .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                            .cornerRadius(28)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                    }
                    .padding(.top, 400.0)
                    .disabled(!canRegisterUser())
                    if showLoginView { // <-- show main view if logged in
                        NavigationLink(destination: LoginView(), isActive: $showLoginView) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }
                .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
                
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 0.5)))
                        .frame(width: 305, height: 305)
                }
                .position(x: 280, y: 170)
            } //Close VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .padding(25)
            //        .cornerRadius(20)
            .background(Color(red: 1.0, green: 0.96, blue: 0.95)
                .edgesIgnoringSafeArea(.all))
        }
        .navigationBarBackButtonHidden(true)
        
    }
    private func canRegisterUser() -> Bool {
            return !email.isEmpty && !password.isEmpty && password == confirmPassword
        }
        
    private func registerUser() {
        guard canRegisterUser() else { return }

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let matchingUsers = try viewContext.fetch(fetchRequest)
            if matchingUsers.count > 0 {
                self.alertMessage = "An account with that email address already exists."
                self.showingAlert = true
                return
            }

            let newUser = User(context: viewContext)
            newUser.email = email
            newUser.password = password

            try viewContext.save()
            self.alertMessage = "Registration successful!"
//            self.showingAlert = true
            self.showLoginView = true // navigate to login view
            return
        } catch {
            self.alertMessage = "An error occurred while saving your data. Please try again later."
            self.showingAlert = true
            print("Error saving user data: \(error)")
        }
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
