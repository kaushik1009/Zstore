//
//  Store.swift
//  Zstore
//
//  Created by kaushik on 27/05/24.
//

import Foundation
import CoreData

struct Store: Codable {
    let category: [Category]
    let card_offers: [CardOffer]
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case category
        case card_offers
        case products
    }
}

struct CardOffer: Codable {
    let id: String
    let percentage: Int
    let card_name, offer_desc, max_discount: String
    let image_url: String

    enum CodingKeys: String, CodingKey {
        case id, percentage
        case card_name
        case offer_desc
        case max_discount
        case image_url
    }
}

struct Category: Codable {
    let id, name, layout: String
}

struct Product: Codable {
    let id, name: String
    let rating: Double
    let review_count: Int
    let price: Double
    let category_id: String
    let card_offer_ids: [String]
    let image_url: String
    let description: String
    let colors: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, rating
        case review_count
        case price
        case category_id
        case card_offer_ids
        case image_url
        case description, colors
    }
}

@objc(Sample)
public class Prod: NSManagedObject {

}

extension Prod {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Prod> {
        return NSFetchRequest<Prod>(entityName: "Prod")
    }
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var rating: Double
    @NSManaged public var review_count: Int32
    @NSManaged public var price: Double
    @NSManaged public var category_id: String
    @NSManaged public var card_offer_ids: String
    @NSManaged public var image_url: String
    @NSManaged public var desc: String
    @NSManaged public var colors: [String]?
}
