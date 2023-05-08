//
//  OrderView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 6/4/2566 BE.
//

import SwiftUI
import CoreData
struct OrderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedDate = Date()
    @State private var orders: [Order] = []
    @State var customer: String = "New Order Card"
    var body: some View {
        VStack{ //Open VStack
            ZStack{
                HStack{
                    HStack{
                        Text("Orders")
                            .font(.system(size: 23))
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                    } //Close HStack
                    .padding(.trailing, 200)
                    NavigationLink(destination: CartView().onAppear {
                        self.saveOrder()
//                            print(getOrderDataForLineChart().dayOfWeek)
//                            print(getGroupProduct().qunatity)
//                            print(getLastOrder()?.customer)
                    }) {
                        Text(Image(systemName: "cart"))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                            .frame(width: 35, height: 34)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                    }
                } //Close HStack
            }
            .padding(.top, 5.0) //Close ZStack
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(width: 355, height: 300)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                        .position(x: 196, y: 160)

                        DatePicker("Select a date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            .frame(width: 335, height: 250)
        
                }
                VStack {
                    HStack {
                        Text("Past Order")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .offset(x: -15)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        HStack {
                            Text("Totals")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: 25)
                            Spacer()
                            Text("\(orders.reduce(0) { $0 + $1.total }, specifier: "%.2f") ฿")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(x: 1)
                        }
                        .frame(width: 230, height: 34)
                        .foregroundColor(Color.white)
                        .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                        .offset(x: 19)
                    }
                        VStack {
//                            List(orders) { order in
//                                VStack(alignment: .leading) {
//                                    Text("Total: \(order.total, specifier: "%.2f")")
//                                    Text("Date: \(order.timestamp!, formatter: dateFormatter)")
//                                }
//                            }
                            
                            List {
                                ForEach(orders) { order in
                                        VStack(alignment: .leading) {
                                            HStack{
                                                if let timestamp = order.timestamp {
                                                    Text("K: \(order.customer ?? "") @ \(timestamp, formatter: timeFormatter)").foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                                                }
                                                Spacer()
                                                Text("Total: \(order.total, specifier: "%.2f")")
                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                            }
                                            ForEach(order.item) { item in
                                                Text("\(item.quantity) \(item.itemToProduct?.name ?? "")")
                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                                    .font(.system(size: 14))
                                            }
                                    }
                                }
                                .onDelete(perform: deleteOrder)
                            }
                                        .listStyle(PlainListStyle())
                        }
                        .onAppear(perform: fetchOrdersForSelectedDate)
                        .onChange(of: selectedDate) { _ in
                            fetchOrdersForSelectedDate()
                    }
                }
            }
        } //Close VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .background(Color(red: 1.0, green: 0.96, blue: 0.95)
        .edgesIgnoringSafeArea(.all))
        .onAppear {
            deleteOrdersWithZeroTotal()
                }
    }
    private func deleteOrdersWithZeroTotal() {
            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
            let predicate = NSPredicate(format: "total == 0")
            fetchRequest.predicate = predicate
            
            do {
                let ordersWithZeroTotal = try viewContext.fetch(fetchRequest)
                for order in ordersWithZeroTotal {
                    viewContext.delete(order)
                    print("Deleting orders with zero total")
                }
                try viewContext.save()
            } catch {
                print("Error deleting orders with zero total: \(error)")
            }
        }
    private func saveOrder(){
        let newOrder = Order(context: viewContext)
        newOrder.id = UUID()
        newOrder.customer = customer
        newOrder.timestamp = Date()
        do {
            try viewContext.save()
        } catch {
            print("Failed saving \(error.localizedDescription)")
        }
    }
    private func fetchOrdersForSelectedDate() {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.predicate = predicate

        do {
            orders = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching orders: \(error)")
        }
    }
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
        private func deleteOrder(at offset:IndexSet){
                for index in offset{
                    let orderToDelete = orders[index]
                    do{
                        viewContext.delete(orderToDelete)
                        try viewContext.save()
                    }catch{
                        print("Error while deleting Department \(error.localizedDescription)")
                    }
                }
            }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}




//
//  OrderView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 6/4/2566 BE.
//

//import SwiftUI
//import CoreData
//struct OrderView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//        @State private var selectedDate = Date()
//        @State private var orders: [Order] = []
//
//        var body: some View {
//            VStack {
//                DatePicker("Select a date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
//                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .padding()
//
//                List(orders) { order in
//                    VStack(alignment: .leading) {
//                        Text("Total: \(order.total, specifier: "%.2f")")
//                        Text("Date: \(order.timestamp!, formatter: dateFormatter)")
//                    }
//                }
//                .listStyle(PlainListStyle())
//            }
//            .onAppear(perform: fetchOrdersForSelectedDate)
//            .onChange(of: selectedDate) { _ in
//                fetchOrdersForSelectedDate()
//            }
//        }
//
//        private func fetchOrdersForSelectedDate() {
//            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
//            let calendar = Calendar.current
//            let startOfDay = calendar.startOfDay(for: selectedDate)
//            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//            let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startOfDay as NSDate, endOfDay as NSDate)
//            fetchRequest.predicate = predicate
//
//            do {
//                orders = try viewContext.fetch(fetchRequest)
//            } catch {
//                print("Error fetching orders: \(error)")
//            }
//        }
//
//        private let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .short
//            formatter.timeStyle = .short
//            return formatter
//        }()
//    }
//
//struct OrderView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderView()
//    }
//}
