//
//  AlbumTableViewCell.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-08.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var genre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(album: Album) {
        albumName.text = album.albumName
        albumCover.image = album.albumCover
        
        albumCover.layer.cornerRadius = 5
        albumCover.layer.masksToBounds = true
        
        if (album.releaseDate != 0) {
            releaseYear.text = "Released: \(album.releaseDate)"
        }
        else {
            releaseYear.isHidden = true
        }
        
        genre.text = album.albumGenre
    }
}
