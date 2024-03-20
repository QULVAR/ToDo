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
        let nameForNew = NewPSDTextField.text.unsafelyUnwrapped
        if (nameForNew.replacingOccurrences(of: " ", with: "") != "") {
            if (viewDeep == 0) {
                if (dirsClient.contains(nameForNew)) {
                    messageBoxShow(title: languageDirctionary["MessageBoxExistErrorTitle"].unsafelyUnwrapped, message: languageDirctionary["MessageBoxExistErrorBodyFolder"].unsafelyUnwrapped, delFlag: false, secondActionText: languageDirctionary["MessageBoxExistErrorSecondAction"].unsafelyUnwrapped, sender: sender)
                }
                else {
                    mainPageScrollAddingButton(buttonName: nameForNew, animate: true)
                    dirsClient.append(nameForNew)
                    dirsPropertiesClient.append([buttonColor.toHexString()])
                    listsClient.append([])
                    listsPropertiesClient.append([])
                    tasksClient.append([])
                    tasksPropertiesClient.append([])
                    NewPSDTextField.text = ""
                    NewPSDClose()
                    saveData()
                    buttonColor = UIColor.clear
                }
            }
            else if (viewDeep == 1) {
                if (listsClient[currentDir].contains(nameForNew)) {
                    messageBoxShow(title: languageDirctionary["MessageBoxExistErrorTitle"].unsafelyUnwrapped, message: languageDirctionary["MessageBoxExistErrorBodyList"].unsafelyUnwrapped, delFlag: false, secondActionText: languageDirctionary["MessageBoxExistErrorSecondAction"].unsafelyUnwrapped, sender: sender)
                }
                else {
                    mainPageScrollAddingButton(buttonName: nameForNew, animate: true)
                    listsClient[currentDir].append(nameForNew)
                    listsPropertiesClient[currentDir].append([buttonColor.toHexString()])
                    tasksClient[currentDir].append([])
                    tasksPropertiesClient[currentDir].append([])
                    NewPSDTextField.text = ""
                    NewPSDClose()
                    saveData()
                    buttonColor = UIColor.clear
                }
            }
            else if (viewDeep == 2) {
                if (tasksClient[currentDir][currentList].contains(nameForNew)) {
                    messageBoxShow(title: languageDirctionary["MessageBoxExistErrorTitle"].unsafelyUnwrapped, message: languageDirctionary["MessageBoxExistErrorBodyTask"].unsafelyUnwrapped, delFlag: false, secondActionText: languageDirctionary["MessageBoxExistErrorSecondAction"].unsafelyUnwrapped, sender: sender)
                }
                else {
                    mainPageScrollAddingButton(buttonName: nameForNew, animate: true)
                    tasksClient[currentDir][currentList].append(nameForNew)
                    tasksPropertiesClient[currentDir][currentList].append([buttonColor.toHexString(), "", ""])
                    NewPSDTextField.text = ""
                    NewPSDClose()
                    saveData()
                    buttonColor = UIColor.clear
                }
            }
        }
        else {
            messageBoxShow(title: languageDirctionary["MessageBoxEmptyErrorTitle"].unsafelyUnwrapped, message: languageDirctionary["MessageBoxEmptyErrorBody"].unsafelyUnwrapped, delFlag: false, secondActionText: languageDirctionary["MessageBoxEmptyErrorSecondAction"].unsafelyUnwrapped, sender: sender)
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
        if (viewDeep == 0) {
            return languageDirctionary["NewPSDAddingToPatternFolder"].unsafelyUnwrapped
        }
        else if (viewDeep == 1) {
            return languageDirctionary["NewPSDAddingToPatternList"].unsafelyUnwrapped
        }
        else if (viewDeep == 2) {
            return languageDirctionary["NewPSDAddingToPatternTask"].unsafelyUnwrapped
        }
        return ""
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        buttonColor = selectedColor
        dismiss(animated: true, completion: nil)
    }
}
