import Foundation
import UIKit
import CoreData
// import LogService

/// A service class that supports the storage and merge process of multiple managed object contexts.
final class PersistenceService: NSObject {

    private var mainContextInstance: NSManagedObjectContext

    static var shared: PersistenceService = .init()

    private override init() {
        mainContextInstance = (UIApplication.shared.delegate as? AppDelegate)!
            .contextProvider.mainManagedObjectContextInstance
        super.init()
    }

    ///      Get a reference to the Main Context Instance
    ///
    /// - Returns: Main NSmanagedObjectContext
    func getMainContextInstance() -> NSManagedObjectContext {
        return mainContextInstance
    }

    /// Save the current work/changes done on the worker contexts (the minion workers).
    ///
    /// - Parameter workerContext: NSManagedObjectContext The Minion worker Context that has to be saved.
    func saveWorkerContext(_ workerContext: NSManagedObjectContext) {
        //Persist new Event to datastore (via Managed Object Context Layer).
        do {
            if workerContext.hasChanges {
                try workerContext.save()
            }
        } catch let saveError as NSError {
            // LogService.dump(saveError)

            // TODO: Not cool either.
            Swift.assertionFailure(saveError.localizedDescription)
        } catch {
            // LogService.dump(error)
        }
    }

    /// Save and merge the current work/changes done on the minion workers with Main context.
    func mergeWithMainContext() {
        do {
            if mainContextInstance.hasChanges {
                try mainContextInstance.save()
            }
        } catch let saveError as NSError {
            // LogService.dump(saveError)

            // TODO: clear the core data model and download again.
            Swift.fatalError()
        } catch {
            // LogService.dump(error)
        }
    }

}
