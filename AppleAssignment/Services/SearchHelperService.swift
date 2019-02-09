//
//  SearchHelperService.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-07.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import Foundation
import UIKit

class SearchHelperService {
    static let service = SearchHelperService()
    
    let iTunesSongSearchAPI = "https://itunes.apple.com/search?country=US&entity=musicTrack&term="
    let iTunesLookupAPI = "https://itunes.apple.com/lookup?"
    let AlbumWrapper = "collection"
    let ArtistWrapper = "artist"
    
    // MARK: - Song Search
    
    // Searches for songs given a string
    func searchSongs(_ searchString: String, songs: @escaping ([Song])->()) {
        let query = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let url = URL.init(string: "\(iTunesSongSearchAPI)\(query)") {
            let session = URLSession.shared
            session.dataTask(with: url) {data, response, error in
                if (data != nil) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        songs(self.convertJsonToSongs(json))
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                
                if (error != nil) {
                    print(error!.localizedDescription)
                    return
                }
            }.resume()
        }
    }
    
    // Searches for songs given an album ID
    func lookupSongsForAlbumID(_ id: Int, songs: @escaping([Song])->()) {
        let query = "\(iTunesLookupAPI)entity=song&id=\(id)"
        
        if let url = URL.init(string: query) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if (data != nil) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        songs(self.convertJsonToSongs(json).sorted(by: { $0.trackNumber < $1.trackNumber }))
                    }
                    catch {
                        print(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    // Converts a Json response to Song objects
    func convertJsonToSongs(_ json: [String: Any])-> [Song] {
        var output: [Song] = []
        if let songs = json["results"] as? [[String: Any]] {
            for song in songs {
                if (song["wrapperType"] as? String == "track") {
                
                    let currSong = Song.init(song["trackName"] as? String,
                                             song["artistName"] as? String,
                                             song["collectionName"] as? String,
                                             song["artworkUrl100"] as? String,
                                             song["artistId"] as? Int,
                                             song["collectionId"] as? Int,
                                             song["releaseDate"] as? String,
                                             song["trackNumber"] as? Int)
                    output.append(currSong)
                }
            }
        }
        
        return output
    }
    
    
    // MARK: - Album Search
    
    // Searches for an album given an artist's ID
    func lookupAlbumsForArtistID(_ id: Int, albums: @escaping ([Album])->()) {
        let query = "\(iTunesLookupAPI)entity=album&id=\(id)"
        
        if let url = URL.init(string: query) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if (data != nil) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        albums(self.convertJsonToAlbums(json).sorted(by: { $0.releaseDate > $1.releaseDate }))
                    }
                    catch {
                        print(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    // Converts a Json response to Album objects
    func convertJsonToAlbums(_ json: [String: Any])-> [Album] {
        var output: [Album] = []
        if let albums = json["results"] as? [[String: Any]] {
            for album in albums {
                if album["wrapperType"] as? String == "collection" {
                    if let albumName = album["collectionName"] as? String,
                        let artistName = album["artistName"] as? String,
                        let albumID = album["collectionId"] as? Int {
                        
                        let tempAlbum = Album.init(albumName,
                                                   artistName,
                                                   album["primaryGenreName"] as? String,
                                                   album["artworkUrl100"] as? String,
                                                   album["releaseDate"] as? String,
                                                   albumID)
                        output.append(tempAlbum)
                    }
                }
            }
        }
        
        return output
    }
    
    // Given a URL get the corresponding image
    func getAlbumCover(url: URL)-> UIImage? {
        if let data = try? Data.init(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}
