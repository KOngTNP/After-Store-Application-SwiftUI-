//
//  selectCategoryView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 24/4/2566 BE.
//

import SwiftUI

struct selectCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name,ascending: true)]) private var categorys:FetchedResults<Category>
//    @ObservedObject var products:Product
    var body: some View {
        NavigationView {

            VStack{ //Open VStack
                HStack{
                    Text("Add more items")
                        .font(.system(size: 23))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                } //Close HStack
                .padding(.trailing, 200)
                
                ZStack{  //Close Category HStack

                    HStack{
                    Text("Category")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .offset(x:-150)
                        .offset(y:10)

                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                    }
                }
                .padding(.bottom, 20)
                List {
                        ForEach(categorys){category in
                            NavigationLink(destination: {
                                HStack{
                                    Text("Add more items")
                                        .font(.system(size: 23))
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                } //Close HStack
                                .padding(.trailing, 200)
                                .background(Color(red: 1.0, green: 0.96, blue: 0.95)
                                    .edgesIgnoringSafeArea(.all))
                                List{
                                    ForEach(category.product){product in
                                        VStack{
                                            HStack{
                                                if (product.productImage != nil){
                                                    Image(uiImage: UIImage(data: product.productImage!)!)
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .frame(width: 60, height: 60)
                                                }
                                                VStack(alignment: .leading){
                                                    Text((product.name ?? "")).font(.title2)
                                                    Text("Price/QTY: \(product.price, specifier: "%.2f")").foregroundColor(.gray)
                                                }
//                                                .frame(width: 220)
                                                NavigationLink(destination: addItemView(product: product)) {
//                                                    Spacer()
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                .listStyle(PlainListStyle()) // Set the list style
                                .background(Color(red: 1.0, green: 0.96, blue: 0.95).edgesIgnoringSafeArea(.all))
                                .navigationBarBackButtonHidden(true)
                            }, label: {
                                Text(category.name ?? "")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                            })
                            .frame(height: 50)
                            .listRowBackground(Color(red: 1.0, green: 1, blue: 1))
                            
                        }
//                        frame(height: 150)
                        .padding(.bottom,5)
                    }
//                .frame(height: 50)
                .listStyle(PlainListStyle())
                .background(Color(red: 1.0, green: 0.96, blue: 0.95))
                Spacer()
                
            }//Close VStack
            .navigationBarBackButtonHidden(true)
            .environment(\.managedObjectContext,viewContext)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color(red: 1.0, green: 0.96, blue: 0.95)
                .edgesIgnoringSafeArea(.all))
            
        }

        .toolbar(.hidden, for: .tabBar)
    }
}


struct selectCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        selectCategoryView()
    }
}
