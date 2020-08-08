import Foundation
import UIKit

protocol PasswordXibDelegate:AnyObject {
    func indexStatus(introdusedPassword: String?)
}

class PasswordXib: UIView{
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegate: PasswordXibDelegate?
    
    var buttonsIndex = 0
    var introdusedPassword: String?
    
    class func addView()-> PasswordXib{
        return UINib(nibName: "PasswordXib", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PasswordXib
    }
   
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        self.introdusedPassword = self.passwordTextField.text
        delegate?.indexStatus(introdusedPassword: self.introdusedPassword)
        self.removeFromSuperview()
    }
    @IBAction func closeKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
