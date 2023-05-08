//
//  addItemView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 24/4/2566 BE.
//

import SwiftUI
import CoreData
struct addItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var product:Product
//    @State var selectedOrder = Order()
    @State var productQuantity:Int16 = 1
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath:\Order.customer, ascending: true)]) private var orders:FetchedResults<Order>
//    var body: some View {
        //        VStack{
        //            HStack{
        //                if (product.productImage != nil){
        //                    Image(uiImage: UIImage(data: product.productImage!)!)
        //                        .resizable()
        //                        .clipShape(Circle())
        //                        .frame(width: 60, height: 60)
        //                }
        //                VStack(alignment: .leading){
        //                    Text("Name : " + (product.name ?? "")).font(.title2)
        //                    Text("Age : \(product.price)").foregroundColor(.gray)
        //                }
        //            }
        //        }
        //    }
        var body: some View {
            NavigationView{
                VStack{ //Open VStack
                    HStack{
                        Text("Add Product")
                            .font(.system(size: 23))
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                    }
                    .padding(.trailing, 220)
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
                            HStack{
                                Text(product.name ?? "")
                                    .font(.system(size: 30))
                                    .fontWeight(.heavy)
                                    .offset(x:15)
                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                Spacer()
                            }
                            HStack{
                                Text(product.descrip ?? "")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                    .offset(x:15)
                                    .offset(y:50)
                                Spacer()
                            }
                        }
                        .offset(y:-200)
                        ZStack{
                            Rectangle()
                                .fill(Color(red: 1.0, green: 0.96, blue: 0.95))
                                .frame(height: 290.0)
                                .cornerRadius(34)
                            VStack{
                                HStack{
                                    VStack{
                                        Text("Price/QTY")
                                            .offset(x:10)
                                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                        Text("\(String(product.price)) Baht")
                                            .font(.system(size: 25))
                                            .fontWeight(.heavy)
                                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                            .offset(x:40)
                                            .offset(y:5)
                                    }
                                    .offset(x:-20)
                                    .offset(y:10)
                                    .padding(.top, -80)
                                    VStack{
                                        Text("Quantity:")
                                            .offset(x:60)
                                            .offset(y:10)
                                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                        TextField("", text: Binding<String>(
                                            get: { String(productQuantity) },
                                            set: { productQuantity = Int16($0) ?? 0 }
                                        ), onEditingChanged: { _ in }, onCommit: {})
                                            .offset(x:150)
                                            .keyboardType(.numberPad)
                                            .padding(.leading, 30.0)
                                            .onAppear {
                                                productQuantity = 1
                                            }
                                        Divider()
                                            .offset(x:65)
                                            .frame(width: 80.0)
                                    }
                                    .padding(.top, -80)
                                }
                                Button(action: {
                                    addItem()
                                }, label: {
                                    Text("Confirm")
                                        .frame(width: 365, height: 44)
                                        .foregroundColor(Color.white)
                                        .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                        .cornerRadius(28)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                }).offset(y:-10)
                            }//Close VStack
                            .offset(y:-30)
                        }//Close ZStack
                        .offset(y:130)
                    }//Close white ZStack
                    .offset(y:50)
                    Spacer()
                }//Close VStack
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                .background(Color(red: 1.0, green: 0.96, blue: 0.95)
                    .edgesIgnoringSafeArea(.all))
                .navigationBarBackButtonHidden(true)
            }
            .navigationBarBackButtonHidden(true)
        }
    func addItem(){
        let newItem = Item(context: viewContext)
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Order.timestamp, ascending: false)]
        fetchRequest.fetchLimit = 1
        
        guard let lastOrder = try? viewContext.fetch(fetchRequest).first else {
            return
        }
        let quantity = Float(productQuantity)
        newItem.id = UUID()
        newItem.price = product.price * quantity
        newItem.timestamp = Date()
        newItem.quantity = productQuantity
        newItem.itemToProduct = product
        newItem.itemToOrder = lastOrder
        do{
            try viewContext.save()
        }
        catch{
            print("Error while saving Employee Data \(error.localizedDescription)")
        }
    }
}
    
