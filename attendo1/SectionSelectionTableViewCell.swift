//
//  SectionSelectionTableViewCell.swift
//  attendo1
//
//  Created by Nik Howlett on 11/2/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit

class SectionSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionButton: UIButton!
    
    @IBOutlet weak var classLabel: UILabel!
    
    var viewController : UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pushSectionButton(sender: AnyObject) {
        
    }

}
