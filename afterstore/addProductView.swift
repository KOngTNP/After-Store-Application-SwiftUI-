//
//  addProductView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 20/4/2566 BE.
//

import SwiftUI
import CoreData

struct addProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
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
                    Text("Add Product")
                        .font(.system(size: 23))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                }
                .padding(.trailing, 200)
                VStack{
                    Image(uiImage: productImage)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)),lineWidth: 2))
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
                    .offset(y:-300)
                    .offset(x:140)
                        .sheet(isPresented: $imagePicker){
                            ImagePickerView(selectedImage: $productImage)
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
                            ZStack{
                                Text("Select Category")

                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                            }
                            Picker("Select Employee Department", selection: $selectedCategory){
                                ForEach(categorys,id: \.self){
                                    Text($0.name ?? "")
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        Text("Product name:")
                            .padding(.trailing, 230)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        TextField("", text: $productName)
                            .padding(.leading, 30.0)
                        Divider()
                            .frame(width: 360.0)
                        Text("Product description:")
                            .padding(.trailing, 180)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        TextField("", text: $productDescrip)
                            .padding(.leading, 30.0)
                        Divider()
                            .frame(width: 360.0)
                    }
                    .offset(y:-140)
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
                                    TextField("฿", text: $productPrice)
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
                    .offset(y:130)
                }//Close white ZStack
                Spacer()
            }//Close VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color(red: 1.0, green: 0.96, blue: 0.95)
                .edgesIgnoringSafeArea(.all))
        }
        .toolbar(.hidden, for: .tabBar)
    }
    private func addproduct(){
        let newProduct = Product(context: viewContext)
        newProduct.id = UUID()
        newProduct.name = productName
        newProduct.descrip = productDescrip
        newProduct.price = Float(productPrice)!
        newProduct.productImage = productImage.pngData()
        newProduct.productToCategory = selectedCategory
        do{
            try viewContext.save()
        }
        catch{
            print("Error while saving Employee Data \(error.localizedDescription)")
        }
    }
}


struct addProductView_Previews: PreviewProvider {
    static var previews: some View {
        addProductView()
    }
}
