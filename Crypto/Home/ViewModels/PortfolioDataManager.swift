//
//  PortfolioDataManager.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-03.
//

import CoreData

class PortfolioDataManager {
    static let shared = PortfolioDataManager()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    @Published private(set) var coins: [Coin] = []
    
    init() {
        container = NSPersistentContainer(name: "CryptoPortfolio")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Couldn't load persistent store of CoreData. Error: \(error)")
            }
        }
        fetchCoins()
    }
    
    // update coin info to CoreData
    func update(from info: CoinInfo, holding: Double) {
        // look up the coin entity in Core Data by id
        let request = fetchRequest(NSPredicate(format: "id = %@", info.id))
        let results = (try? context.fetch(request)) ?? []
        // if it already exist in CoreData, update/delete it
        if let coin = results.first {
            if holding > 0 {
                coin.holding = holding
            } else {
                context.delete(coin)
            }
        } else { // if it does not exist, create new one
            let newCoin = Coin(context: context)
            newCoin.id = info.id
            newCoin.holding = holding
        }
        saveChanges()
    }
    
    // MARK: - Private method(s)
    
    // fetch all coin entities in Core Data
    private func fetchCoins() {
        let request = fetchRequest(NSPredicate.all)
        self.coins = (try? context.fetch(request)) ?? []
    }
    
    // save changes in CoreData and update changes the coins store
    private func saveChanges() {
        try? context.save()
        fetchCoins()
    }
    
    // a method used to create a fetch request to Core Data based on a predicate
    private func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Coin> {
        let request = NSFetchRequest<Coin>(entityName: "Coin")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        request.predicate = predicate
        return request
    }
}
