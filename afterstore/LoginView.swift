//
//  LoginView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 16/3/2566 BE.
//

import SwiftUI
import CoreData

//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}


//
//  LoginView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 16/3/2566 BE.
//

import SwiftUI
struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userAuth: UserAuth
    
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    var isSignInButtonDisabled: Bool {
            [email, password].contains(where: \.isEmpty)
        }

    var body: some View {
        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
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
                            Button(action: {
                                // action to perform when the button is tapped
                            }) {
                                Text("Sign In")
                                    .frame(width: 125, height: 34)
                                    .foregroundColor(Color.white)
                                    .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                            }
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Sign Up")
                                    .frame(width: 125, height: 34)
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                    .background(Color.white)
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                
                            }
                        }
                        .padding(.bottom, 40)
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
                    }
                    .padding(.top, -220)
                    Button(action: login) {
                        Text("Sign In")
                            .frame(width: 225, height: 44)
                            .foregroundColor(Color.white)
                            .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                            .cornerRadius(28)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                    }
                    .padding(.top, 400.0)
                    if isLoggedIn { // <-- show main view if logged in
                        NavigationLink(destination: MainView().navigationBarBackButtonHidden(true), isActive: $isLoggedIn) {
                            EmptyView()
                        }
                    }
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    private func login() {
            let request = NSFetchRequest<User>(entityName: "User")
            request.predicate = NSPredicate(format: "email == %@", email)
            do {
                let users = try viewContext.fetch(request)
                if let user = users.first {
                    if user.password == password {
                        userAuth.logUserIn(user.id.hashValue)
                        userAuth.currentUser = user
                        isLoggedIn = true
                        return
                    }
                }
                alertMessage = "Incorrect email or password."
            } catch {
                alertMessage = "Error fetching user."
            }
            showAlert = true
        }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
