import Foundation
import CoreData
// import LogService

/// Provides Managed object context's to interact with the database provided by Core Data.
final class ContextProvider: NSObject {

    let datastoreProvider: DatastoreProvider?

    init(with datastoreProvider: DatastoreProvider) {
        self.datastoreProvider = datastoreProvider
        super.init()
    }

    /// A master context reference, with PrivateQueueConcurrency Type.
    lazy var masterManagedObjectContextInstance: NSManagedObjectContext = {
        var masterManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterManagedObjectContext.persistentStoreCoordinator = datastoreProvider?.persistentStoreCoordinator
        masterManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return masterManagedObjectContext
    }()

    /// A main context reference, with MainQueueuConcurrency Type.
    lazy var mainManagedObjectContextInstance: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = datastoreProvider?.persistentStoreCoordinator
        mainManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return mainManagedObjectContext
    }()

    // MARK: - Core Data Saving support

    /// Saves changes from the Main Context to the Master Managed Object Context.
    func saveContext() {
        defer {
            do {
                try masterManagedObjectContextInstance.save()
            } catch let masterMocSaveError as NSError {
                // LogService.print("Master Managed Object Context save error: \(masterMocSaveError.localizedDescription)")
            } catch {
                // LogService.print("Master Managed Object Context save error.")
            }
        }

        if mainManagedObjectContextInstance.hasChanges {
            mergeChangesFromMainContext()
        }
    }

    /// Merge Changes on the Main Context to the Master Context.
    private func mergeChangesFromMainContext() {
        DispatchQueue.main.async(
            execute: {
                do {
                    try self.mainManagedObjectContextInstance.save()
                } catch let mocSaveError as NSError {
                    // LogService.print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
                } catch {
                    // LogService.print("Master Managed Object Context error.")
                }
            }
        )
    }

}
