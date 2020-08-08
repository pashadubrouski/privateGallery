import UIKit

final class BigImageViewController: UIViewController, UITextViewDelegate {
    
    var tapIndex = false
    var swipeIndex = false
    var imageIndex = 0
    var countOfImages = 0
    let animationTime = 0.5
    let changeConstraint: CGFloat = 100
    
    
    let leftImage = UIImageView()
    let rightImage = UIImageView()
    
    var tap = UITapGestureRecognizer()
    var nextPhotoSwipe = UISwipeGestureRecognizer()
    var previousPhotoSwipe = UISwipeGestureRecognizer()
    
    @IBOutlet weak var bottonViewBottonContstrain: NSLayoutConstraint!
    
    @IBOutlet weak var topViewTopConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet weak var textViewOutlet: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countOfImages = DataManager.shared.imagesArray.count
       
        self.addRecornizers()
        imageViewOutlet.image = DataManager.shared.imagesArray[imageIndex].image
        self.checkLike(index: imageIndex)
        self.tapShowButoons()
        self.textViewOutlet.delegate = self
        self.registerKeyboardNotifications()
        self.textViewOutlet.returnKeyType = .done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.addSwipedImages()
    }
    
    private func addRecornizers(){
        self.tap = UITapGestureRecognizer(target: self, action: #selector(showOrCloseButtons(sender:)))
        self.tap.numberOfTapsRequired = 1
        self.nextPhotoSwipe = UISwipeGestureRecognizer(target: self, action: #selector(openNextPhoto(sender:)))
        self.nextPhotoSwipe.direction = .left
        self.previousPhotoSwipe = UISwipeGestureRecognizer(target: self, action: #selector(openPreviousPhoto(sender:)))
        self.previousPhotoSwipe.direction = .right
        self.view.addGestureRecognizer(nextPhotoSwipe)
        self.view.addGestureRecognizer(previousPhotoSwipe)
        self.view.addGestureRecognizer(tap)
    }
    
    private func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addSwipedImages(){
        let size = self.imageViewOutlet.frame.size
         self.leftImage.frame = CGRect(x: 0-size.width,
                                      y: self.imageViewOutlet.frame.origin.y,
                                      width: size.width,
                                      height: size.height)
        
        self.rightImage.frame = CGRect(x: size.width,
                                       y: self.imageViewOutlet.frame.origin.y,
                                       width: size.width,
                                       height: size.height)
 
        
        self.leftImage.contentMode = .scaleAspectFit
        self.rightImage.contentMode = .scaleAspectFit
        self.view.addSubview(leftImage)
        self.view.addSubview(rightImage)
    }
    
    private func leftPhotoAnimation(){
        if self.imageIndex > 0 {
            self.imageIndex -= 1
        } else {
            self.imageIndex = self.countOfImages - 1
        }
        self.leftImage.image = DataManager.shared.imagesArray[imageIndex].image
        UIView.animate(withDuration: animationTime , animations: {
            self.leftImage.frame.origin.x += self.leftImage.frame.size.width
            self.imageViewOutlet.frame.origin.x += self.leftImage.frame.size.width
        }) { (true) in
            self.imageViewOutlet.image = DataManager.shared.imagesArray[self.imageIndex].image
            self.imageViewOutlet.frame.origin.x = self.leftImage.frame.origin.x
            self.leftImage.frame.origin.x -= self.leftImage.frame.size.width
        }
    }
    
    func rightPhotoAnimation(){
        if self.imageIndex < self.countOfImages - 1 {
            self.imageIndex += 1
        } else {
            self.imageIndex = 0
        }
        rightImage.image = DataManager.shared.imagesArray[imageIndex].image
        UIView.animate(withDuration: animationTime, animations: {
            self.rightImage.frame.origin.x -= self.imageViewOutlet.frame.size.width
            self.imageViewOutlet.frame.origin.x -= self.imageViewOutlet.frame.size.width
        }) { (true) in
            self.imageViewOutlet.image = DataManager.shared.imagesArray[self.imageIndex].image
            self.imageViewOutlet.frame.origin.x = self.rightImage.frame.origin.x
            self.rightImage.frame.origin.x += self.rightImage.frame.size.width
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        self.likeButtonPressed()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.deleteButtonPressed()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.leftImage.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showOrCloseButtons(sender: UITapGestureRecognizer){
        self.tapShowButoons()
    }
    
    @IBAction func openNextPhoto(sender: UISwipeGestureRecognizer){
        swipeCloseButtons()
        self.rightPhotoAnimation()
        self.checkLike(index: self.imageIndex)
    }
    
    @IBAction func openPreviousPhoto(sender: UISwipeGestureRecognizer){
        swipeCloseButtons()
        self.leftPhotoAnimation()
        self.checkLike(index: self.imageIndex)
    }
    
    private func deleteButtonPressed(){
        let alert = UIAlertController(title: "", message: "Это фото будет удалено", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить фото", style: .destructive){ (_) in
            DataManager.shared.imagesArray.remove(at: self.imageIndex)
            UserDefaults.standard.set(encodable: DataManager.shared.imagesArray, forKey: "photos")
            self.countOfImages -= 1
            if DataManager.shared.imagesArray.count < 1{
                guard let controller = self.storyboard?.instantiateViewController(identifier: "ThirdViewController") as? ThirdViewController else {
                    return
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                if self.imageIndex > 0 {
                    self.imageIndex -= 1
                } else {
                    self.imageIndex = self.countOfImages - 1
                }
                self.imageViewOutlet.image = DataManager.shared.imagesArray[self.imageIndex].image
                self.checkLike(index: self.imageIndex)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func likeButtonPressed(){
        if DataManager.shared.imagesArray[self.imageIndex].isLiked == false {
            self.likeButtonOutlet.setImage(UIImage(named: "heart"), for: .normal)
            DataManager.shared.imagesArray[self.imageIndex].isLiked = true
            UserDefaults.standard.set(encodable: DataManager.shared.imagesArray, forKey: "photos")
            addToLiked(image: DataManager.shared.imagesArray[self.imageIndex])
            print(DataManager.shared.likedArray.count)
        }else {
            self.likeButtonOutlet.setImage(UIImage(named: "clearHeart"), for: .normal)
            DataManager.shared.imagesArray[self.imageIndex].isLiked = false
            UserDefaults.standard.set(encodable: DataManager.shared.imagesArray, forKey: "photos")
            DataManager.shared.likedArray.remove(at: self.imageIndex)
            UserDefaults.standard.set(encodable: DataManager.shared.likedArray, forKey: "likedPhotos")
            print(DataManager.shared.likedArray.count)
        }
    }
    
    private func addToLiked(image: SaveImages){
        let likedPhoto = SaveImages()
        likedPhoto.comment = image.comment
        likedPhoto.isLiked = image.isLiked
        likedPhoto.image = image.image
        DataManager.shared.likedArray.append(likedPhoto)
        UserDefaults.standard.set(encodable: DataManager.shared.likedArray, forKey: "likedPhotos")
        
    }
    
    private  func checkLike(index: Int){
        if DataManager.shared.imagesArray[index].isLiked == true {
            self.likeButtonOutlet.setImage(UIImage(named: "heart"), for: .normal)
        }else if DataManager.shared.imagesArray[index].isLiked == false {
            self.likeButtonOutlet.setImage(UIImage(named: "clearHeart"), for: .normal)
        }
    }
    
    private  func tapShowButoons(){
        self.checkLike(index: self.imageIndex)
        self.updateComments()
        if tapIndex == true{
            self.bottonViewBottonContstrain.constant -= changeConstraint
            self.topViewTopConstrain.constant += changeConstraint
            self.tapIndex = false
        } else{
            self.bottonViewBottonContstrain.constant += changeConstraint
            self.topViewTopConstrain.constant -= changeConstraint
            self.swipeIndex = false
            self.tapIndex = true
        }
    }
    
    private func swipeCloseButtons (){
        if tapIndex == false {
            self.bottonViewBottonContstrain.constant += changeConstraint
            self.topViewTopConstrain.constant -= changeConstraint
            self.tapIndex = true
        } else {
            return
        }
    }
    
    private func updateComments () {
        if  DataManager.shared.imagesArray[self.imageIndex].comment == nil || DataManager.shared.imagesArray[self.imageIndex].comment == "" {
            self.textViewOutlet.text = "Оставить комментарий..."
            self.textViewOutlet.textColor = UIColor(red: 0.829, green: 0.829, blue: 0.829, alpha: 1)
        }else {
            self.textViewOutlet.text = DataManager.shared.imagesArray[self.imageIndex].comment
            self.textViewOutlet.textColor = .black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Оставить комментарий..." {
            textView.text = ""
            textView.textColor = .black
        } else {
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "Оставить комментарий..."
            textView.textColor = UIColor(red: 0.829, green: 0.829, blue: 0.829, alpha: 1)
        } else {
            DataManager.shared.imagesArray[self.imageIndex].comment = textView.text
            UserDefaults.standard.set(encodable: DataManager.shared.imagesArray, forKey: "photos")
            textView.text =  DataManager.shared.imagesArray[self.imageIndex].comment
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let keyboardSize = ((userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue).height
        UIView.animate(withDuration: 0.3, animations: {
            self.bottonViewBottonContstrain.constant -= keyboardSize
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.bottonViewBottonContstrain.constant = 0
    }
}




