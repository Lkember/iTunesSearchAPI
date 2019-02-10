//
//  AlbumViewController.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-08.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumNameLabel: UITextView!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var songTableView: UITableView!
    var song: Song?
    var album: Album?
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        songTableView.delegate = self
        songTableView.dataSource = self
        
        albumCover.layer.cornerRadius = 5
        albumCover.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (song != nil) {
            title = song!.artistLabel
            
            albumCover.image = song!.albumCover
            albumNameLabel.text = song!.albumLabel
            releaseYearLabel.text = "Released: \(song!.releaseYear ?? "Unknown")"
            
            DispatchQueue.global().async {
                SearchHelperService.service.lookupSongsForAlbumID(self.song!.albumID!) { songs in
                    self.songs = songs
                    
                    DispatchQueue.main.async {
                        self.songTableView.reloadData()
                    }
                }
            }
        }
        else {
            albumCover.image = album!.albumCover
            albumNameLabel.text = album!.albumName
            releaseYearLabel.text = "\(album!.releaseDate)"
            title = album!.artistName
            
            DispatchQueue.global().async {
                SearchHelperService.service.lookupSongsForAlbumID(self.album!.albumID) { songs in
                    self.songs = songs
                    
                    DispatchQueue.main.async {
                        self.songTableView.reloadData()
                    }
                }
            }
        }
    }

    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = songTableView.dequeueReusableCell(withIdentifier: "AlbumSongCell") as? AlbumSongTableViewCell {
            cell.updateCell(song: songs[indexPath.row])
            return cell
        }
        else {
            return UITableViewCell.init()
        }
    }

}
