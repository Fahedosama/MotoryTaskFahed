//
//  TableCollectionViewCell.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 14/04/2022.
//

import UIKit
import SDWebImage

class TableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imgWishlist: WishlistButton!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var lblAltDesc: UILabel!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var galleryItem : GalleryItem?
    
    var itemIndexPath : IndexPath?
    
    var wishlistDelegate : WishlistDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    //load data into cell
    func configureCell(data : GalleryItem,isGridView : Bool) {
        
        self.galleryItem = data
        
        lblDesc.text = data.user.username
        lblAltDesc.text = data.user.bio

        imgWishlist.isChecked = data.isFavorite
        
        //load image from url & cache it
        //if gridview then show thumb else show small
        imageView.sd_setImage(with: URL(string: isGridView ? data.urls.thumb : data.urls.small),
                              placeholderImage: UIImage(named: "img1"))
        
    }
    
    //handle wishlist clicked
    @IBAction func wishlistClicked(_ sender: Any) {
        if let gallery = self.galleryItem {
            wishlistDelegate?.onWishlistClicked(data: gallery,indexPath: itemIndexPath!)
        }
     }

    //toggle constraint according to view type
    func fixHeight(isGridView : Bool){
        if !isGridView{
            imageHeight.constant = 300
        }else{
            imageHeight.constant = 150
        }
    }
    
    //cell metadata
    class var reuseIdentifier: String {
        return "cellTable"
    }
    
    class var nibName: String {
        return "TableCollectionViewCell"
    }
    
}
