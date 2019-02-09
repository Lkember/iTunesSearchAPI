//
//  AlbumSongTableViewCell.swift
//  AppleAssignment
//
//  Created by Logan Kember on 2019-02-09.
//  Copyright © 2019 Logan Kember. All rights reserved.
//

import UIKit

class AlbumSongTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songIndex: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(song: Song) {
        songTitleLabel.text = song.songTitle
        artistNameLabel.text = song.artistLabel
        if (song.trackNumber != 0) {
            songIndex.text = "\(song.trackNumber)"
        }
        else {
            songIndex.isHidden = true
        }
    }

}
