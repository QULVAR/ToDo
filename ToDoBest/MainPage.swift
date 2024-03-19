import UIKit

extension ViewController {
    
    func mainPageViewDidLoad () {
        MainPage.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
        mainPageMainLabel()
        mainPageUpperLabel()
        MainPageMainLabel.frame.origin.x = MainPageBackButton.frame.origin.x
        MainPageMainLabel.frame.origin.y = MainPagePlusButton.frame.origin.y
        MainPageUpperLabel.frame.origin.x = MainPageBackButton.frame.origin.x
        MainPageUpperLabel.frame.origin.y = MainPageMainLabel.frame.origin.y - MainPageMainLabel.frame.height
        MainPageBackButton.isHidden = true
        lineView = UIView(frame: CGRect(x: 0, y: 20, width: 0, height: 1))
        lineView?.backgroundColor = UIColor.link
    }
    
    func mainPagePlusButtonAction (sender: UIButton) {
        NewPSDLabel.text = newPSDLabelTextPattern + newPSDAddingToPattern()
        NewPSD.isHidden = false
        Tint.isHidden = false
        UIView.animate(withDuration: 0.6) {
            self.Tint.alpha = 0.5
            self.NewPSD.frame.origin.x = self.const - self.const1
        }
    }
    
    func mainPageInfoModeButtonAction (sender: UIButton) {
        sender.isSelected = !sender.isSelected
        taskInfoOpen = !taskInfoOpen
    }
    
    func mainPageTrashButtonAction (sender: UIButton) {
        var s: String = ""
        if (viewDeep == 1) {
            s = languageDirctionary["MainPageTrashButtonFolder"].unsafelyUnwrapped
        }
        else if (viewDeep == 2) {
            s = languageDirctionary["MainPageTrashButtonList"].unsafelyUnwrapped
        }
        messageBoxShow(title: languageDirctionary["MessageBoxDeleteTitle"].unsafelyUnwrapped, message: languageDirctionary["MessageBoxDeleteBody"].unsafelyUnwrapped + s + "?", delFlag: true, secondActionText: languageDirctionary["MessageBoxDeleteSecondAction"].unsafelyUnwrapped, sender: sender)
    }
    
    func mainPageBackButtonAction(sender: UIButton) {
        viewDeep -= 1
        pageLoader(origin: "Left")
    }
    
