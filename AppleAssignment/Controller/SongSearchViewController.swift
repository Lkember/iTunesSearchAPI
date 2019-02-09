//
//  ViewController.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-07.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class SongSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    var songs: [Song] = []
    var loadingView: UIView?
    var searchOccurred = false
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songTableView.delegate = self
        songTableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCell(_:)), name: NSNotification.Name(rawValue: "ImageLoaded"), object: nil)
        
        infoView.alpha = 0.0
        self.infoView.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showOrHideInfoView() {
        if (songs.count == 0 && searchOccurred) {
            showInfoView()
        }
        else {
            hideInfoView()
        }
    }
    
    func showInfoView() {
        if (infoView.alpha == 0.0) {
            infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            infoView.alpha = 0.0
            
            self.songTableView.isScrollEnabled = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.infoView.alpha = 1.0
                self.infoView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            });
        }
    }
    
    func hideInfoView() {
        if (infoView.alpha != 0.0) {
            self.songTableView.isScrollEnabled = true
            
            UIView.animate(withDuration: 0.25, animations: {
                self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.infoView.alpha = 0.0;
            })
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let cell = songTableView.dequeueReusableCell(withIdentifier: "SongInfoCell") as! SongTableViewCell
        cell.updateCell(song: song)
        
        if (song.albumID != nil || song.artistID != nil) {
            cell.selectionStyle = .default
        }
        else {
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        
        let optionMenu = UIAlertController(title: nil, message: "Select an option", preferredStyle: .actionSheet)
        
        if (song.artistID != nil) {
            let viewArtist = UIAlertAction(title: "View Artist", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "ShowArtistSegue", sender: song)
            })
            
            optionMenu.addAction(viewArtist)
        }
        
        if (song.albumID != nil) {
            let viewAlbum = UIAlertAction(title: "View Album", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "ShowAlbumSegue", sender: song)
            })
            
            optionMenu.addAction(viewAlbum)
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            self.songTableView.deselectRow(at: indexPath, animated: true)
        })
        optionMenu.addAction(cancelOption)
        
        if (optionMenu.actions.count > 1) {
            OperationQueue.main.addOperation {
                self.present(optionMenu, animated: true, completion: nil)
            }
        }
        
        songTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func updateCell(_ sender: Notification) {
        DispatchQueue.main.async {
            if let paths = self.songTableView.indexPathsForVisibleRows {
                for i in 0..<paths.count {
                    if self.songs[paths[i].row] == sender.object as! Song {
                        self.songTableView.reloadRows(at: [paths[i]], with: .fade)
                    }
                }
            }
        }
    }
    
    // MARK: - Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchOccurred = true
        
        let count = songs.count
        if (count > 0) {
            self.songs = []
            songTableView.reloadData()
        }
        
        if (searchBar.text != nil && searchBar.text != "") {
            SearchHelperService.service.searchSongs(searchBar.text!) { songs in
                self.songs = songs
                
                DispatchQueue.main.async {
                    self.songTableView.reloadData()
                    self.showOrHideInfoView()
                }
            }
        }
        
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let song = sender as? Song {
            if let vc = segue.destination as? ArtistViewController {
                vc.song = song
            }
            else if let vc = segue.destination as? AlbumViewController {
                vc.song = song
            }
        }
    }
}

