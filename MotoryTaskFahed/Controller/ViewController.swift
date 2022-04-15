//
//  ViewController.swift
//  MotoryTaskFahed
//
//  Created by Fahed on 14/04/2022.
//

import UIKit
import CoreData
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    @IBOutlet weak var btnImages: UIButton!
    
    @IBOutlet weak var btnWishList: UIButton!
    
    @IBOutlet weak var btnTableView: UIButton!
    
    @IBOutlet weak var btnGridView: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //list
    var galleryList: [GalleryItem] = []
    var filteredData: [GalleryItem] = []
    
    //toggle between grid & tableview
    var isGrid = false
    
    //toggle between favorite
    var isWishlist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        prepareViews()
        prepareCollectionView()
        prepareData()
    }
    
    //make status bar color light
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //prepare collectionview attributes
    func prepareCollectionView(){
        //register XIBs
        self.collectionView?.register(UINib(nibName: TableCollectionViewCell.nibName, bundle: nil),
                                      forCellWithReuseIdentifier: TableCollectionViewCell.reuseIdentifier)
        
        //assign datasource & delegate to this class
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //make background transparent
        self.collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        //hide scroll bar indicator
        self.collectionView.showsVerticalScrollIndicator = false
    }
    
    func prepareViews(){
        //customize searchbar to compliy with the design
        self.searchBar.delegate = self
        
        //make buttons rounded corners
        btnImages.layer.cornerRadius = 10
        btnWishList.layer.cornerRadius = 10
        btnTableView.layer.cornerRadius = 10
        btnGridView.layer.cornerRadius = 10
        
        //highlight buttons at top
        btnImages.makeButtonActive()
        btnWishList.makeButtonInactive()
        //higlight view buttons
        btnTableView.makeButtonActive()
        btnGridView.makeButtonInactive()
    }
    
    func clearData(){
        galleryList.removeAll()
        filteredData.removeAll()
    }
    
    func prepareData(){
        //clear data
        clearData()
        
        //call from api
        AF.request(Urls.shared.getImagesUrl(), method: .get).response { response in
            guard let itemsData = response.data else {
                //completion(.failure(.badResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode([GalleryItem].self, from: itemsData)
                DispatchQueue.main.async {
                    self.galleryList = items
                    self.filteredData = self.galleryList
                    
                    self.collectionView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }

    }

    func showWishlistData(){
        //clear data
        clearData()
        
        galleryList = loadWishlist()
        filteredData = galleryList
        
        collectionView.reloadData()
    }
    
    @IBAction func btnImagesClick(_ sender: UIButton) {
        //toggle buttons design
        sender.makeButtonActive()
        btnWishList.makeButtonInactive()
        
        prepareData()
        
        //toggle wishlist
        isWishlist = false
    }
    
    @IBAction func btnWishListClick(_ sender: UIButton) {
        //toggle buttons design
        sender.makeButtonActive()
        btnImages.makeButtonInactive()
        
        showWishlistData()
        
        //toggle wishlist
        isWishlist = true
    }
    
    @IBAction func btnTableViewClicked(_ sender: UIButton) {
        //toggle buttons design
        sender.makeButtonActive()
        btnGridView.makeButtonInactive()
        
        //update view and reload
        isGrid = false
        collectionView.reloadData()
    }
    
    @IBAction func btnGridView(_ sender: UIButton) {
        //toggle buttons design
        sender.makeButtonActive()
        btnTableView.makeButtonInactive()
        
        //update view and reload
        isGrid = true
        collectionView.reloadData()
    }
    
}

//MARK:- search
//search bar
extension ViewController : UISearchBarDelegate {
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        let lowerSearchText = searchText.lowercased()
        filteredData = searchText.isEmpty ? galleryList : galleryList.filter { (item: GalleryItem) -> Bool in
            return item.user.username?.lowercased().contains(lowerSearchText) ?? false || item.user.bio?.lowercased().contains(lowerSearchText) ?? false
            
        }
        
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard.
    }
}

//data source for collectionview
extension ViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
}

//design the cell
extension ViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentGalleryItem = filteredData[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCollectionViewCell.reuseIdentifier, for: indexPath) as! TableCollectionViewCell
        
        cell.itemIndexPath = indexPath
        
        cell.configureCell(data: currentGalleryItem,isGridView: isGrid)
        
        cell.wishlistDelegate = self
        
        cell.fixHeight(isGridView: isGrid)
        
        return cell
        
    }
    
}

//fix height & width
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin : CGFloat = 16;
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        var cellWidth = screenWidth - (margin * 2.0)//left and right
        var cellHeight : CGFloat = 450
        if(isGrid){
            cellWidth = (cellWidth / 2) - 8;
            cellHeight = 270
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//extension for gallery item to check if it's in wishlist coredata
extension GalleryItem{
    
    func checkExists() -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = GalleryItemCoreData.fetchRequest()
        //check if id exists in db
        fetchRequest.predicate = NSPredicate(format: "id == %@", self.id)
        fetchRequest.fetchLimit = 1
        
        do {
            
            let count = try managedContext.count(for: fetchRequest)
            //if count >0 then it exists
            return count > 0
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}

//to handle on click on wishlist
extension ViewController : WishlistDelegate{
    
    //on click event
    func onWishlistClicked(data: GalleryItem,indexPath : IndexPath) {
        //check if item exists in wishlist
        //if yes then remove it
        //if not then add it
        if !data.checkExists(){
            addToWishlist(data)
            filteredData[indexPath.row].isFavorite = true
        }else{
            deleteWishlistItem(galleryItem: data)
            filteredData[indexPath.row].isFavorite = false
            
            if isWishlist {
                showWishlistData()
            }
        }
        
        collectionView.reloadData()
    }
    
    //add item to wishlist
    private func addToWishlist(_ data: GalleryItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let galleryItem = GalleryItemCoreData(context: context)
        
        galleryItem.id = data.id
        galleryItem.created_date = data.created_at
        galleryItem.desc = data.user.username ?? ""
        galleryItem.alt_desc = data.user.bio ?? "No Bio"
        galleryItem.image_url_small = data.urls.small
        galleryItem.image_url_thumb = data.urls.thumb
        
        appDelegate.saveContext()
    }
    
    //load wishlist items
    private func loadWishlist() -> [GalleryItem] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        let request: NSFetchRequest<GalleryItemCoreData> = GalleryItemCoreData.fetchRequest()
        
        do {
            
            let galleryItemsCoreData = try context.fetch(request)
            var galleryItems : [GalleryItem] = []
            
            galleryItemsCoreData.forEach { galleryItemCore in
                //load item from coredata
                let galleryItem = GalleryItem(coreData: galleryItemCore)
                
                galleryItems.append(galleryItem)
            }
            
            return galleryItems
        }  catch {
            fatalError("This was not supposed to happen")
        }
        
    }
    
    //delete wishlist item
    private func deleteWishlistItem(galleryItem : GalleryItem){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = GalleryItemCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", galleryItem.id)
        
        var fetchedEntities = [GalleryItemCoreData]()
        
        do {
            fetchedEntities = try managedContext.fetch(fetchRequest)
            for sequence in fetchedEntities
            {
                managedContext.delete(sequence)
            }
            
            do {
                try managedContext.save() // <- remember to put this :)
                
            } catch {
                // Do something... fatalerror
                print("handle error")
                return
            }

        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

//hide keyboard when tapped amywhere
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


