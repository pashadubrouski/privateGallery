import UIKit
import LocalAuthentication

protocol SecondViewControllerDelegate: AnyObject {
    func giveLink(controller: UIViewController)
}

final class SecondViewController: UIViewController {
    
    @IBOutlet weak var touchIdButtonOutlet: UIButton!
    @IBOutlet weak var signTouchIdLabel: UILabel!
    let passwordXib = PasswordXib.addView()
    var context = LAContext()
    var passwordView = UIView()
    
    weak var delegate: PasswordXibDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if view.frame.width >= 414 {
            touchIdButtonOutlet.setImage(UIImage(named: "faceId"), for: .normal)
            signTouchIdLabel.text = "Вход по Face ID"
        }
        
        self.navigationController?.navigationBar.isHidden = true
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    @IBAction func writePasswordButtonPressed(_ sender: UIButton) {
        self.writePassword()
    }
    
    @IBAction func touchIdButtonPressed(_ sender: UIButton) {
        self.openTouchId()
    }
    
    private func checkPassword(introdusedPassword: String?){
        if introdusedPassword == DataManager.shared.returnPassword(){
            guard let controller = self.storyboard?.instantiateViewController(identifier: "ThirdViewController") as? ThirdViewController else{
                return
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            self.writePassword()
            let alert = UIAlertController(title: "Ошибка", message: "Введен неверный пароль", preferredStyle: .actionSheet)
            let againAction = UIAlertAction(title: "Try again", style: .default) { (_) in
                self.writePassword()
            }
            let touchIdAction = UIAlertAction(title: "Use Touch ID", style: .default){
                (_) in
            }
            alert.addAction(touchIdAction)
            alert.addAction(againAction)
            self.present(alert,animated:true, completion: nil)
        }
    }
    
    private func openTouchId(){
        context.localizedCancelTitle = "Отмена"
        context.localizedFallbackTitle = "Введите пароль"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Войти в приложение"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        guard let controller = self.storyboard?.instantiateViewController(identifier: "ThirdViewController") as? ThirdViewController else{
                            return
                        }
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                } else {
                    return
                }
            }
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Данная функция не поддерживается на вашем устройстве", preferredStyle: .actionSheet)
            let okayAction = UIAlertAction(title: "Окей", style: .default, handler: nil)
            alert.addAction(okayAction)
            self.present(alert,animated:true, completion: nil)
        }
    }
    
    private func writePassword(){
        passwordXib.delegate = self
        self.view.addSubview(self.passwordXib)
    }
}

extension SecondViewController: PasswordXibDelegate{
    func indexStatus(introdusedPassword: String?) {
        guard let password = introdusedPassword else{
            return
        }
        self.checkPassword(introdusedPassword: password)
    }
}

