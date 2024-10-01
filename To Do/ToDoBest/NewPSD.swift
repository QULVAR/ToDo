import UIKit

extension ViewController {
    
    func newPSDViewDidLoad() {
        NewPSD.frame.origin.x = 1000 - const
        NewPSD.frame.origin.y = MainView.frame.height / 2 - 172
        NewPSD.layer.cornerRadius = 25
        NewPSDTextField.textColor = UIColor.link
    }
    
    func newPSDBackButtonAction (sender: UIButton) {
        NewPSDClose()
        NewPSDTextField.text = ""
    }
    
    func newPSDContinueButtonAction (sender: UIButton) {
        NewPSDTextField.resignFirstResponder()
        let nameForNew = NewPSDTextField.text!
        if (nameForNew.replacingOccurrences(of: " ", with: "") != "") {
            let viewWords = [
                ["folders", String(userId), "user"],
                ["lists", String(currentDir), "folder"],
                ["tasks", String(currentList), "list"]
            ]
            let mass = dataBase.dictToListString(
                dict: dataBase.select(
                    table: viewWords[viewDeep][0],
                    parameters: "name",
                    condition: "\(viewWords[viewDeep][2]) = \(Int(viewWords[viewDeep][1])!)"
                )
            )
            if (mass.contains(nameForNew)) {
                messageBoxShow(
                    title: languageDirctionary["MessageBoxExistErrorTitle"]!,
                    message: languageDirctionary["MessageBoxExistErrorBodyFolder"]!,
                    delFlag: false,
                    secondActionText: languageDirctionary["MessageBoxExistErrorSecondAction"]!,
                    sender: sender
                )
            }
            else {
                mainPageScrollAddingButton(buttonName: nameForNew, animate: true)
                let color: String = buttonColor == UIColor.clear ? "Clear" : buttonColor.toHexString()
                dataBase.insert(
                    table: viewWords[viewDeep][0],
                    parameters: "\(Int(viewWords[viewDeep][1])!)ǃǃ'\(nameForNew)'ǃǃ'\(color)'",
                    userId: userId
                )
                NewPSDTextField.text = ""
                NewPSDClose()
                buttonColor = UIColor.clear
            }
        }
        else {
            messageBoxShow(
                title: languageDirctionary["MessageBoxEmptyErrorTitle"]!,
                message: languageDirctionary["MessageBoxEmptyErrorBody"]!,
                delFlag: false,
                secondActionText: languageDirctionary["MessageBoxEmptyErrorSecondAction"]!,
                sender: sender
            )
        }
    }
    
    func newPSDColorButtonAction (sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    func NewPSDClose () {
        UIView.animate(withDuration: 0.6, animations: {
            self.Tint.alpha = 0.0
            self.NewPSD.frame.origin.x = self.const - self.const1 - 1000
        }, completion: {_ in
            self.Tint.isHidden = true
            self.NewPSD.isHidden = true
            self.NewPSD.frame.origin.x = 1000 - self.const
            self.NewPSDTextField.resignFirstResponder()
            self.buttonColor = UIColor.clear
        })
    }
    
    func newPSDAddingToPattern () -> String {
        let viewWords: [String] = ["Folder", "List", "Task"]
        return languageDirctionary["NewPSDAddingToPattern\(viewWords[viewDeep])"]!
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        buttonColor = viewController.selectedColor
        dismiss(animated: true, completion: nil)
    }
}
