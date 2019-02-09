//
//  Song.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-07.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class Song: NSObject {
    var albumCover: UIImage = #imageLiteral(resourceName: "MissingAlbum")
    var albumCoverURL: URL?
    var songTitle: String = "Unknown"
    var artistLabel: String = "Unknown"
    var albumLabel: String = "Unknown"
    var artistID: Int?
    var albumID: Int?
    var releaseYear: String?
    var trackNumber: Int
    
    init(_ song: String?, _ artist: String?, _ album: String?, _ albumURL: String?,
        _ artistID: Int?, _ albumID: Int?, _ release: String?, _ trackNumber: Int?) {
        
        if song != nil {
            songTitle = song!
        }
        if artist != nil {
            artistLabel = artist!
        }
        if album != nil {
            albumLabel = album!
        }
        if (albumURL != nil && albumURL != "") {
            albumCoverURL = URL.init(string: albumURL!)
        }
        else {
            albumCoverURL = nil
        }
        
        if (release != nil) {
            self.releaseYear = String(release!.prefix(4))
        }
        
        self.artistID = artistID
        self.albumID = albumID
        if (trackNumber != nil) {
            self.trackNumber = trackNumber!
        }
        else {
            self.trackNumber = 0
        }
        
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
