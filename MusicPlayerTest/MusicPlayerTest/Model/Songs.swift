//
//  Songs.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 6.09.22.
//

import Foundation

struct Song {
    let name: String
    let image: String
    let artist: String
    let fileName: String
    let idSong: Int64
}

extension Song {
    static func getSong() -> [Song] {
        return [
            Song(name: "Take It Smart", image: "Take it Smart Boris Brejcha1", artist: "Boris Brejcha", fileName: "Boris_Brejcha_-_Take_It_Smart_(musmore.com)", idSong: 0),
            Song(name: "FILV x LINIUS", image: "FILV x LINIUS Malumup", artist: "Malumup", fileName: "Malumup - FILV x LINIUS - Dont Wanna Go Home", idSong: 1),
            Song(name: "Shouse - Love Tonight", image: "Love Tonight David Guetta", artist: "David Guetta", fileName: "Shouse - Love Tonight (David Guetta Remix)", idSong: 2),
            Song(name: "Fuck You", image: "fuck you", artist: "Silent Child", fileName: "Silent_Child_-_Fuck_You_(musmore.com)", idSong: 3),
            Song(name: "Mask", image: "Mask KVPV", artist: "KVPV", fileName: "KVPV - Mask", idSong: 4),
            Song(name: "Rolling In The Deep", image: "AdeleSong", artist: "ADELE", fileName: "Adele - Rolling In The Deep", idSong: 5),
            Song(name: "Someone Like You", image: "adele someone", artist: "ADELE", fileName: "Adele - Someone Like You (Messed Dubst", idSong: 6),
            Song(name: "TO THE MOON", image: "to the moon", artist: "Jnr Choi & Sam Tompkins", fileName: "Jnr Choi - TO THE MOON (feat. Sam Tompkins)", idSong: 7),
            Song(name: "WEEKEND", image: "weekend", artist: "Jordan Burns", fileName: "jordan-burns-weekend-slowed", idSong: 8),
            Song(name: "The Last Goodbye", image: "the last goodbye2", artist: "ODESZA feat. Bettye Lavette", fileName: "ODESZA feat. Bettye Lavette - The Last Goodbye", idSong: 9),
            Song(name: "Fake", image: "Fake", artist: "The Tech Thieves", fileName: "The Tech Thieves - Fake", idSong: 10)
            ]
    }
}
