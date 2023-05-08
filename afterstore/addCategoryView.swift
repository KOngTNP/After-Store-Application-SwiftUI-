//
//  addCategoryView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 19/4/2566 BE.
//

import SwiftUI


struct addCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var categoryName: String = ""
    
    var body: some View {
        NavigationView{
            VStack{ //Open VStack
                HStack{
                    Text("Add Category")
                        .font(.system(size: 23))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                }
                .padding(.trailing, 200)
                ZStack{
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .cornerRadius(34)
                    VStack{ //Open VStack
                        TextField("Category name", text: $categoryName)
                            .padding(.leading, 30.0)
                        Divider()
                            .frame(width: 360.0)
                    }
                    .offset(y:-290)
                    ZStack{
                        Rectangle()
                            .fill(Color(red: 1.0, green: 0.96, blue: 0.95))
                            .frame(height: 190.0)
                            .cornerRadius(34)
                        VStack{
                            Button(action: {
                                saveCategory()
                                dismiss()
                            }, label: {
                                Text("Confirm")
                                    .frame(width: 365, height: 44)
                                    .foregroundColor(Color.white)
                                    .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                            })
                            .disabled(categoryName.isEmpty)
                        }//Close VStack
                        .offset(y:-50)
                    }//Close ZStack
                    .offset(y:350)
                }
                
                Spacer()
            }//Close VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color(red: 1.0, green: 0.96, blue: 0.95)
            .edgesIgnoringSafeArea(.all))
        }
        .toolbar(.hidden, for: .tabBar)
    }
    private func saveCategory(){
        let newCategory = Category(context: viewContext)
        newCategory.id = UUID()
        newCategory.name = categoryName
        do {
            try viewContext.save()
        } catch {
            print("Failed saving \(error.localizedDescription)")
        }
    }
}

struct addCategory_Previews: PreviewProvider {
    static var previews: some View {
        addCategoryView()
    }
}
