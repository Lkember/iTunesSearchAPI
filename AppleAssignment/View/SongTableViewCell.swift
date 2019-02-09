//
//  SongTableViewCell.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-07.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    var albumCoverURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Mark: - UpdateCell
    func updateCell(song: Song) {
        albumCover.image = song.albumCover
        songTitle.text = song.songTitle
        artistLabel.text = song.artistLabel
        albumLabel.text = song.albumLabel
        albumCoverURL = song.albumCoverURL
        
        albumCover.layer.cornerRadius = 5
        albumCover.layer.masksToBounds = true
    }
}
