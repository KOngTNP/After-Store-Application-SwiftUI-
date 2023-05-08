//
//  ProductView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 6/4/2566 BE.
//

import SwiftUI
import CoreData
struct ProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name,ascending: true)]) private var categorys:FetchedResults<Category>
    var body: some View {

            VStack{ //Open VStack
                ZStack{
                    HStack{
                        HStack{
                            Text("Products")
                                .font(.system(size: 23))
                                .fontWeight(.heavy)
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        } //Close HStack
                        .padding(.trailing, 200)
                        
                        NavigationLink(destination: addProductView()) {
                            Text(Image(systemName: "plus.circle.fill"))
                                .font(.system(size: 30))
                            //                            .frame(width: 50, height: 50)
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                            
                        }
                    } //Close HStack
                }
                ZStack{  //Close Category HStack
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(height: 70)
                    
                    HStack{
                    Text("Category")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .offset(x:-90)

                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                    NavigationLink(destination: addCategoryView()) {
                        Text(Image(systemName: "plus"))
                            .frame(width: 90, height: 40)
                            .background(Color.white)
                            .cornerRadius(30)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                    }
                    .offset(x:100)
                    }
                }
                
                List {
                        ForEach(categorys){category in
                            NavigationLink(destination: {
                                List{
                                    ForEach(category.product){product in
                                        ProductDetailView(product: product)
                                    }
                                }
                                .listStyle(PlainListStyle()) // Set the list style
                                .background(Color(red: 1.0, green: 0.96, blue: 0.95).edgesIgnoringSafeArea(.all))
                                
                                .navigationTitle("Product in : " + (category.name!))
                            }, label: {
                                Text(category.name ?? "")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                            })
                            .frame(height: 50)
                            .listRowBackground(Color(red: 1.0, green: 1, blue: 1))
                        }
                        .onDelete(perform: deleteCategory)
                        .padding(.bottom,5)
                    }
                .listStyle(PlainListStyle())
                .background(Color(red: 1.0, green: 0.96, blue: 0.95))
//                Spacer()
            }//Close VStack

            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color(red: 1.0, green: 0.96, blue: 0.95)
                .edgesIgnoringSafeArea(.all))
    }
    private func deleteCategory(at offset:IndexSet){
            for index in offset{
                let categoryToDelete = categorys[index]
                do{
                    viewContext.delete(categoryToDelete)
                    try viewContext.save()
                }catch{
                    print("Error while deleting Department \(error.localizedDescription)")
                }
            }
        }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
