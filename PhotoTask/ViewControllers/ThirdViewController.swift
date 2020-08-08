import UIKit

final class ThirdViewController: UIViewController {
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    @IBOutlet weak var changeStyleOutlet: UIButton!
    
    var onlyFavourites = false
    
    let imagePicker = UIImagePickerController()
    let cellSpacing: CGFloat = 10.0
    var countLikes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.collectionViewOutlet.delegate = self
        self.collectionViewOutlet.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            self.collectionViewOutlet.reloadData()
    
        
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        pick()
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        openSettings()
    }
    
    @IBAction func changeStyleButtonPressed(_ sender: UIButton) {
        onlyFavouritesPhotos()
    }
    
    private func onlyFavouritesPhotos(){
        if onlyFavourites == false {
            onlyFavourites = true
            changeStyleOutlet.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            onlyFavourites = false
            changeStyleOutlet.setImage(UIImage(named: "clearHeart"), for: .normal)}
        UIView.transition(with: collectionViewOutlet,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.collectionViewOutlet.reloadData() })
    }
    
    private func pick(){
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func openSettings(){
        guard let controller = self.storyboard?.instantiateViewController(identifier: "FourthViewController") as? FourthViewController else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ThirdViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let addedPhoto = SaveImages()
            addedPhoto.image = pickedImage
            addedPhoto.isLiked = false
            addedPhoto.comment = ""
            DataManager.shared.imagesArray.append(addedPhoto)
            UserDefaults.standard.set(encodable: DataManager.shared.imagesArray, forKey: "photos")
            collectionViewOutlet.reloadData()
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

extension ThirdViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if onlyFavourites == false {
            return DataManager.shared.imagesArray.count
        } else {
            return DataManager.shared.likedArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCollectionViewCell else{
            return UICollectionViewCell()
        }
        if onlyFavourites == false {
            cell.cellImageView.image = DataManager.shared.imagesArray[indexPath.row].image
            cell.cellImageView.contentMode = .scaleAspectFill
        } else {
            cell.cellImageView.image = DataManager.shared.likedArray[indexPath.row].image
            cell.cellImageView.contentMode = .scaleAspectFill
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.collectionViewOutlet.frame.width/3 - self.cellSpacing, height: self.collectionViewOutlet.frame.width/3 - self.cellSpacing)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  let controller = storyboard?.instantiateViewController(identifier: "BigImageViewController") as? BigImageViewController else{
            return
        }
        controller.imageIndex = indexPath.row
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

