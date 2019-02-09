//
//  Album.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-08.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class Album: NSObject {
    var albumName: String
    var artistName: String
    var albumGenre: String = "Unknown"
    var songs: [Song] = []
    var albumCoverURL: URL?
    var albumCover: UIImage = #imageLiteral(resourceName: "MissingAlbum")
    var releaseDate: Int = 0
    var albumID: Int
    
    init(_ name: String, _ artist: String, _ genre: String?, _ albumCoverURL: String?, _ release: String?, _ albumID: Int) {
        albumName = name
        artistName = artist
        self.albumID = albumID
        if (genre != nil) {
            albumGenre = genre!
        }
        if albumCoverURL != nil {
            self.albumCoverURL = URL.init(string: albumCoverURL!)
        }
        
        releaseDate = Int(String(release!.prefix(4))) ?? 0
        
        super.init()
        
        if (albumCoverURL != nil) {
            DispatchQueue.global().async {
                if let img = SearchHelperService.service.getAlbumCover(url: self.albumCoverURL!) {
                    self.albumCover = img
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ImageLoaded"), object: self)
                }
            }
        }
    }
}
