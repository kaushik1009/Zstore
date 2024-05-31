//
//  HomeViewModel.swift
//  Zstore
//
//  Created by kaushik on 27/05/24.
//

import Foundation
import UIKit
import CoreData

class HomeViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Prod>!
    
    func fetchStoreData(_ completion: @escaping ((Store?) -> Void)) {
        let url = "https://raw.githubusercontent.com/princesolomon/zstore/main/data.json"
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(Store.self, from: data)
                    if UserDefaults.standard.object(forKey: "CoreDataSaved") == nil {
                        for productData in json.products {
                            let product = Prod(context: context)
                            product.id = productData.id
                            product.name = productData.name
                            product.rating = productData.rating
                            product.review_count = Int32(productData.review_count)
                            product.price = productData.price
                            product.category_id = productData.category_id
                            var sample = ""
                            productData.card_offer_ids.forEach { id in
                                sample += "\(id),"
                            }
                            product.card_offer_ids = sample
                            product.image_url = productData.image_url
                            product.desc = productData.description
                            product.colors = productData.colors
                        }
                        try context.save()
                        UserDefaults.standard.setValue(true, forKey: "CoreDataSaved")
                    }
                    completion(json)
                } catch let error as NSError {
                    print("***** Error - \(error)")
                }
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, _ imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func fetchRequest(_ predicate: NSPredicate, _ sortBy: String, _ completion: @escaping (() -> Void)) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        let fetchRequest: NSFetchRequest<Prod> = Prod.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: false)]
        fetchRequest.predicate = predicate
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
            try context.save()
            completion()
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
}
