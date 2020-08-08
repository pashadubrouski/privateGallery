import UIKit

protocol MyCollectionViewCellDelegate :AnyObject {
    func pressedCell(pressedCell: UICollectionViewCell)
}

class MyCollectionViewCell: UICollectionViewCell {

    
    weak var delegate: MyCollectionViewCellDelegate?
    
    @IBOutlet weak var collectionControllerImageOutlet: UIImageView!
   
    @IBOutlet weak var cellImageView: UIImageView!
  
}
