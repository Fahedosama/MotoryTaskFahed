//
//  WishlistButtonLarge.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 14/04/2022.
//

import Foundation
import UIKit

@IBDesignable
class WishlistButton : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //initialize wishlist button
        self.setImage(UIImage.init(systemName: Constants.ICON_WISHLIST_NAME), for: .normal)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
    
    //change wishlist button checked or not
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.backgroundColor = .white
                self.tintColor = Colors.wishlist_filled
            } else {
                self.backgroundColor = .white.withAlphaComponent(0.3)
                self.tintColor = .white
            }
        }
    }
}

//change
extension UIButton{

    func makeButtonActive(){
        self.backgroundColor = Colors.button_active
    }
    
    func makeButtonInactive(){
        self.backgroundColor = Colors.button_inactive
    }
}