    func pageLoader (animationDuaration: Double = 0.25, origin: String = "Right", delete: Bool = false) {
        var mainPageFrameWidth: Double = 0
        if (origin == "Right") {
            mainPageFrameWidth = MainPage.frame.width
        }
        else if (origin == "Left") {
            mainPageFrameWidth = -MainPage.frame.width
        }
        UIView.animate(withDuration: animationDuaration, animations: {
            self.MainPage.frame.origin.x += mainPageFrameWidth
        }, completion: {_ in
            if (delete) {
                self.deleteElement()
            }
            self.mainPageScrollReset()
            self.mainPageMainLabel()
            if (self.viewDeep == self.standartDeep) {
                self.MainPageBackButton.isHidden = true
                self.MainPageTrashButton.isHidden = true
                if (self.viewDeep == 2) {
                    self.MainPageInfoModeButton.frame.origin.x = self.MainPageTrashButton.frame.origin.x + 6.5
                    self.MainPageInfoModeButton.frame.origin.y = self.MainPageTrashButton.frame.origin.y + 7
                }
            }
            else {
                self.MainPageBackButton.isHidden = false
                self.MainPageTrashButton.isHidden = false
                if (self.viewDeep == 2) {
                    self.MainPageInfoModeButton.frame.origin.x = self.MainPageTrashButton.frame.origin.x - self.MainPageInfoModeButton.frame.width
                    self.MainPageInfoModeButton.frame.origin.y = self.MainPageTrashButton.frame.origin.y + 1
                }
            }
            self.MainPageInfoModeButton.isHidden = !(self.viewDeep == 2)
            if (self.MainPageInfoModeButton.isSelected && self.MainPageInfoModeButton.isHidden) {
                self.MainPageInfoModeButton.isSelected = false
                self.taskInfoOpen = false
            }
            if (self.viewDeep == 0) {
                self.mainPageUpperLabel()
                let dirs: Int = self.dirsClient.count - 1
                if (dirs >= 0) {
                    for i in 0...dirs {
                        if (self.dirsPropertiesClient[i].count > 0) {
                            self.buttonColor = UIColor(hex: self.dirsPropertiesClient[i][0]).unsafelyUnwrapped
                        }
                        self.mainPageScrollAddingButton(buttonName: self.dirsClient[i], animate: false)
                        self.buttonColor = UIColor.clear
                    }
                }
            }
            else if (self.viewDeep == 1) {
                self.mainPageUpperLabel(mainPageUpperLabelText: self.dirsClient[self.currentDir])
                let lists: Int = self.listsClient[self.currentDir].count - 1
                if (lists >= 0) {
                    for i in 0...lists {
                        if (self.listsPropertiesClient[self.currentDir][i].count > 0) {
                            self.buttonColor = UIColor(hex: self.listsPropertiesClient[self.currentDir][i][0]).unsafelyUnwrapped
                        }
                        self.mainPageScrollAddingButton(buttonName: self.listsClient[self.currentDir][i], animate: false)
                        self.buttonColor = UIColor.clear
                    }
                }
            }
            else if (self.viewDeep == 2) {
                self.mainPageUpperLabel(mainPageUpperLabelText: self.listsClient[self.currentDir][self.currentList])
                let tasks: Int = self.tasksClient[self.currentDir][self.currentList].count - 1
                if (tasks >= 0) {
                    for i in 0...tasks {
                        if (self.tasksPropertiesClient[self.currentDir][self.currentList][i].count > 0) {
                            self.buttonColor = UIColor(hex: self.tasksPropertiesClient[self.currentDir][self.currentList][i][0]).unsafelyUnwrapped
                        }
                        self.mainPageScrollAddingButton(buttonName: self.tasksClient[self.currentDir][self.currentList][i], animate: false)
                        self.buttonColor = UIColor.clear
                    }
                }
            }
            self.MainPage.frame.origin.x -= 2 * mainPageFrameWidth
            UIView.animate(withDuration: animationDuaration, animations: {
                self.MainPage.frame.origin.x = self.MainView.frame.origin.x
            })
        })
    }
    
    
    @objc func mainPageScrollButton (_ sender: UIButton) {
        if (viewDeep == 0) {
            viewDeep += 1
            currentDir = dirsClient.firstIndex(of: sender.title(for: .normal).unsafelyUnwrapped).unsafelyUnwrapped
            pageLoader(origin: "Right")
        }
        else if (viewDeep == 1) {
            viewDeep += 1
            currentList = listsClient[currentDir].firstIndex(of: sender.title(for: .normal).unsafelyUnwrapped).unsafelyUnwrapped
            pageLoader()
        }
        else if (viewDeep == 2) {
            currentTask = tasksClient[currentDir][currentList].firstIndex(of: sender.title(for: .normal)!).unsafelyUnwrapped
            if (taskInfoOpen) {
                TaskInfo.isHidden = false
                while (tasksPropertiesClient[currentDir][currentList][currentTask].count != 3) {
                    tasksPropertiesClient[currentDir][currentList][currentTask].append("")
                }
                taskInfoLoader(name: tasksClient[currentDir][currentList][currentTask], description: tasksPropertiesClient[currentDir][currentList][currentTask][2])
            }
            else {
                if (messageCompleteTask) {
                    messageBoxShow(title: languageDirctionary["MessageBoxCompleteTaskTitle"].unsafelyUnwrapped, message: languageDirctionary["MessageBoxCompleteTaskBody"].unsafelyUnwrapped, delFlag: false, completeFlag: true, secondActionText: languageDirctionary["MessageBoxCompleteTaskSecondAction"].unsafelyUnwrapped, sender: sender)
                }
                else {
                    mainPageScrollButtonCompleteTask(sender: sender)
                }
            }
        }
    }
    
