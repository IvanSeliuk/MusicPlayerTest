//
//  LikeSongDB+CoreDataProperties.swift
//  
//
//  Created by Иван Селюк on 8.11.22.
//
//

import Foundation
import CoreData


extension LikeSongDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikeSongDB> {
        return NSFetchRequest<LikeSongDB>(entityName: "LikeSongDB")
    }
    
    @nonobjc public class func fetchRequest(where songID: Int64) -> NSFetchRequest<LikeSongDB> {
        let request = NSFetchRequest<LikeSongDB>(entityName: "LikeSongDB")
        request.predicate = NSPredicate(format: "songID == %d", songID)
        return request
    }
    
//    @nonobjc public class func fetchRequestToDelete(with songID: Int64) -> NSFetchRequest<LikeSongDB> {
//        let request = NSFetchRequest<LikeSongDB>(entityName: "LikeSongDB")
//        request.predicate = NSPredicate(format: "songID == %d", songID)
//        return request
//    }

    @NSManaged public var songID: Int64
    @NSManaged public var name: String?
    @NSManaged public var artist: String?
    @NSManaged public var fileName: String?
    @NSManaged public var image: String?

    func getMappedSong() -> Song {
        return Song(name: name ?? "",
                    image: image ?? "",
                    artist: artist ?? "",
                    fileName: fileName ?? "",
                    idSong: songID)
    }
    
    func setValues(by song: Song) {
        self.name = song.name
        self.image = song.image
        self.artist = song.artist
        self.fileName = song.fileName
        self.songID = song.idSong
    }
}
