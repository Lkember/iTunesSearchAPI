//
//  ArtistViewController.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-08.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var albumTableView: UITableView!
    var song: Song?
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        albumTableView.delegate = self
        albumTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = song!.artistLabel
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCell(_:)), name: NSNotification.Name(rawValue: "ImageLoaded"), object: nil)
        
        DispatchQueue.global().async {
            SearchHelperService.service.lookupAlbumsForArtistID(self.song!.artistID!) { albums in
                self.albums = albums
                
                DispatchQueue.main.async {
                    self.albumTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumTableView.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumTableViewCell
        cell.updateCell(album: albums[indexPath.row])
        
        return cell
    }
    
    @objc func updateCell(_ sender: Any) {
        if let album = sender as? Album {
            for i in 0..<albums.count {
                if (albums[i] == album) {
                    let index = IndexPath.init(row: i, section: 0)
                    albumTableView.reloadRows(at: [index], with: .fade)
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.albumTableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? AlbumViewController {
            if let cell = sender as? AlbumTableViewCell {
                if let index = albumTableView.indexPathForSelectedRow {
                    dvc.album = albums[index.row]
                }
            }
        }
    }
 

}
