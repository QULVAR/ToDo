import UIKit

extension ViewController {
    
    func mainPageViewDidLoad () {
        MainPage.isHidden = false
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
            s = languageDirctionary["MainPageTrashButtonFolder"]!
        }
        else if (viewDeep == 2) {
            s = languageDirctionary["MainPageTrashButtonList"]!
        }
        messageBoxShow(title: languageDirctionary["MessageBoxDeleteTitle"]!, message: languageDirctionary["MessageBoxDeleteBody"]! + s + "?", delFlag: true, secondActionText: languageDirctionary["MessageBoxDeleteSecondAction"]!, sender: sender)
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
            
            let viewWords = [["folder", "folders", "user", String(self.userId)], ["list", "lists", "folder", String(self.currentDir)], ["task", "tasks", "list", String(self.currentList)]]

            let data = self.dataBase.select(
                table: viewWords[self.viewDeep][1],
                parameters: "*",
                condition: "\(viewWords[self.viewDeep][2]) = \(Int(viewWords[self.viewDeep][3])!)"
            )
            if (!data.isEmpty) {
                for i in 0...(data.count - 1) {
                    let color = data[i]["3"] as! String
                    if (color != "Clear") {
                        self.buttonColor = UIColor(hex: color)!
                    }
                    self.mainPageScrollAddingButton(buttonName: data[i]["2"] as! String, animate: false)
                    self.buttonColor = UIColor.clear
                }
            }
            
            if (self.viewDeep == 0) {
                self.mainPageUpperLabel()
            }
            else {
                let name = self.dataBase.select(table: viewWords[self.viewDeep - 1][1],
                                                parameters: "name",
                                                condition: "id = \(Int(viewWords[self.viewDeep][3])!)"
                )[0]["0"] as! String
                self.mainPageUpperLabel(mainPageUpperLabelText: name)
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
            currentDir = Int(exactly: dataBase.select(
                table: "folders",
                parameters: "id",
                condition: "name = '\(sender.title(for: .normal)!)' and user = \(userId)"
            )[0]["0"] as! Int64)!
            
            pageLoader()
        }
        else if (viewDeep == 1) {
            viewDeep += 1
            
            currentList = Int(exactly: dataBase.select(
                table: "lists",
                parameters: "id",
                condition: "name = '\(sender.title(for: .normal)!)' and folder = \(currentDir)"
            )[0]["0"] as! Int64)!
            
            pageLoader()
        }
        else if (viewDeep == 2) {
            
            currentTask = Int(exactly: dataBase.select(
                table: "tasks",
                parameters: "id",
                condition: "name = '\(sender.title(for: .normal)!)' and list = \(currentList)"
            )[0]["0"] as! Int64)!
            
            if (taskInfoOpen) {
                TaskInfo.isHidden = false
                
                let taskName = dataBase.select(
                    table: "tasks",
                    parameters: "name",
                    condition: "id = \(currentTask)"
                )[0]["0"] as! String
               
                let request = dataBase.select(
                    table: "taskProperties",
                    parameters: "description",
                    condition: "task = \(currentTask)"
                )
                
                var taskDescription: String = ""
                
                if (request.isEmpty) {
                    dataBase.insert(
                        table: "taskProperties",
                        parameters: "\(currentTask)ǃǃ''ǃǃNULL",
                        userId: userId
                    )
                }
                else {
                    taskDescription = request[0]["0"] as! String
                }
                
                taskInfoLoader(
                    name: taskName,
                    description: taskDescription
                )
            }
            else {
                if (messageCompleteTask) {
                    messageBoxShow(
                        title: languageDirctionary["MessageBoxCompleteTaskTitle"]!,
                        message: languageDirctionary["MessageBoxCompleteTaskBody"]!,
                        delFlag: false,
                        completeFlag: true,
                        secondActionText: languageDirctionary["MessageBoxCompleteTaskSecondAction"]!,
                        sender: sender
                    )
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
        let index: Int = scrollButtons.firstIndex(of: sender)!
        sender.addSubview(lineView!)
        UIView.animate(withDuration: 0.4, animations: {
            self.lineView?.frame = CGRect(x: 0, y: sender.frame.height / 2, width: self.textSize!.width, height: 1)
        }, completion: {_ in
            UIView.animate(withDuration: 0.4, animations: {
                self.scrollButtons[index].alpha = 0.0
            }, completion: {_ in
                
                let task: String = self.dataBase.select(
                    table: "tasks",
                    parameters: "name",
                    condition: "list = \(self.currentList)"
                )[0]["0"] as! String
                
                self.cancelNotification(task: task + "1")
                self.cancelNotification(task: task + "2")
                self.dataBase.delete(
                    table: "taskProperties",
                    condition: "task = \(self.currentTask)",
                    userId: self.userId
                )
                self.dataBase.delete(
                    table: "tasks",
                    condition: "id = \(self.currentTask)",
                    userId: self.userId
                )
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
            let viewWords: [[String]] = [["folders", String(currentDir)], ["lists", String(currentList)]]
            let color: String = dataBase.select(
                table: viewWords[viewDeep - 1][0],
                parameters: "color",
                condition: "id = \(Int(viewWords[viewDeep - 1][1])!)"
            )[0]["0"] as! String
            if (color != "Clear") {
                labelColor = UIColor(hex: color)!
                MainPageUpperLabel.textColor = MainPage.backgroundColor
            }
            else {
                MainPageUpperLabel.textColor = UIColor.link
            }
            MainPageUpperLabel.backgroundColor = labelColor
            labelColor = UIColor.clear
        }
        if (viewDeep == standartDeep) {
            MainPageUpperLabel.text = languageDirctionary["MainPageUpperLabel"]!
        }
        else if (viewDeep > standartDeep) {
            MainPageUpperLabel.text = mainPageUpperLabelText
        }
    }
    
    func mainPageMainLabel () {
        let viewWords: [String] = [
            languageDirctionary["MainPageMainLabelFolders"]!,
            languageDirctionary["MainPageMainLabelLists"]!,
            languageDirctionary["MainPageMainLabelTasks"]!
        ]
        MainPageMainLabel.text = viewWords[viewDeep]
    }
}
