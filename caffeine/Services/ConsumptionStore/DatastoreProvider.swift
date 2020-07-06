import Foundation
import CoreData

/// Holds the data store, which is stored in the document's directory of the application.
final class DatastoreProvider: NSObject {

    private let objectModelName = "Consumption"
    private let objectModelExtension = "momd"
    private let dbFilename = "Consumption.sqlite"

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return urls[urls.count - 1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: type(of: self))
        // swiftlint:disable force_unwrapping
        let modelURL = bundle.url(
            forResource: objectModelName,
            withExtension: objectModelExtension
        )!
        return NSManagedObjectModel(contentsOf: modelURL)!
        // swiftlint:enable force_unwrapping
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent(dbFilename)

        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: url,
                options: nil
            )
        } catch {
            abort()
        }

        return coordinator
    }()
}
