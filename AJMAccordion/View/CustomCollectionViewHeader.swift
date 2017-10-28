//
//  CustomCollectionViewHeader.swift
//  AJMAccordion
//
//  Created by TheKairuz
//  Copyright © 2017 TheKairuz. All rights reserved.
//

import UIKit

protocol CustomCollectionViewHeaderDelegate : class {
    func customCollectionViewHeader(sender : CustomCollectionViewHeader, didTap flag : Bool)
}

class CustomCollectionViewHeader : UICollectionReusableView {
   
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate : CustomCollectionViewHeaderDelegate?
    var index : Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CustomCollectionViewHeader.displayContent))
        self.addGestureRecognizer(tap)
    }
    
    func displayContent() {
        print("Is receiving a tap")
        delegate?.customCollectionViewHeader(sender: self, didTap: true)
    }
}
