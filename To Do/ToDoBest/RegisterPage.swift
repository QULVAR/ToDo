import Foundation
import UIKit
import CryptoKit

extension ViewController {
    
    func registerPageViewDidLoad (flag: Bool = true) {
        RegisterPage.isHidden = true
        RegisterPageLoginTextField.text = ""
        RegisterPagePasswordTextField.text = ""
        RegisterPagePasswordConfirmTextField.text = ""
        if (flag) {
            RegisterPage.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
            RegisterPage.frame.origin.x = MainView.frame.origin.x - MainView.frame.width
            RegisterPage.frame.origin.y = MainView.frame.origin.y
        }
        RegisterPage.isHidden = false
    }
    
    func registerPageSignInButtonAction (sender: UIButton) {
        sender.isEnabled = false
        RegisterPageLoginTextField.resignFirstResponder()
        let username = RegisterPageLoginTextField.text!
        let password = RegisterPagePasswordTextField.text!
        let passwordConfirm = RegisterPagePasswordConfirmTextField.text!
        var hashedPassword: String = ""
        let lastActivity = String(Int(Double(Date().timeIntervalSince1970)))
        
        if (password == "") {
            messageBoxShow(
                title: "Error",
                message: "\"Password\" is empty ",
                delFlag: false,
                secondActionText: "Ok",
                sender: sender
            )
        }
        if (password == passwordConfirm) {
            if let data = password.data(using: .utf8) {
                hashedPassword = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
            }
            
            let res: [String: Any] = dataBase.jsonDecode(
                data: dataBase.query(
                    funcName: "registration",
                    parameters: [
                        "login": username,
                        "password": hashedPassword,
                        "unix": lastActivity
                    ]
                )
            )
            
            if ((res["status"] as! String) == "success") {
                dataBase.createUser(username: username, password: hashedPassword, lastActivity: lastActivity)
                viewHide(object: RegisterPage)
                viewControllerViewDidLoad()
            }
            else {
                messageBoxShow(title: "Error", message: res["error"] as! String, delFlag: false, secondActionText: "Ok", sender: sender)
            }
        }
        else {
            messageBoxShow(title: "Error", message: "Passwords don't match", delFlag: false, secondActionText: "Ok", sender: sender)
        }
        sender.isEnabled = true
    }
    
    func registerPageSignUpButtonAction (sender: UIButton) {
        sender.isEnabled = false
        authPageViewDidLoad(flag: false)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.RegisterPage.frame.origin.x += self.MainView.frame.width
        }, completion: {_ in
            UIView.animate(withDuration: 0.25, animations: {
                self.AuthPage.frame.origin.x = self.MainView.frame.origin.x
            }, completion: {_ in
                self.RegisterPage.frame.origin.x -= self.MainView.frame.width * 2
            })
        })
        
        sender.isEnabled = true
    }
}
