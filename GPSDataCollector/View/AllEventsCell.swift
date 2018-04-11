//
//  AllEventsCell.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/26/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class AllEventsCell: UITableViewCell {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var eventsImageView: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    
    @IBOutlet weak var daysRemainingLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var lengthLbl: UILabel!
    
    @IBOutlet weak var difficultyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
