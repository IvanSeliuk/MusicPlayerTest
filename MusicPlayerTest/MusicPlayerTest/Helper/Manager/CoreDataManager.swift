//
//  CoreDataManager.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 8.11.22.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    enum CurrentStateLike {
        case added, removed
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MusicPlayerDataBase")
        print(NSPersistentContainer.defaultDirectoryURL())          // путь к базе
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func likeOrRemoveSong(where songID: Int64, by song: Song) -> CurrentStateLike {
        let fetchRequest = LikeSongDB.fetchRequest(where: songID)
        guard let object = try? context.fetch(fetchRequest).first else {
            // unlike
            let like = LikeSongDB(context: context)
            like.setValues(by: song)
            context.insert(like)
            saveContext()
            NotificationCenter.default.post(name: NSNotification.Name("likedDataBaseDidChange"), object: nil)
            return CurrentStateLike.added
        }
        //liked
        context.delete(object)
        saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("likedDataBaseDidChange"), object: nil)
        return CurrentStateLike.removed
    }
    
    func isLikedSong(from songId: Int64) -> Bool? {
        let fetchRequest = LikeSongDB.fetchRequest(where: songId)
        return try? context.fetch(fetchRequest).first != nil
    }
    
    //    func removeRowFromDB(by date: Date) {
    //        let row = LikeSongDB.fetchRequestToDelete(with: date)
    //        guard let rowDB = try? context.fetch(row).first else { return }
    //        context.delete(rowDB)
    //        saveContext()
    //    }
    
    func getLikedSongs() -> [Song] {
        let request = LikeSongDB.fetchRequest()
        return (try? self.context.fetch(request))?.compactMap({ $0.getMappedSong() }) ?? []
    }
    
    func clearDataBase() {
        let likeSongs = LikeSongDB.fetchRequest()
        do {
            let songsDB = try context.fetch(likeSongs)
            songsDB.forEach {
                context.delete($0)
            }
            saveContext()
        } catch (let e) {
            print(e.localizedDescription)
        }
    }
    
    private func saveContext () {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
