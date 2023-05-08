//
//  ProductDetailView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 22/4/2566 BE.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var product:Product
    
    var body: some View {
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
                NavigationLink(destination: editProductView(product: product)) {
//                                                    Spacer()
                    
                }
            }
        }
        .swipeActions(edge:.trailing){
            Button(role:.destructive,action: {
                deleteProduct()
            },label:{
                Label("Delete Product",systemImage: "trash")
            })
        }
    }
    
    private func deleteProduct(){
        let productToDelete = product
        do{
            viewContext.delete(productToDelete)
            try viewContext.save()
        }
        catch{
            print("Error while deleting employee \(error.localizedDescription)")
        }
    }
    
}
