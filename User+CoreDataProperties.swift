//
//  User+CoreDataProperties.swift
//  afterstore
//
//  Created by KOng's Macbook Pro on 1/5/2566 BE.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int16
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var storeName: String?
    @NSManaged public var userImage: Data?
    @NSManaged public var userToProduct: Set<Product>?
    @NSManaged public var userToCategory: Set<Category>?
    @NSManaged public var userToOrder: Set<Order>?
//    @NSManaged public var orderToItem: Set<Item>?
//    @NSManaged public var orderToItem: Set<Item>?
    
    public var product: [Product]{
        if let setOfProduct = orderToProduct {
            return setOfProduct.sorted {
                $0.id > $1.id
            }
        } else {
            return []
        }
    }
    public var category: [Category]{
        if let setOfCategory = orderToCategory {
            return setOfCategory.sorted {
                $0.id > $1.id
            }
        } else {
            return []
        }
    }
    public var order: [Order]{
        if let setOfOrder = orderToOrder {
            return setOfOrder.sorted {
                $0.id > $1.id
            }
        } else {
            return []
        }
    }
    

}

// MARK: Generated accessors for userToProduct
extension User {

    @objc(addUserToProductObject:)
    @NSManaged public func addToUserToProduct(_ value: Product)

    @objc(removeUserToProductObject:)
    @NSManaged public func removeFromUserToProduct(_ value: Product)

    @objc(addUserToProduct:)
    @NSManaged public func addToUserToProduct(_ values: NSSet)

    @objc(removeUserToProduct:)
    @NSManaged public func removeFromUserToProduct(_ values: NSSet)

}

// MARK: Generated accessors for userToCategory
extension User {

    @objc(addUserToCategoryObject:)
    @NSManaged public func addToUserToCategory(_ value: Category)

    @objc(removeUserToCategoryObject:)
    @NSManaged public func removeFromUserToCategory(_ value: Category)

    @objc(addUserToCategory:)
    @NSManaged public func addToUserToCategory(_ values: NSSet)

    @objc(removeUserToCategory:)
    @NSManaged public func removeFromUserToCategory(_ values: NSSet)

}

// MARK: Generated accessors for userToOrder
extension User {

    @objc(addUserToOrderObject:)
    @NSManaged public func addToUserToOrder(_ value: Order)

    @objc(removeUserToOrderObject:)
    @NSManaged public func removeFromUserToOrder(_ value: Order)

    @objc(addUserToOrder:)
    @NSManaged public func addToUserToOrder(_ values: NSSet)

    @objc(removeUserToOrder:)
    @NSManaged public func removeFromUserToOrder(_ values: NSSet)

}

extension User : Identifiable {

}
