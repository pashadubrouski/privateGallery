import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var passwordCreatedIndex: UILabel!
    @IBOutlet private weak var passwordTextFieldOutlet: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        checkPasswordStatus()
    }
    
    @IBAction func doPasswordButtonPressed(_ sender: UIButton) {
        doPassword()
    }
    
    private func doPassword() {
        if self.passwordTextFieldOutlet.text?.isEmpty == true {
            self.passwordCreatedIndex.textColor = .red
            self.passwordCreatedIndex.text = "Пароль не был введен,попробуйте еще раз"
            return
        }
        else {
            guard let newPassword = self.passwordTextFieldOutlet.text else{
                return
            }
            DataManager.shared.createPassword(password: newPassword)
            DataManager.shared.password = newPassword
            guard let controller = storyboard?.instantiateViewController(identifier: "SecondViewController") as? SecondViewController else {
                return
            }
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func checkPasswordStatus() {
        if DataManager.shared.returnPassword() != nil {
            guard let controoler = self.storyboard?.instantiateViewController(identifier: "SecondViewController") as? SecondViewController else{
                return
            }
            self.navigationController?.pushViewController(controoler, animated: true)
            self.removeFromParent()
        }
    }
}
