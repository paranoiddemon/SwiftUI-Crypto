//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import Foundation
import CoreData



class PortfolioDataService {
    
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    private let container: NSPersistentContainer
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores{(_, error) in
            if let error = error {
                print("Error loading Core data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            print("try get called")
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Error loading Core data! \(error)")
        }
    }
    // MARK: PUBLIC
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // 是否存在
        print(amount)
        if let entity = savedEntities.first(where: {savedEntity -> Bool in
            return savedEntity.coinID == coin.id
        }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
                print("update called")
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
            print("add called")
        }
    }
    
    // MARK: PRIVATE
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext) // entity是从context中构造的，所以能save到context
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
   }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error loading Core data! \(error)")
        }
    }
    
    // 重新获取
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
