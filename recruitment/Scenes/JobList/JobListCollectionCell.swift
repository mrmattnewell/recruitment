//
//  JobListCollectionCell.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 05/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit


class JobListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    var job: Job? {
        didSet{
            guard let job = self.job else { return }
            lblTitle.text = job.title
            lblDesc.text = job.description
        }
    }
}
