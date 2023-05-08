//
//  Order+CoreDataProperties.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 23/4/2566 BE.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var customer: String?
    @NSManaged public var total: Float
    @NSManaged public var timestamp: Date?
    @NSManaged public var orderToItem: Set<Item>?
//    @NSManaged public var orderToItem: Set<Item>?
    
    public var item: [Item]{
        if let setOfItem = orderToItem {
            return setOfItem.sorted {
                $0.id > $1.id
            }
        } else {
            return []
        }
    }

}

// MARK: Generated accessors for orderToItem
extension Order {

    @objc(addOrderToItemObject:)
    @NSManaged public func addToOrderToItem(_ value: Item)

    @objc(removeOrderToItemObject:)
    @NSManaged public func removeFromOrderToItem(_ value: Item)

    @objc(addOrderToItem:)
    @NSManaged public func addToOrderToItem(_ values: NSSet)

    @objc(removeOrderToItem:)
    @NSManaged public func removeFromOrderToItem(_ values: NSSet)

}

extension Order : Identifiable {

}
