//
//  AccountView.swift
//  afterstore
//
//  Created by KOng's Macbook Pro on 3/5/2566 BE.
//

import SwiftUI
import CoreData
struct AccountView: View {
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.managedObjectContext) private var viewContext
    @State var productImage = UIImage()
    @State var imagePicker = false
    
    var body: some View {
        VStack{
            VStack{
                if (userAuth.currentUser?.userImage != nil){
                    if productImage != UIImage(){
                        Image(uiImage: productImage)
                            .resizable()
                            .scaledToFit()
                            .edgesIgnoringSafeArea(.all)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)),lineWidth: 2))
                            .frame(width: 260, height: 260)
                    }
                    else {
                        if let currentUserImage = userAuth.currentUser?.userImage {
                            Image(uiImage: UIImage(data: currentUserImage)!)
                                .resizable()
                                .scaledToFit()
                                .edgesIgnoringSafeArea(.all)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)),lineWidth: 2))
                                .frame(width: 260, height: 260)
                        }
                    }
                } else {
                        Image(uiImage: productImage)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)),lineWidth: 2))
                        .frame(width: 260, height: 260)
                    }
                    ZStack{
                        Button(action: {
                            imagePicker.toggle()
                        }, label: {
                            Text(Image(systemName: "camera.circle.fill"))
                                .font(.system(size: 40))
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                        })
                    }
                    .offset(y:-230)
                    .offset(x:140)
                    .sheet(isPresented: $imagePicker, onDismiss: saveImage){
                        ImagePickerView(selectedImage: $productImage)
                    }
            } //Close image VStack
            VStack{
                ZStack{
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(width: 355, height: 75)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                        .padding(.bottom, 20.0)
                    HStack{
                        Image(systemName: "person")
                            .font(.system(size: 20))
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        if let currentUserEmail = userAuth.currentUser?.email {
                            Text(currentUserEmail)
                                .font(.title2)
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        }
                    }
                    .offset(y:-10)
                    .frame(width: 320, alignment: .leading)
                }
                ZStack{
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(width: 355, height: 75)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                        .padding(.bottom, 70.0)
                    HStack{
                        Image(systemName: "house")
                            .font(.system(size: 20))
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        if let currentUserstoreName = userAuth.currentUser?.storeName {
                            Text(currentUserstoreName)
                                .font(.title2)
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        }
                        Spacer()
                        NavigationLink(destination: editStoreNameView()
                        ) {
                            Text(Image(systemName: "pencil"))
                                .font(.system(size: 20))
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        }
                    }
                    .offset(y:-35)
                    .frame(width: 320, alignment: .leading)
                }
            }
            .offset(y:-90)
            
            
            ZStack{
                Rectangle()
                    .fill(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                    .frame(width: 355, height: 50)
                    .cornerRadius(23)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                    .padding(.bottom, 20.0)
                VStack{
                    NavigationLink(destination: LoginView()
                    ) {
                        Text("Sign out")
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                    }
                }
                .offset(y:-10)
//                .frame(width: 320, alignment: .leading)
            }
            
            
            Spacer()
        } //close V
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .background(Color(red: 1.0, green: 0.96, blue: 0.95)
        .edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchCurrentUser()
        }
    }
    private func fetchCurrentUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", userAuth.currentUser?.email ?? "")
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                userAuth.currentUser = user
            }
        } catch {
            print("Error fetching current user: \(error)")
        }
    }
    private func saveImage(){
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", userAuth.currentUser?.email ?? "")
        guard let newStore = try? viewContext.fetch(fetchRequest).first else {
            return
        }
        newStore.userImage = productImage.pngData()
        do {
            try viewContext.save()
        } catch {
            print("Failed saving \(error.localizedDescription)")
        }
    }
}
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}


