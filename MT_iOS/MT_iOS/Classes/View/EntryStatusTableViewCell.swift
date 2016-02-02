//
//  EntryStatusTableViewCell.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/04.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        segmentedControl.setTitle(NSLocalizedString("Published", comment: "Published"), forSegmentAtIndex: 0)
        segmentedControl.setTitle(NSLocalizedString("Draft", comment: "Draft"), forSegmentAtIndex: 1)
        segmentedControl.setTitle(NSLocalizedString("Scheduled", comment: "Scheduled"), forSegmentAtIndex: 2)
        
        segmentedControl.selectedSegmentIndex = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
