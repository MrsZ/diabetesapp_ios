//
//  SummaryTableViewCell.swift
//  DiabetesApp
//
//  Created by IOS3 on 16/01/17.
//  Copyright © 2017 Visions. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var ansTxtLbl: UILabel!
    @IBOutlet weak var nameTxtLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
