//
//  BookTableViewCell.swift
//  WHIR
//
//  Created by Bruce Roettgers on 11.02.19.
//  Copyright © 2019 Dirk Hulverscheidt. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(titleLabelView.text)
        GBooksService.fetchImage(forBookTitle: titleLabelView.text!) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                    print(image)
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
