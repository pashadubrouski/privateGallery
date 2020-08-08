import UIKit

final class FourthViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var statusLabelOutlet: UILabel!
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var returnButtonOutlet: UIButton!
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        self.changePassword()
    }
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func oldPassKeyboard(_ sender: UITextField) {
        newPasswordTextField.becomeFirstResponder()
    }
    
    @IBAction func newPassKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    
    private func changePassword(){
        let password = self.newPasswordTextField.text!
        if oldPasswordTextField.text != DataManager.shared.returnPassword(){
            self.addAlert(status: false,message: "Старый пароль введен неправильно")
        } else if oldPasswordTextField.text?.isEmpty == true || newPasswordTextField.text?.isEmpty == true{
            self.addAlert(status: false,message: "Заполните все поля")
        }else if
            self.oldPasswordTextField.text == password{
            self.addAlert(status: false, message: "Новый пароль должен отличаться!")
        }else{
            self.addAlert(status: true,message: "Пароль успешно изменен!")
            DataManager.shared.createPassword(password: password)
        }
    }
    
   private  func addAlert(status: Bool,message: String){
        if status == false {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .actionSheet)
            let tryAgainAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.navigationController?.popViewController(animated: true)}
            alert.addAction(tryAgainAction)
            alert.addAction(cancelAction)
            self.present(alert,animated:true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Готово", message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Выйти", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)}
            alert.addAction(okayAction)
            self.present(alert,animated:true, completion: nil)
        }
    }
}
