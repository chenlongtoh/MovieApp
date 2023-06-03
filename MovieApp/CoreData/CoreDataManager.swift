//
//  CoreDataStack.swift
//  MovieApp
//
//  Created by Lumos - Toh Chen Long on 03/06/2023.
//

import Foundation
import CoreData

let modelName = "Movie"
class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func movies() -> [MovieCoreData] {
        let request: NSFetchRequest<MovieCoreData> = MovieCoreData.fetchRequest()
        var fetchedMovies: [MovieCoreData] = []
        
        do {
            fetchedMovies = try storeContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedMovies
        
    }
}
