//
//  CustomSearchBar.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 15/04/2022.
//

import Foundation
import UIKit

@IBDesignable
class CustomSearchBar : UISearchBar{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //initialize custom search bar
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.searchTextField.textColor = Colors.textColor
        self.searchTextField.leftView?.tintColor = Colors.textColor
        self.searchTextField.backgroundColor = .clear
        //self.searchBar.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
