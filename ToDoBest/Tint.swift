import UIKit

extension ViewController {
    func tintViewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideNewPSD))
        Tint.addGestureRecognizer(tapGesture)
        Tint.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
        Tint.isHidden = true
        Tint.alpha = 0.0
    }
    
    @objc func hideNewPSD() {
        NewPSDClose()
        NewPSDTextField.resignFirstResponder()
        NewPSDTextField.text = ""
    }
}
