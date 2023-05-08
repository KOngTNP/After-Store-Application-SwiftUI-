//
//  Category+CoreDataProperties.swift
//  afterStore
//
//  Created by KOng's Macbook Pro on 19/4/2566 BE.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var categoryToProduct: Set<Product>?
    
    public var product: [Product]{
        let setOfProduct = categoryToProduct
        return setOfProduct!.sorted{
            $0.id > $1.id
        }
    }
}

// MARK: Generated accessors for categoryToProduct
extension Category {

    @objc(addCategoryToProductObject:)
    @NSManaged public func addToCategoryToProduct(_ value: Product)

    @objc(removeCategoryToProductObject:)
    @NSManaged public func removeFromCategoryToProduct(_ value: Product)

    @objc(addCategoryToProduct:)
    @NSManaged public func addToCategoryToProduct(_ values: NSSet)

    @objc(removeCategoryToProduct:)
    @NSManaged public func removeFromCategoryToProduct(_ values: NSSet)

}

extension Category : Identifiable {

}
