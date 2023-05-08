//
//  HomeView.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 5/4/2566 BE.
//

import CoreData
import SwiftUI
import Charts
//import line
extension Date {
    var startOfWeek: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    var startOfDay: Date {
            return Calendar.current.startOfDay(for: self)
        }

        var endOfDay: Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfDay)!
        }
}
struct OrderData: Hashable {
    let date: String
    let total: Double
}

struct HomeView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State private var selection: String? = "Daily"
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var customer: String = "New Order Card"
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp,ascending: false)])
    private var items:FetchedResults<Item>
    
    var body: some View {
        
        VStack{ //Open VStack
            ZStack{
                Rectangle()
                    .fill(Color(red: 1, green: 1, blue: 1))
                    .frame(width: 355, height: 55)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                HStack{
                    HStack{
                        Image("AfterStore_Logo_black")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 110)
                    } //Close HStack
                    .padding(.trailing, 150)
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
            } //Close ZStack
            VStack {
                Text("WELCOME TO \(userAuth.currentUser?.storeName ?? "YOUR STORE")")
                    .font(.system(size: 16))
                    .fontWeight(.heavy)
                    .padding(.top, 5)
                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                    .offset(x:110)
//                    .position(y: 20)
                    .frame(width: 340, alignment: .leading)
                Text("Income Graph")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .offset(y:100)
                    .padding(.top, -170)
                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                .position(x: 70, y: 60)
                ZStack {
                    Rectangle()
                        .fill(Color(red: 1, green: 1, blue: 1))
                        .frame(width: 355, height: 280)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                    Chart {
                        if selection == "Daily" || selection == "Weekly"{
                            ForEach(getTotalGroupByDay(), id: \.self) { data in
                                LineMark(x: .value("Day", data.date), y: .value("Total", data.total))
                            }
                            .symbol(Circle())
                            .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.monotone)
                        }
                        else if selection == "Monthly"{
                            ForEach(getTotalGroupByMonth(), id: \.self) { data in
                                LineMark(x: .value("Day", data.date), y: .value("Total", data.total))
                            }
                            .symbol(Circle())
                            .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.monotone)
                        }
                    }
                    .offset(x:5)
                    .frame(width: 300, height: 220)
                }
                .offset(y:-160)
//                VStack{
//                    ForEach(getTotalGroupByDay(), id: \.self) { data in
//                        Text(String(format: "%.2f", data.total))
//                        Text("\(data.date)")
//                    }
//                }
                VStack {
                    HStack {
                        Text("Products Counting")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .offset(x: -35)
                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                        VStack {
                            Menu {
                                Button("Monthly", action: { selection = "Monthly" })
                                Button("Weekly", action: { selection = "Weekly" })
                                Button("Daily", action: { selection = "Daily" })
                            } label: {
                                Text(selection ?? "Select")
                                    .foregroundColor(selection == nil ? .gray : .white)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: 25)
                                Image(systemName: "chevron.down")
                                    .offset(x: -10)
                            }
                        }
                        .frame(width: 130, height: 34)
                        .foregroundColor(Color.white)
                        .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                        .offset(x: 45)
                    }
                    ScrollView {
                        VStack {
//                            ForEach(getItemsThisWeek()){item in
//                                Text("Baht \(item.price, specifier: "%.2f")")
//                                        }
//                            Chart{
//                                ForEach(getOrderDataForLineChart(), id: \.0) { data in
//                                    LineMark(value: data.1)
//                                }
//                            }
                            
                            if selection == "Daily" {
                                ForEach(Array(getGroupProductDay().sorted(by: { $0.key.name ?? "" < $1.key.name ?? "" })), id: \.key) { (product, quantity) in
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(red: 1, green: 1, blue: 1))
                                            .frame(width: 355, height: 75)
                                            .cornerRadius(15)
                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                        HStack{
                                            if (product.productImage != nil){
                                                Image(uiImage: UIImage(data: product.productImage!)!)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 60, height: 60)
                                                
                                            }
                                            VStack(alignment: .leading){
                                                Text((product.name ?? ""))
                                                    .font(.title2)
                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                            }
                                            Spacer()
                                            Text("x\(quantity)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                        }
                                        .frame(width: 310)
                                    }
                                }
                            }
                            else if selection == "Weekly" {
                                ForEach(Array(getGroupProductWeek().sorted(by: { $0.key.name ?? "" < $1.key.name ?? "" })), id: \.key) { (product, quantity) in
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(red: 1, green: 1, blue: 1))
                                            .frame(width: 355, height: 75)
                                            .cornerRadius(15)
                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                        HStack{
                                            if (product.productImage != nil){
                                                Image(uiImage: UIImage(data: product.productImage!)!)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 60, height: 60)
                                                
                                            }
                                            VStack(alignment: .leading){
                                                Text((product.name ?? ""))
                                                    .font(.title2)
                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                            }
                                            Spacer()
                                            Text("x\(quantity)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                        }
                                        .frame(width: 310)
                                    }
                                }
                            }
                            else if selection == "Monthly" {
                                ForEach(Array(getGroupProductMonth().sorted(by: { $0.key.name ?? "" < $1.key.name ?? "" })), id: \.key) { (product, quantity) in
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(red: 1, green: 1, blue: 1))
                                            .frame(width: 355, height: 75)
                                            .cornerRadius(15)
                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
                                        HStack{
                                            if (product.productImage != nil){
                                                Image(uiImage: UIImage(data: product.productImage!)!)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 60, height: 60)
                                                
                                            }
                                            VStack(alignment: .leading){
                                                Text((product.name ?? ""))
                                                    .font(.title2)
                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                            }
                                            Spacer()
                                            Text("x\(quantity)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
                                        }
                                        .frame(width: 310)
                                    }
                                }
                            }
                            
                            
                            
                        }
                    }
                }
                .padding(.top, -160)
                
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
    private func getGroupProductWeek() -> [Product: Int] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
        
        // Get start of the current week
        let calendar = Calendar(identifier: .gregorian)
        let startOfWeek = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfWeek)
        guard let start = calendar.date(from: components) else {
            print("Error getting start of week")
            return [:]
        }
        
        // Add filter for items with timestamp in the current week
        let predicate = NSPredicate(format: "timestamp >= %@ && timestamp < %@", argumentArray: [start as NSDate, start.addingTimeInterval(7 * 24 * 60 * 60) as NSDate])
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        var productQuantities: [Product: Int] = [:]
        
        do {
            let items = try viewContext.fetch(fetchRequest)
            for item in items {
                guard let product = item.itemToProduct else { continue }
                let quantity = Int(item.quantity)
                
                productQuantities[product, default: 0] += quantity
            }
        } catch {
            print("Error fetching items: \(error)")
        }
        
        return productQuantities
    }
    private func getGroupProductDay() -> [Product: Int] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", argumentArray: [Date().startOfDay as NSDate, Date().endOfDay as NSDate])
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        var productQuantities: [Product: Int] = [:]
        
        do {
            let items = try viewContext.fetch(fetchRequest)
            for item in items {
                guard let product = item.itemToProduct else { continue }
                let quantity = item.quantity
                
                productQuantities[product, default: 0] += Int(quantity)
            }
        } catch {
            print("Error fetching items: \(error)")
        }
        
        return productQuantities
    }
    private func getGroupProductMonth() -> [Product: Int] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", argumentArray: [startOfMonth as NSDate, endOfMonth as NSDate])
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate

        var productQuantities: [Product: Int] = [:]

        do {
            let items = try viewContext.fetch(fetchRequest)
            for item in items {
                guard let product = item.itemToProduct else { continue }
                let quantity = item.quantity

                productQuantities[product, default: 0] += Int(quantity)
            }
        } catch {
            print("Error fetching items: \(error)")
        }

        return productQuantities
    }
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
//
//        let currentDate = Date()
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: currentDate)
//        let month = calendar.component(.month, from: currentDate)
//        let nextMonth = month == 12 ? 1 : month + 1
//        let startOfMonth = DateComponents(year: year, month: month, day: 1).date!
//        let endOfMonth = DateComponents(year: year, month: nextMonth, day: 0).date!
//
//        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", startOfMonth as NSDate, endOfMonth as NSDate)
//
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = predicate
//
//        var productQuantities: [Product: Int] = [:]
//
//        do {
//            let items = try viewContext.fetch(fetchRequest)
//            for item in items {
//                guard let product = item.itemToProduct else { continue }
//                let productId = product.objectID
//                let quantity = item.quantity
//
//                productQuantities[product, default: 0] += Int(quantity)
//            }
//        } catch {
//            print("Error fetching items: \(error)")
//        }
//
//        return productQuantities
//    }
    
        private func getItemsThisWeek() -> [Item] {
            let calendar = Calendar.current
            let today = Date()
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            return items.filter { item in
                if let timestamp = item.timestamp {
                    return startOfWeek...endOfWeek ~= timestamp
                }
                return false
            }
        }
    
    func getTotalGroupByDay() -> [OrderData] {
        var groupedData: [OrderData] = []
        
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Order.timestamp, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        var totalsByDay: [String: Double] = [:]
        let weekdays = calendar.shortWeekdaySymbols.map { $0.capitalized }
        for weekday in weekdays {
            totalsByDay[weekday] = 0
        }
        
        do {
            let orders = try viewContext.fetch(fetchRequest)
            for order in orders {
                guard let orderDate = order.timestamp else { continue }
                if orderDate >= startOfWeek {
                    let components = calendar.dateComponents([.weekday], from: orderDate)
                    let weekday = components.weekday!
                    let weekdayName = weekdays[weekday - 1]
                    totalsByDay[weekdayName]! += Double(order.total)
                }
            }
            
            for weekday in weekdays {
                let total = totalsByDay[weekday]!
                groupedData.append(OrderData(date: weekday, total: total))
            }
            
        } catch {
            print("Error fetching orders: \(error)")
        }
        
        return groupedData
    }
    
    func getTotalGroupByMonth() -> [OrderData] {
        var groupedData: [OrderData] = []
        
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Order.timestamp, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let calendar = Calendar.current
        let today = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        var totalsByMonth: [String: Double] = [:]
        let months = calendar.monthSymbols.map { $0.capitalized }
        for month in months {
            totalsByMonth[month] = 0
        }
        
        do {
            let orders = try viewContext.fetch(fetchRequest)
            for order in orders {
                guard let orderDate = order.timestamp else { continue }
                let components = calendar.dateComponents([.year, .month], from: orderDate)
                let orderStartOfMonth = calendar.date(from: components)!
                if orderStartOfMonth <= startOfMonth {
                    let month = components.month!
                    let monthName = months[month - 1]
                    totalsByMonth[monthName]! += Double(order.total)
                }
            }
            
            for month in months {
                let total = totalsByMonth[month]!
                groupedData.append(OrderData(date: month, total: total))
            }
            
        } catch {
            print("Error fetching orders: \(error)")
        }
        
        return groupedData
    }


    
    
    
    
    
    
    
