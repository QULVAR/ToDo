import Foundation
import UIKit
import CryptoKit

extension ViewController {
    
    func authPageViewDidLoad (flag: Bool = true) {
        AuthPageLoginTextField.text = ""
        AuthPagePasswordTextField.text = ""
        if (flag) {
            AuthPage.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
            AuthPage.frame.origin.x = MainView.frame.origin.x
            AuthPage.frame.origin.y = MainView.frame.origin.y
        }
        AuthPage.alpha = 0
        AuthPage.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.AuthPage.alpha = 1
        }
    }
    
    func authPageSignInButtonAction (sender: UIButton) {
        sender.isEnabled = false
        AuthPageLoginTextField.resignFirstResponder()
        AuthPagePasswordTextField.resignFirstResponder()
        let username = AuthPageLoginTextField.text!
        let password = AuthPagePasswordTextField.text!
        var hashedPassword: String = ""
        
        if let data = password.data(using: .utf8) {
            hashedPassword = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
        }
        
        let res: [String: Any] = dataBase.jsonDecode(data: dataBase.query(funcName: "auth", parameters: [
            "login": username,
            "password": hashedPassword
        ]))
        if (res.isEmpty) {
            messageBoxShow(
                title: "Error",
                message: "Network is unavialable",
                delFlag: false,
                secondActionText: "Ok",
                sender: sender
            )
        }
        else {
            if ((res["status"] as! String) == "success") {
                dataBase.createUser(username: username, password: hashedPassword, lastActivity: "0")
                viewHide(object: AuthPage)
                viewControllerViewDidLoad()
            }
            else {
                messageBoxShow(title: "Error", message: "These user doesn't exist", delFlag: false, secondActionText: "Ok", sender: sender)
            }
        }
        sender.isEnabled = true
    }
    
    func authPageSignUpButtonAction (sender: UIButton) {
        sender.isEnabled = false
        registerPageViewDidLoad(flag: false)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.AuthPage.frame.origin.x += self.MainView.frame.width
        }, completion: {_ in
            UIView.animate(withDuration: 0.25, animations: {
                self.RegisterPage.frame.origin.x = self.MainView.frame.origin.x
            }, completion: {_ in
                self.AuthPage.frame.origin.x -= self.MainView.frame.width * 2
            })
        })
        
        sender.isEnabled = true
    }
}
