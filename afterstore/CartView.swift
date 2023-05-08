//
//  CartView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 23/4/2566 BE.
//

import SwiftUI
import CoreData


struct CartView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var customer: String = ""
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Order.timestamp,ascending: false)]) private var orders:FetchedResults<Order>

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp,ascending: false)]) private var items:FetchedResults<Item>
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
//    @FetchRequest(entity: Order.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Order.timestamp, ascending: false)])
//        private var myorder: FetchedResults<Order>

    var body: some View {

        NavigationView{
            VStack{
//                if let lastOrder = myorder.last {
//                            Text("Total: \(lastOrder.customer)")
//                            // Use the properties of the lastOrder object here
//                        } else {
//                            Text("No orders found")
//                        }//Open VStack
                HStack{
                    ForEach(Array(orders.prefix(1)), id: \.id){order in
                        Text(order.customer ?? "")
                            .font(.system(size: 23))
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                    }
                }//close HStack header
                .padding(.trailing, 200)

                List {
                    ForEach(Array(orders.prefix(1)), id: \.id){order in
//                            NavigationLink(destination: {
//
//                            }, label: {
//                                Text(order.timestamp!, formatter: itemFormatter)
//                            })
//                            .listRowBackground(Color(red: 1.0, green: 1, blue: 1))
//                            List{
//                                ForEach(order.item){item in
//                                    Text(item.itemToProduct?.name ?? "")
//                                }
//                            }
                                ForEach(order.item){item in
                                    VStack{
                                            HStack{
                                                if (item.itemToProduct?.productImage != nil){
                                                    Image(uiImage: UIImage(data: item.itemToProduct?.productImage ?? Data()) ?? UIImage())
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .frame(width: 60, height: 60)
                                                }
                                                else {
                                                    Image(systemName: "cart")
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .frame(width: 60, height: 60)
                                                }
                                                VStack(alignment: .leading){
                                                    Text(item.itemToProduct?.name ?? "").font(.title2)
                                                    Text("Baht \(item.price, specifier: "%.2f")").foregroundColor(.gray)
//                                                    Text("Baht \(item.quantity)").foregroundColor(.gray) 60 65 70 75 80 85 90 95 3 2
                                                }
                                                Spacer()
                                                Text("x\(item.quantity)").font(.title2)
                                            }
                                    }
//                                    totalPrice = order.item.reduce(0) { $0 + $1.price }
                                }
                                .onDelete(perform: deleteItem)
                        }
//                        .onDelete(perform: deleteOrder)
//                        .padding(.bottom,5)
                    }
                .listStyle(PlainListStyle()) // Set the list style
                            .background(Color.clear)
                NavigationLink(destination: selectCategoryView().onAppear {
                }) {
                    Text("+ Add more Items")
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        .frame(width: 180, height: 34)
                        .background(Color.white)
                        .cornerRadius(34)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                }
                .offset(y:40)
                .offset(x:90)

                    ZStack{
                        
                        Rectangle()
                            .fill(Color(red: 1.0, green: 0.96, blue: 0.95))
                            .frame(height: 310.0)
                            .cornerRadius(34)
                        .offset(y:-100)
                        Rectangle()
                            .fill(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                            .frame(height: 50.0)
                            .frame(width: 370.0)
                            .cornerRadius(15)
                        .offset(y:-170)
                        VStack{
                            
                            Text("Customer name")
                                .font(.system(size: 20))
//                                .fontWeight(.heavy)
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                .offset(x:-95)
                                .offset(y:-10)
                            VStack{ //Open VStack
                                Text("Enter customer name:")
                                    .font(.system(size: 15))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.white)
                                    .offset(y:34)
                                    .offset(x:-85)
                                
                                TextField("", text: $customer)
                                    .padding(.leading, 30.0)
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 1.0, green: 1, blue: 1))
                                    .frame(width: 190.0)
                                    .offset(x:75)
                                Divider()
                                    .background(Color.white)
                                    .frame(width: 160.0)
                                    .offset(x:90)
                                    .offset(y:-5)
                                    
                            }
                            .offset(y:-15)
                        }
                        .offset(y:-180)
                        VStack{
                            Divider()
                                .frame(width: 360.0)
                            Text("Summary")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                .offset(x:-115)
                            Text("Subtotal")
                                .font(.system(size: 20))
                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                .offset(x:-127)
                                .offset(y:10)
                                HStack{
                                    ForEach(Array(orders.prefix(1)), id: \.id){order in
                                        Text("\(order.item.reduce(0) { $0 + $1.price }, specifier: "%.2f") Baht")
                                            .font(.system(size: 23))
                                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                        
                                    }
                                }
                                .offset(y:-15)
                                .offset(x:120)
                            VStack{
                                Button(action: {
                                    editOrder()
                                    dismiss()
                                }, label: {
                                    Text("Place Order")
                                        .frame(width: 365, height: 44)
                                        .foregroundColor(Color.white)
                                        .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                        .cornerRadius(28)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                })
                                .disabled(customer.isEmpty)
                            }//Close VStack
                            .offset(y:-10)
                        }
                        .offset(y:-50)
                    }//Close ZStack
                    .offset(y:140)
                
                Spacer()
            }//Close VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color(red: 1.0, green: 0.96, blue: 0.95)
            .edgesIgnoringSafeArea(.all))
            .navigationBarItems(leading: backButton)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
    private var backButton: some View {
            Button(action: {
                deleteCategory()
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
//    private func deleteOrder(at offset:IndexSet){
//            for index in offset{
//                let orderToDelete = orders[index]
//                do{
//                    viewContext.delete(orderToDelete)
//                    try viewContext.save()
//                }catch{
//                    print("Error while deleting Department \(error.localizedDescription)")
//                }
//            }
//        }
    private func deleteItem(at offset:IndexSet){
            for index in offset{
                let itemToDelete = items[index]
                do{
                    viewContext.delete(itemToDelete)
                    try viewContext.save()
                }catch{
                    print("Error while deleting item \(error.localizedDescription)")
                }
            }
        }
    
    private func getLastOrder() -> Order? {
            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Order.timestamp, ascending: false)]
            fetchRequest.fetchLimit = 1
            do {
                let orders = try viewContext.fetch(fetchRequest)
                return orders.first
            } catch {
                print("Error fetching records: \(error.localizedDescription)")
                return nil
            }
        }
    
    private func deleteCategory(){
        
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Order.timestamp, ascending: false)]
        fetchRequest.fetchLimit = 1
        guard let deletelastOrder = try? viewContext.fetch(fetchRequest).first else {
            return
        }
                do{
                    print("Delete")
                    viewContext.delete(deletelastOrder)
                    try viewContext.save()
                }catch{
                    print("Error while deleting Department \(error.localizedDescription)")
                }
            }
        
    
    private func editOrder(){
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Order.timestamp, ascending: false)]
        fetchRequest.fetchLimit = 1
        
        guard let lastOrder = try? viewContext.fetch(fetchRequest).first else {
            return
        }
        let totalPrice = lastOrder.item.reduce(0) { $0 + $1.price }
        lastOrder.customer = customer
        lastOrder.total = totalPrice

        do {
            try viewContext.save()
            print("Saving order")
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        }
}
struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        
        CartView()
    }
}