//        VStack{
//            ZStack{
//                Rectangle()
//                    .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
//                    .frame(width: 355, height: 60)
//                    .cornerRadius(15)
//                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                HStack{
//                    HStack{
//                        Image("AfterStore_Logo_black")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 110)
//                    }
//                    .padding(.trailing, 160)
//                    Button {
//                        // action to perform when the button is tapped
//                    } label: {
//                        Image(systemName: "cart")
//                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
//                            .frame(width: 35, height: 34)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                    }
//                }
//            }
//            Text("WELCOME TO YOUR STORE")
//                .font(.system(size: 20))
//                .fontWeight(.heavy)
//                .offset(x:-40)
//                .padding(.top, 15)
//                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//            Spacer()
//        }
//        .foregroundColor(.green)
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}





////
////  HomeView.swift
////  afterStore
////
////  Created by KOng's Macbook Pro on 5/4/2566 BE.
////
//
//import CoreData
//import SwiftUI
//import Charts
////import line
//extension Date {
//    var startOfWeek: Date {
//        let calendar = Calendar(identifier: .gregorian)
//        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
//        return calendar.date(from: components)!
//    }
//    var startOfDay: Date {
//            return Calendar.current.startOfDay(for: self)
//        }
//
//        var endOfDay: Date {
//            var components = DateComponents()
//            components.day = 1
//            components.second = -1
//            return Calendar.current.date(byAdding: components, to: startOfDay)!
//        }
//}
//struct OrderData: Hashable {
//    let date: String
//    let total: Double
//}
//
//struct HomeView: View {
//    @EnvironmentObject var userAuth: UserAuth
//    @State private var selection: String? = "Daily"
//    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.dismiss) private var dismiss
//    @State var customer: String = "New Order Card"
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp,ascending: false)])
//    private var items:FetchedResults<Item>
//
//    var body: some View {
//
//        VStack{ //Open VStack
//            ZStack{
//                Rectangle()
//                    .fill(Color(red: 1, green: 1, blue: 1))
//                    .frame(width: 355, height: 55)
//                    .cornerRadius(15)
//                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                HStack{
//                    HStack{
//                        Image("AfterStore_Logo_black")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 110)
//                    } //Close HStack
//                    .padding(.trailing, 160)
//                        NavigationLink(destination: CartView().onAppear {
//                            self.saveOrder()
////                            print(getOrderDataForLineChart().dayOfWeek)
////                            print(getGroupProduct().qunatity)
////                            print(getLastOrder()?.customer)
//                        }) {
//                            Text(Image(systemName: "cart"))
//                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
//                                .frame(width: 35, height: 34)
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                        }
//
//
//                } //Close HStack
//            } //Close ZStack
//            VStack {
//
//                Text("Welcome, \(userAuth.currentUser?.email ?? "")!")
//                    .font(.system(size: 18))
//                    .fontWeight(.heavy)
////                    .offset(x:-40)
//                    .padding(.top, 15)
//                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                .position(x: 10, y: 20)
//                Text("Income Graph")
//                    .font(.system(size: 14))
//                    .fontWeight(.bold)
//                    .offset(y:100)
//                    .padding(.top, -170)
//                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
////                .position(x: 70, y: 0)
//                ZStack {
//                    Rectangle()
//                        .fill(Color(red: 1, green: 1, blue: 1))
//                        .frame(width: 355, height: 280)
//                        .cornerRadius(15)
//                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                    Chart {
//                        if selection == "Daily" || selection == "Weekly"{
//                            ForEach(getTotalGroupByDay(), id: \.self) { data in
//                                LineMark(x: .value("Day", data.date), y: .value("Mins", data.total))
//                            }
//                            .symbol(Circle())
//                            .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
//                            .interpolationMethod(.monotone)
//                        }
//                        else if selection == "Monthly"{
//                            ForEach(getTotalGroupByMonth(), id: \.self) { data in
//                                LineMark(x: .value("Day", data.date), y: .value("Mins", data.total))
//                            }
//                            .symbol(Circle())
//                            .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
//                            .interpolationMethod(.monotone)
//                        }
//                    }
//                    .offset(x:5)
//                    .frame(width: 300, height: 220)
//                }
//                .offset(y:-160)
////                VStack{
////                    ForEach(getTotalGroupByDay(), id: \.self) { data in
////                        Text(String(format: "%.2f", data.total))
////                        Text("\(data.date)")
////                    }
////                }
//                VStack {
//                    HStack {
//                        Text("Products Counting")
//                            .font(.system(size: 14))
//                            .fontWeight(.bold)
//                            .offset(x: -35)
//                            .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                        VStack {
//                            Menu {
//                                Button("Monthly", action: { selection = "Monthly" })
//                                Button("Weekly", action: { selection = "Weekly" })
//                                Button("Daily", action: { selection = "Daily" })
//                            } label: {
//                                Text(selection ?? "Select")
//                                    .foregroundColor(selection == nil ? .gray : .white)
//                                    .fontWeight(.bold)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .offset(x: 25)
//                                Image(systemName: "chevron.down")
//                                    .offset(x: -10)
//                            }
//                        }
//                        .frame(width: 130, height: 34)
//                        .foregroundColor(Color.white)
//                        .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
//                        .cornerRadius(28)
//                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                        .offset(x: 45)
//                    }
//                    ScrollView {
//                        VStack {
////                            ForEach(getItemsThisWeek()){item in
////                                Text("Baht \(item.price, specifier: "%.2f")")
////                                        }
////                            Chart{
////                                ForEach(getOrderDataForLineChart(), id: \.0) { data in
////                                    LineMark(value: data.1)
////                                }
////                            }
//
//                            if selection == "Daily" {
//                                ForEach(Array(getGroupProductDay().sorted(by: { $0.key.name ?? "" < $1.key.name ?? "" })), id: \.key) { (product, quantity) in
//                                    ZStack{
//                                        Rectangle()
//                                            .fill(Color(red: 1, green: 1, blue: 1))
//                                            .frame(width: 355, height: 75)
//                                            .cornerRadius(15)
//                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                                        HStack{
//                                            if (product.productImage != nil){
//                                                Image(uiImage: UIImage(data: product.productImage!)!)
//                                                    .resizable()
//                                                    .clipShape(Circle())
//                                                    .frame(width: 60, height: 60)
//
//                                            }
//                                            VStack(alignment: .leading){
//                                                Text((product.name ?? ""))
//                                                    .font(.title2)
//                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                                            }
//                                            Spacer()
//                                            Text("x\(quantity)")
//                                                .font(.title2)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                                        }
//                                        .frame(width: 310)
//                                    }
//                                }
//                            }
//                            else if selection == "Weekly" {
//                                ForEach(Array(getGroupProductWeek().sorted(by: { $0.key.name ?? "" < $1.key.name ?? "" })), id: \.key) { (product, quantity) in
//                                    ZStack{
//                                        Rectangle()
//                                            .fill(Color(red: 1, green: 1, blue: 1))
//                                            .frame(width: 355, height: 75)
//                                            .cornerRadius(15)
//                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                                        HStack{
//                                            if (product.productImage != nil){
//                                                Image(uiImage: UIImage(data: product.productImage!)!)
//                                                    .resizable()
//                                                    .clipShape(Circle())
//                                                    .frame(width: 60, height: 60)
//
//                                            }
//                                            VStack(alignment: .leading){
//                                                Text((product.name ?? ""))
//                                                    .font(.title2)
//                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                                            }
//                                            Spacer()
//                                            Text("x\(quantity)")
//                                                .font(.title2)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                                        }
//                                        .frame(width: 310)
//                                    }
//                                }
//                            }
//                            else if selection == "Monthly" {
//                                ForEach(Array(getGroupProductMonth().sorted(by: { $0.key.name ?? "" < $1.key.name ?? "" })), id: \.key) { (product, quantity) in
//                                    ZStack{
//                                        Rectangle()
//                                            .fill(Color(red: 1, green: 1, blue: 1))
//                                            .frame(width: 355, height: 75)
//                                            .cornerRadius(15)
//                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
//                                        HStack{
//                                            if (product.productImage != nil){
//                                                Image(uiImage: UIImage(data: product.productImage!)!)
//                                                    .resizable()
//                                                    .clipShape(Circle())
//                                                    .frame(width: 60, height: 60)
//
//                                            }
//                                            VStack(alignment: .leading){
//                                                Text((product.name ?? ""))
//                                                    .font(.title2)
//                                                    .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                                            }
//                                            Spacer()
//                                            Text("x\(quantity)")
//                                                .font(.title2)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
//                                        }
//                                        .frame(width: 310)
//                                    }
//                                }
//                            }
//
//
//
//                        }
//                    }
//                }
//                .padding(.top, -160)
//
//            }
//        } //Close VStack
//        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
//        .background(Color(red: 1.0, green: 0.96, blue: 0.95)
//        .edgesIgnoringSafeArea(.all))
//        .onAppear {
//            deleteOrdersWithZeroTotal()
//                }
//    }
//    private func deleteOrdersWithZeroTotal() {
//            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
//            let predicate = NSPredicate(format: "total == 0")
//            fetchRequest.predicate = predicate
//
//            do {
//                let ordersWithZeroTotal = try viewContext.fetch(fetchRequest)
//                for order in ordersWithZeroTotal {
//                    viewContext.delete(order)
//                    print("Deleting orders with zero total")
//                }
//                try viewContext.save()
//            } catch {
//                print("Error deleting orders with zero total: \(error)")
//            }
//        }
//    private func saveOrder(){
//        let newOrder = Order(context: viewContext)
//        newOrder.id = UUID()
//        newOrder.customer = customer
//        newOrder.timestamp = Date()
//        do {
//            try viewContext.save()
//        } catch {
//            print("Failed saving \(error.localizedDescription)")
//        }
//    }
//    private func getLastOrder() -> Order? {
//            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
//            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Order.timestamp, ascending: false)]
//            fetchRequest.fetchLimit = 1
//            do {
//                let orders = try viewContext.fetch(fetchRequest)
//                return orders.first
//            } catch {
//                print("Error fetching records: \(error.localizedDescription)")
//                return nil
//            }
//        }
//    private func getGroupProductWeek() -> [Product: Int] {
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
//
//        // Get start of the current week
//        let calendar = Calendar(identifier: .gregorian)
//        let startOfWeek = calendar.startOfDay(for: Date())
//        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfWeek)
//        guard let start = calendar.date(from: components) else {
//            print("Error getting start of week")
//            return [:]
//        }
//
//        // Add filter for items with timestamp in the current week
//        let predicate = NSPredicate(format: "timestamp >= %@ && timestamp < %@", argumentArray: [start as NSDate, start.addingTimeInterval(7 * 24 * 60 * 60) as NSDate])
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = predicate
//
//        var productQuantities: [Product: Int] = [:]
//
//        do {
//            let items = try viewContext.fetch(fetchRequest)
//            for item in items {
//                guard let product = item.itemToProduct else { continue }
//                let quantity = Int(item.quantity)
//
//                productQuantities[product, default: 0] += quantity
//            }
//        } catch {
//            print("Error fetching items: \(error)")
//        }
//
//        return productQuantities
//    }
//    private func getGroupProductDay() -> [Product: Int] {
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
//        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", argumentArray: [Date().startOfDay as NSDate, Date().endOfDay as NSDate])
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = predicate
//
//        var productQuantities: [Product: Int] = [:]
//
//        do {
//            let items = try viewContext.fetch(fetchRequest)
//            for item in items {
//                guard let product = item.itemToProduct else { continue }
//                let quantity = item.quantity
//
//                productQuantities[product, default: 0] += Int(quantity)
//            }
//        } catch {
//            print("Error fetching items: \(error)")
//        }
//
//        return productQuantities
//    }
//    private func getGroupProductMonth() -> [Product: Int] {
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
//        let currentDate = Date()
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: currentDate)
//        let month = calendar.component(.month, from: currentDate)
//        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
//        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
//        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", argumentArray: [startOfMonth as NSDate, endOfMonth as NSDate])
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = predicate
//
//        var productQuantities: [Product: Int] = [:]
//
//        do {
//            let items = try viewContext.fetch(fetchRequest)
//            for item in items {
//                guard let product = item.itemToProduct else { continue }
//                let quantity = item.quantity
//
//                productQuantities[product, default: 0] += Int(quantity)
//            }
//        } catch {
//            print("Error fetching items: \(error)")
//        }
//
//        return productQuantities
//    }
////        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
////        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
////
////        let currentDate = Date()
////        let calendar = Calendar.current
////        let year = calendar.component(.year, from: currentDate)
////        let month = calendar.component(.month, from: currentDate)
////        let nextMonth = month == 12 ? 1 : month + 1
////        let startOfMonth = DateComponents(year: year, month: month, day: 1).date!
////        let endOfMonth = DateComponents(year: year, month: nextMonth, day: 0).date!
////
////        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", startOfMonth as NSDate, endOfMonth as NSDate)
////
////        fetchRequest.sortDescriptors = [sortDescriptor]
////        fetchRequest.predicate = predicate
////
////        var productQuantities: [Product: Int] = [:]
////
////        do {
////            let items = try viewContext.fetch(fetchRequest)
////            for item in items {
////                guard let product = item.itemToProduct else { continue }
////                let productId = product.objectID
////                let quantity = item.quantity
////
////                productQuantities[product, default: 0] += Int(quantity)
////            }
////        } catch {
////            print("Error fetching items: \(error)")
////        }
////
////        return productQuantities
////    }
//
//        private func getItemsThisWeek() -> [Item] {
//            let calendar = Calendar.current
//            let today = Date()
//            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
//            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
//            return items.filter { item in
//                if let timestamp = item.timestamp {
//                    return startOfWeek...endOfWeek ~= timestamp
//                }
//                return false
//            }
//        }
//
//    func getTotalGroupByDay() -> [OrderData] {
//        var groupedData: [OrderData] = []
//
//        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Order.timestamp, ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        let calendar = Calendar.current
//        let today = Date()
//        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE"
//
//        var totalsByDay: [String: Double] = [:]
//        let weekdays = calendar.shortWeekdaySymbols.map { $0.capitalized }
//        for weekday in weekdays {
//            totalsByDay[weekday] = 0
//        }
//
//        do {
//            let orders = try viewContext.fetch(fetchRequest)
//            for order in orders {
//                guard let orderDate = order.timestamp else { continue }
//                if orderDate >= startOfWeek {
//                    let components = calendar.dateComponents([.weekday], from: orderDate)
//                    let weekday = components.weekday!
//                    let weekdayName = weekdays[weekday - 1]
//                    totalsByDay[weekdayName]! += Double(order.total)
//                }
//            }
//
//            for weekday in weekdays {
//                let total = totalsByDay[weekday]!
//                groupedData.append(OrderData(date: weekday, total: total))
//            }
//
//        } catch {
//            print("Error fetching orders: \(error)")
//        }
//
//        return groupedData
//    }
//
//    func getTotalGroupByMonth() -> [OrderData] {
//        var groupedData: [OrderData] = []
//
//        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Order.timestamp, ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        let calendar = Calendar.current
//        let today = Date()
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM"
//
//        var totalsByMonth: [String: Double] = [:]
//        let months = calendar.monthSymbols.map { $0.capitalized }
//        for month in months {
//            totalsByMonth[month] = 0
//        }
//
//        do {
//            let orders = try viewContext.fetch(fetchRequest)
//            for order in orders {
//                guard let orderDate = order.timestamp else { continue }
//                if orderDate >= startOfMonth {
//                    let components = calendar.dateComponents([.month], from: orderDate)
//                    let month = components.month!
//                    let monthName = months[month - 1]
//                    totalsByMonth[monthName]! += Double(order.total)
//                }
//            }
//
//            for month in months {
//                let total = totalsByMonth[month]!
//                groupedData.append(OrderData(date: month, total: total))
//            }
//
//        } catch {
//            print("Error fetching orders: \(error)")
//        }
//
//        return groupedData
//    }
//
//
//
//
//
//
//
//
//
////        VStack{
////            ZStack{
////                Rectangle()
////                    .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
////                    .frame(width: 355, height: 60)
////                    .cornerRadius(15)
////                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
////                HStack{
////                    HStack{
////                        Image("AfterStore_Logo_black")
////                            .resizable()
////                            .aspectRatio(contentMode: .fit)
////                            .frame(width: 110)
////                    }
////                    .padding(.trailing, 160)
////                    Button {
////                        // action to perform when the button is tapped
////                    } label: {
////                        Image(systemName: "cart")
////                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.4, alpha: 1)))
////                            .frame(width: 35, height: 34)
////                            .background(Color.white)
////                            .cornerRadius(10)
////                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
////                    }
////                }
////            }
////            Text("WELCOME TO YOUR STORE")
////                .font(.system(size: 20))
////                .fontWeight(.heavy)
////                .offset(x:-40)
////                .padding(.top, 15)
////                .foregroundColor(Color(UIColor(red: 23/255, green: 76/255, blue: 79/255, alpha: 1)))
////            Spacer()
////        }
////        .foregroundColor(.green)
////    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
