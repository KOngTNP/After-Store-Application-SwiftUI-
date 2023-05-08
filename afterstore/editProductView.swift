//
//  addItemView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 24/4/2566 BE.
//

import SwiftUI
import CoreData
struct editProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var product:Product
    //    @State var selectedOrder = Order()
    
    @State var productQuantity:Int16 = 1
    @State var productName = ""
    @State var productDescrip = ""
    @State var productPrice = ""
    //    @State var productStock = ""
    @State var productImage = UIImage()
    @State var imagePicker = false
    @State var selectedCategory = Category()
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath:\Category.name, ascending: true)]) private var categorys:FetchedResults<Category>
    
    var body: some View {
        NavigationView{
            VStack{ //Open VStack
                HStack{
                    Text("Edit Product")
                        .font(.system(size: 23))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                }
                .padding(.trailing, 200)
                VStack{
                    if (product.productImage != nil){
                        Image(uiImage: UIImage(data: product.productImage!)!)
                            .resizable()
                            .scaledToFit()
                            .edgesIgnoringSafeArea(.all)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)),lineWidth: 2))
                    }
                } //Close image VStack
                ZStack{
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .cornerRadius(34)
                        .padding(.top, -80)
                    VStack{ //Open VStack
                 
                        Text("Product name:")
                            .padding(.trailing, 230)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        TextField(product.name ?? "", text: $productName)
                            .padding(.leading, 30.0)
                        Divider()
                            .frame(width: 360.0)
                        Text("Product description:")
                            .padding(.trailing, 180)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        TextField(product.descrip ?? "", text: $productDescrip)
                            .padding(.leading, 30.0)
                        Divider()
                            .frame(width: 360.0)
                    }
                    .offset(y:-180)
                    ZStack{
                        Rectangle()
                            .fill(Color(red: 1.0, green: 0.96, blue: 0.95))
                            .frame(height: 290.0)
                            .cornerRadius(34)
                        VStack{
                            HStack{
                                VStack{
                                    Text("Price:")
                                        .offset(x:-150)
                                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                    TextField(String(format: "%.2f", product.price), text: $productPrice)
                                        .keyboardType(.decimalPad)
                                        .padding(.leading, 30.0)
                                    Divider()
                                    
                                        .frame(width: 360.0)
                                }
                                .padding(.top, -80)
                                //                                VStack{
                                //                                    Text("Stock:")
                                //                                        .offset(x:-50)
                                //                                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                //                                    TextField("", text: $productStock)
                                //                                        .keyboardType(.decimalPad)
                                //                                        .padding(.leading, 30.0)
                                //                                    Divider()
                                //                                        .offset(x:-20)
                                //                                        .frame(width: 100.0)
                                //                                }
                                //                                .padding(.top, -80)
                            }
                            Button(action: {
                                addproduct()
                                dismiss()
                            }, label: {
                                Text("Confirm")
                                    .frame(width: 365, height: 44)
                                    .foregroundColor(Color.white)
                                    .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                            })
                        }//Close VStack
                        .offset(y:-10)
                    }//Close ZStack
                    .offset(y:80)
                }//Close white ZStack
                .offset(y:100)
                Spacer()
            }//Close VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color(red: 1.0, green: 0.96, blue: 0.95)
                .edgesIgnoringSafeArea(.all))
        }
        .toolbar(.hidden, for: .tabBar)
    }
    private func addproduct(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id?.uuidString ?? "")
        guard let newProduct = try? viewContext.fetch(fetchRequest).first else {
            return
        }
        if productName != "" {
            newProduct.name = productName
        }
        if productDescrip != "" {
            newProduct.descrip = productDescrip
        }
        
        if productPrice != "" {
            newProduct.price = Float(productPrice)!
        }
        if productPrice != "" {
            newProduct.price = Float(productPrice)!
        }
//
//        newProduct.productImage = productImage.pngData()
//        newProduct.productToCategory = selectedCategory
        do{
            try viewContext.save()
            print("save save save save")
        }
        catch{
            print("Error while saving Employee Data \(error.localizedDescription)")
        }
    }
}
    