    func mainPageScrollButtonCompleteTask (sender: UIButton) {
        sender.isEnabled = false
        scrollViewButtonPressed = true
        textSize = sender.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        let index: Int = scrollButtons.firstIndex(of: sender).unsafelyUnwrapped
        sender.addSubview(lineView.unsafelyUnwrapped)
        UIView.animate(withDuration: 0.4, animations: {
            self.lineView?.frame = CGRect(x: 0, y: sender.frame.height / 2, width: self.textSize!.width, height: 1)
        }, completion: {_ in
            UIView.animate(withDuration: 0.4, animations: {
                self.scrollButtons[index].alpha = 0.0
            }, completion: {_ in
                self.cancelNotification(task: self.tasksClient[self.currentDir][self.currentList][self.currentTask] + "1")
                self.cancelNotification(task: self.tasksClient[self.currentDir][self.currentList][self.currentTask] + "2")
                self.tasksPropertiesClient[self.currentDir][self.currentList].remove(at: self.currentTask)
                self.tasksClient[self.currentDir][self.currentList].remove(at: self.currentTask)
                self.scrollButtons.remove(at: index)
                if (index < self.scrollButtons.count) {
                    for i in index...(self.scrollButtons.count - 1) {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.scrollButtons[i].frame.origin.y -= 60
                        })
                    }
                }
                self.lineView?.frame = CGRect(x: 0, y: sender.frame.height / 2, width: 0, height: 1)
                self.MainPageScroll.contentSize = CGSize(width: self.MainPageScroll.frame.size.width, height: self.MainPageScroll.contentSize.height - sender.frame.size.height - 20)
                self.saveData()
                self.scrollViewButtonPressed = false
            })
        })
    }
    
    func mainPageScrollReset () {
        for subview in MainPageScroll.subviews {
            subview.removeFromSuperview()
        }
        MainPageScroll.isScrollEnabled = true
        MainPageScroll.frame.size = CGSize(width: MainView.frame.width - 30, height: MainView.frame.height - MainPageMainLabel.frame.origin.y - MainPageMainLabel.frame.height)
        MainPageScroll.frame.origin.x = 15
        MainPageScroll.frame.origin.y = MainPageMainLabel.frame.origin.y + MainPageMainLabel.frame.height + 5
        MainPageScroll.contentSize = CGSize(width: MainPageScroll.frame.width, height: 0)
    }
    
    func mainPageScrollAddingButton (buttonName: String, animate: Bool) {
        let button = UIButton(type: .system)
        button.setTitle(buttonName, for: .normal)
        button.backgroundColor = buttonColor
        if (buttonColor != UIColor.clear) {
            button.setTitleColor(MainPage.backgroundColor, for: .normal)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25.0)
        button.contentHorizontalAlignment = .left
        if (animate) {
            button.alpha = 0.0
        }
        else {
            button.alpha = 1.0
        }
        button.frame = CGRect(x: 0, y: MainPageScroll.contentSize.height, width: MainPageScroll.frame.width, height: 40)
        button.addTarget(self, action: #selector(mainPageScrollButton), for: .touchUpInside)
        MainPageScroll.addSubview(button)
        MainPageScroll.contentSize = CGSize(width: MainPageScroll.frame.size.width, height: button.frame.origin.y + button.frame.size.height + 20)
        if (animate) {
            UIView.animate(withDuration: 0.9) {
                button.alpha = 1.0
            }
        }
        if (viewDeep == 2) {
            scrollButtons.append(button)
        }
    }
    
    func mainPageUpperLabel (mainPageUpperLabelText: String = "") {
        if (viewDeep == 0) {
            MainPageUpperLabel.textColor = UIColor.link
            MainPageUpperLabel.backgroundColor = UIColor.clear
        }
        else {
            if (viewDeep == 1) {
                if (dirsPropertiesClient[currentDir].count > 0) {
                    labelColor = UIColor(hex: dirsPropertiesClient[currentDir][0]).unsafelyUnwrapped
                }
            }
            else if (viewDeep == 2) {
                if (listsPropertiesClient[currentDir][currentList].count > 0) {
                    labelColor = UIColor(hex: listsPropertiesClient[currentDir][currentList][0]).unsafelyUnwrapped
                }
            }
            MainPageUpperLabel.backgroundColor = labelColor
            if (labelColor != UIColor.clear) {
                MainPageUpperLabel.textColor = MainPage.backgroundColor
            }
            else {
                MainPageUpperLabel.textColor = UIColor.link
            }
            labelColor = UIColor.clear
        }
        if (viewDeep == standartDeep) {
            MainPageUpperLabel.text = languageDirctionary["MainPageUpperLabel"].unsafelyUnwrapped
        }
        else if (viewDeep > standartDeep) {
            MainPageUpperLabel.text = mainPageUpperLabelText
        }
    }
    
    func mainPageMainLabel () {
        if (viewDeep == 0) {
            MainPageMainLabel.text = languageDirctionary["MainPageMainLabelFolders"].unsafelyUnwrapped
        }
        else if (viewDeep == 1) {
            MainPageMainLabel.text = languageDirctionary["MainPageMainLabelLists"].unsafelyUnwrapped
        }
        else if (viewDeep == 2) {
            MainPageMainLabel.text = languageDirctionary["MainPageMainLabelTasks"].unsafelyUnwrapped
        }
    }
}
