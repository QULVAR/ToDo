import UIKit

extension ViewController {
    
    /*
    settings {
        [0] = folder int (0, 1)
        [1] = standartFolder (null, index)
        [2] = list int (0, 1)
        [3] = standartList (null, index)
        [4] = notifications int (0, 1)
        [5] = timeUntilEnd string (unix)
        [6] = language int (index)
        [7] = warningBeforeComplete int (0, 1)
    }
    
     
    */
    
    func settingsViewDidLoad () {
        Settings.isHidden = false
        Settings.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
        Settings.frame.origin.y = MainView.frame.height
        SettingsListsLabel.isHidden = true
        SettingsListsSwitch.isHidden = true
        SettingsDirectoryLabel.isHidden = true
        SettingsDirectoryPopUp.isHidden = true
        SettingsChooseListLabel.isHidden = true
        SettingsChooseListPopUp.isHidden = true
        loadSettings()
    }
    
    func settingsOnOffFoldersAction (sender: UISwitch) {
        
        dataBase.update(
            table: "settings",
            parameters: "folderǃ\(sender.isOn ? 1 : 0)",
            condition: "user = \(userId)",
            userId: userId
        )
        
        if (!(SettingsFolderSwitch.isOn)) {
            standartDeep = 1
            if (viewDeep == 0) {
                viewDeep = standartDeep
            }
            currentDir = 0
            let dirs = dataBase.select(
                table: "folders",
                parameters: "*"
            )
            if (dirs.isEmpty) {
                dataBase.insert(
                    table: "folders",
                    parameters: "\(userId)ǃǃ'StandartFolder'ǃǃ'Clear'",
                    userId: userId
                )
                
                currentDir = Int(exactly: dataBase.select(
                    table: "folders",
                    parameters: "id",
                    condition: "user = \(userId) and name = 'StandartFolder'"
                )[0]["0"] as! Int64)!
                
                dataBase.update(
                    table: "settings",
                    parameters: "standartFolderǃ\(currentDir)",
                    condition: "user = \(userId)",
                    userId: userId
                )
            }
            else if (dirs.count > 1) {
                currentDir = Int(exactly: dataBase.select(
                    table: "folders",
                    parameters: "id",
                    condition: "user = \(userId)"
                )[0]["0"] as! Int64)!
                dataBase.update(
                    table: "settings",
                    parameters: "standartFolderǃ\(currentDir)",
                    condition: "user = \(userId)",
                    userId: userId
                )
                settingsChooseStandrartDirShow()
            }
            else {
                currentDir = Int(exactly: dataBase.select(
                    table: "folders",
                    parameters: "id",
                    condition: "user = \(userId)"
                )[0]["0"] as! Int64)!
            }
            
            dataBase.update(
                table: "settings",
                parameters: "listǃ1ǃǃstandartListǃNULL",
                condition: "user = \(userId)",
                userId: userId
            )
            UIView.animate(withDuration: 0.5, animations: {}, completion: {_ in
                self.settingsListsSwitchShow()
            })
            pageLoader(animationDuaration: 0.0)
        }
        else {
            standartDeep = 0
            pageLoader(animationDuaration: 0.0)
            UIView.animate(withDuration: 0.5, animations: {
                if (self.settingsChooseDirButtonShowed) {
                    self.settingsChooseStandrartDirHide()
                }
                self.settingsListsSwitchHide()
                if (self.settingsChooseListButtonShowed) {
                    self.settingsChooseStandrartListHide()
                }
            }, completion: {_ in
                self.SettingsListsSwitch.isOn = true
                
                self.dataBase.update(
                    table: "settings",
                    parameters: "listǃ1ǃǃstandartFolderǃNULL",
                    condition: "user = \(self.userId)",
                    userId: self.userId
                )
            })
        }
    }
    
    func settingsOnOffLists(sender: UISwitch) {
        dataBase.update(
            table: "settings",
            parameters: "listǃ\(sender.isOn ? 1 : 0)",
            condition: "user = \(userId)",
            userId: userId
        )
        
        if (!(sender.isOn)) {
            standartDeep = 2
            if (viewDeep == 1) {
                viewDeep = standartDeep
            }
            let lists: [String] = dataBase.dictToListString(
                dict: dataBase.select(
                    table: "lists",
                    parameters: "name",
                    condition: "folder = \(currentDir)"
                )
            )
            if (lists.isEmpty) {
                dataBase.insert(
                    table: "lists",
                    parameters: "\(currentDir)ǃǃ'StandartList'ǃǃ'Clear'",
                    userId: userId
                )
                
                let listId: Int = Int(exactly: dataBase.select(
                    table: "lists",
                    parameters: "id",
                    condition: "folder = \(currentDir) and name = 'StandartList'"
                )[0]["0"] as! Int64)!
                
                currentList = listId
                
                dataBase.update(
                    table: "settings",
                    parameters: "standartListǃ\(listId)",
                    condition: "user = \(userId)",
                    userId: userId
                )
            }
            else if (lists.count > 1) {
                
                let listId: Int = Int(exactly: dataBase.select(
                    table: "lists",
                    parameters: "id",
                    condition: "folder = \(currentDir) and name = '\(lists[0])'"
                )[0]["0"] as! Int64)!
                
                currentList = listId
                
                dataBase.update(
                    table: "settings",
                    parameters: "standartListǃ\(currentList)",
                    condition: "user = \(userId)",
                    userId: userId
                )
                settingsChooseStandrartListShow()
            }
            else {
                currentList = Int(exactly: dataBase.select(
                    table: "lists",
                    parameters: "id",
                    condition: "folder = \(currentDir) and name = '\(lists[0])'"
                )[0]["0"] as! Int64)!
            }
            pageLoader(animationDuaration: 0.0)
        }
        else {
            standartDeep = 1
            pageLoader(animationDuaration: 0.0)
            if (settingsChooseListButtonShowed) {
                settingsChooseStandrartListHide()
            }
        }
    }
    
    func settingsLoader () {
        SettingsDirectoryLabel.frame.origin.x = SettingsFolderLabel.frame.origin.x
        SettingsListsLabel.frame.origin.x = SettingsFolderLabel.frame.origin.x
        SettingsListsSwitch.frame.origin.x = SettingsFolderSwitch.frame.origin.x
        SettingsDirectoryPopUp.frame.origin.x = SettingsFolderSwitch.frame.origin.x - 102
        SettingsChooseListLabel.frame.origin.x = SettingsFolderLabel.frame.origin.x
        SettingsChooseListPopUp.frame.origin.x = SettingsFolderSwitch.frame.origin.x - 151
        
        let request: [String: Any?] = dataBase.select(
            table: "settings",
            parameters: "folder, list, standartFolder, standartList",
            condition: "user = \(userId)"
        )[0]
        
        if (Int(exactly: request["0"] as! Int64)! == 0) {
            SettingsFolderSwitch.isOn = false
            if (settingsChooseDirButtonShowed) {
                let activeFolder: String = dataBase.select(
                    table: "folders",
                    parameters: "name",
                    condition: "id = \(Int(exactly: request["2"] as! Int64)!)"
                )[0]["0"] as! String
                settingsChooseStandrartDirShow(active: activeFolder)
            }
            if (Int(exactly: request["1"] as! Int64)! == 0) {
                settingsListsSwitchShow(isOn: false)
                if (settingsChooseListButtonShowed) {
                    let activeList: String = dataBase.select(
                        table: "lists",
                        parameters: "name",
                        condition: "id = \(Int(exactly: request["3"] as! Int64)!)"
                    )[0]["0"] as! String
                    settingsChooseStandrartListShow(active: activeList)
                }
            }
            else {
                settingsListsSwitchShow(isOn: true)
            }
        }
        popUpButtonLanguage(active: lang)
        viewShow(object: Settings)
    }
    
    func settingsListsSwitchShow (isOn: Bool = true) {
        SettingsListsSwitch.isOn = isOn
        var yLabel: Double = 0
        var ySwitch: Double = 0
        if (settingsChooseDirButtonShowed) {
            yLabel = SettingsDirectoryLabel.frame.origin.y + 30
            ySwitch = SettingsDirectoryPopUp.frame.origin.y + 30
            SettingsListsLabel.frame.origin.y = SettingsDirectoryLabel.frame.origin.y
            SettingsListsSwitch.frame.origin.y = SettingsDirectoryPopUp.frame.origin.y
        }
        else {
            yLabel = SettingsFolderLabel.frame.origin.y + 40
            ySwitch = SettingsFolderSwitch.frame.origin.y + 40
            SettingsListsLabel.frame.origin.y = SettingsFolderLabel.frame.origin.y
            SettingsListsSwitch.frame.origin.y = SettingsFolderSwitch.frame.origin.y
        }
        SettingsListsLabel.alpha = 0.0
        SettingsListsSwitch.alpha = 0.0
        SettingsListsLabel.isHidden = false
        SettingsListsSwitch.isHidden = false
        UIView.animate(withDuration: 1) {
            self.SettingsListsLabel.alpha = 1.0
            self.SettingsListsSwitch.alpha = 1.0
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.SettingsListsLabel.frame.origin.y = yLabel
            self.SettingsListsSwitch.frame.origin.y = ySwitch
        }, completion: {_ in
            self.SettingsFolderSwitch.isEnabled = true
        })
    }
    
    func settingsListsSwitchHide () {
        SettingsFolderSwitch.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.SettingsListsLabel.alpha = 0.0
            self.SettingsListsSwitch.alpha = 0.0
        }
        UIView.animate(withDuration: 0.8, animations: {
            self.SettingsListsLabel.frame.origin.y = self.SettingsFolderLabel.frame.origin.y
            self.SettingsListsSwitch.frame.origin.y = self.SettingsFolderSwitch.frame.origin.y
        }, completion: {_ in
            self.SettingsListsLabel.isHidden = true
            self.SettingsListsSwitch.isHidden = true
            self.SettingsListsLabel.alpha = 1.0
            self.SettingsListsSwitch.alpha = 1.0
            self.SettingsListsSwitch.isOn = false
            self.SettingsFolderSwitch.isEnabled = true
        })
    }
    
    func settingsChooseStandrartDirShow (active: String = "") {
        SettingsFolderSwitch.isEnabled = false
        settingsChooseDirButtonShowed = true
        var yLabel: Double = 0
        var ySwitch: Double = 0
        yLabel = SettingsFolderLabel.frame.origin.y + 30
        ySwitch = SettingsFolderSwitch.frame.origin.y + 30
        SettingsDirectoryLabel.alpha = 0.0
        SettingsDirectoryLabel.frame.origin.y = SettingsFolderLabel.frame.origin.y
        SettingsDirectoryPopUp.alpha = 0.0
        SettingsDirectoryPopUp.frame.origin.y = SettingsFolderSwitch.frame.origin.y
        SettingsDirectoryLabel.isHidden = false
        SettingsDirectoryPopUp.isHidden = false
        UIView.animate(withDuration: 1) {
            self.SettingsDirectoryLabel.alpha = 1.0
            self.SettingsDirectoryPopUp.alpha = 1.0
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.SettingsDirectoryLabel.frame.origin.y = yLabel
            self.SettingsDirectoryPopUp.frame.origin.y = ySwitch
        }, completion: {_ in
            self.SettingsFolderSwitch.isEnabled = true
        })
        popUpButtonFolder(active: active)
    }
    
    func settingsChooseStandrartDirHide () {
        SettingsFolderSwitch.isEnabled = false
        settingsChooseDirButtonShowed = false
        UIView.animate(withDuration: 0.5) {
            self.SettingsDirectoryLabel.alpha = 0.0
            self.SettingsDirectoryPopUp.alpha = 0.0
        }
        UIView.animate(withDuration: 0.8, animations: {
            self.SettingsDirectoryLabel.frame.origin.y = self.SettingsFolderLabel.frame.origin.y
            self.SettingsDirectoryPopUp.frame.origin.y = self.SettingsFolderSwitch.frame.origin.y
        }, completion: {_ in
            self.SettingsDirectoryLabel.isHidden = true
            self.SettingsDirectoryPopUp.isHidden = true
            self.SettingsDirectoryLabel.alpha = 1.0
            self.SettingsDirectoryPopUp.alpha = 1.0
            self.SettingsFolderSwitch.isEnabled = true
        })
    }
    
    func settingsChooseStandrartListShow (active: String = "") {
        SettingsListsSwitch.isEnabled = false
        settingsChooseListButtonShowed = true
        var yLabel: Double = 0
        var ySwitch: Double = 0
        yLabel = SettingsListsLabel.frame.origin.y + 30
        ySwitch = SettingsListsSwitch.frame.origin.y + 30
        SettingsChooseListLabel.alpha = 0.0
        SettingsChooseListLabel.frame.origin.y = SettingsListsLabel.frame.origin.y
        SettingsChooseListPopUp.alpha = 0.0
        SettingsChooseListPopUp.frame.origin.y = SettingsListsSwitch.frame.origin.y
        SettingsChooseListLabel.isHidden = false
        SettingsChooseListPopUp.isHidden = false
        UIView.animate(withDuration: 1) {
            self.SettingsChooseListLabel.alpha = 1.0
            self.SettingsChooseListPopUp.alpha = 1.0
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.SettingsChooseListLabel.frame.origin.y = yLabel
            self.SettingsChooseListPopUp.frame.origin.y = ySwitch
        }, completion: {_ in
            self.SettingsListsSwitch.isEnabled = true
        })
        popUpButtonList(active: active)
    }
    
    func settingsChooseStandrartListHide () {
        SettingsListsSwitch.isEnabled = false
        settingsChooseListButtonShowed = false
        UIView.animate(withDuration: 0.5) {
            self.SettingsChooseListLabel.alpha = 0.0
            self.SettingsChooseListPopUp.alpha = 0.0
        }
        UIView.animate(withDuration: 0.8, animations: {
            self.SettingsChooseListLabel.frame.origin.y = self.SettingsListsLabel.frame.origin.y
            self.SettingsChooseListPopUp.frame.origin.y = self.SettingsListsSwitch.frame.origin.y
        }, completion: {_ in
            self.SettingsChooseListLabel.isHidden = true
            self.SettingsChooseListPopUp.isHidden = true
            self.SettingsChooseListLabel.alpha = 1.0
            self.SettingsChooseListPopUp.alpha = 1.0
            self.SettingsListsSwitch.isEnabled = true
        })
    }
    
    func popUpButtonFolder (active: String = "") {
        let optionClosure = {(action: UIAction) in
            self.popUpButtonFolderAction(action: action.title, mode: "main")
        }
        var optionsArray = [UIAction]()
        var indexActive: Int = 0
        let dirs: [String] = dataBase.dictToListString(
            dict: dataBase.select(
                table: "folders",
                parameters: "name",
                condition: "user = \(userId)"
            )
        )
        for i in 0...(dirs.count - 1) {
            let action = UIAction(title: dirs[i], state: .off, handler: optionClosure)
            optionsArray.append(action)
            if (dirs[i] == active) {
                indexActive = i
            }
        }
        optionsArray[indexActive].state = .on
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        SettingsDirectoryPopUp.menu = optionsMenu
        SettingsDirectoryPopUp.changesSelectionAsPrimaryAction = true
        SettingsDirectoryPopUp.showsMenuAsPrimaryAction = true
    }
    
    func popUpButtonFolderAction(action: String, mode: String) {
        currentDir = Int(exactly: dataBase.select(
            table: "folders",
            parameters: "id",
            condition: "name = '\(action)' and user = \(userId)"
        )[0]["0"] as! Int64)!
        if (SettingsListsSwitch.isOn == false) {
            let lists: [String] = dataBase.dictToListString(
                dict: dataBase.select(
                    table: "lists",
                    parameters: "name",
                    condition: "folder = \(currentDir)"
                )
            )
            if (lists.isEmpty) {
                dataBase.insert(
                    table: "lists",
                    parameters: "\(currentDir)ǃǃ'StandartList'ǃǃ'Clear'",
                    userId: userId
                )
            }
            currentList = Int(exactly: dataBase.select(
                table: "lists",
                parameters: "id",
                condition: "folder = \(currentDir)"
            )[0]["0"] as! Int64)!
            
            if (lists.count == 1) {
                if (settingsChooseListButtonShowed) {
                    if (mode == "main") {
                        settingsChooseStandrartListHide()
                    }
                }
            } else {
                popUpButtonList()
                if (!settingsChooseListButtonShowed) {
                    if (mode == "main") {
                        settingsChooseStandrartListShow()
                    }
                }
            }
        }
        pageLoader(animationDuaration: 0.0)
        dataBase.update(
            table: "settings",
            parameters: "standartFolderǃ\(currentDir)",
            condition: "user = \(userId)",
            userId: userId
        )
    }
    
    func popUpButtonList (active: String = "") {
        let optionClosure = {(action: UIAction) in
            self.popUpButtonListAction(action: action.title, update: true)
        }
        var optionsArray = [UIAction]()
        var indexActive: Int = 0
        let lists: [String] = dataBase.dictToListString(
            dict: dataBase.select(
                table: "lists",
                parameters: "name",
                condition: "folder = \(currentDir)"
            )
        )
        if (!lists.isEmpty) {
            for i in 0...(lists.count - 1) {
                let action = UIAction(title: lists[i], state: .off, handler: optionClosure)
                optionsArray.append(action)
                if (lists[i] == active) {
                    indexActive = i
                }
            }
        }
        optionsArray[indexActive].state = .on
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        SettingsChooseListPopUp.menu = optionsMenu
        SettingsChooseListPopUp.changesSelectionAsPrimaryAction = true
        SettingsChooseListPopUp.showsMenuAsPrimaryAction = true
    }
    
    func popUpButtonListAction(action: String, update: Bool) {
        currentList = Int(exactly: dataBase.select(
            table: "lists",
            parameters: "id",
            condition: "name = '\(action)' and folder = \(currentDir)"
        )[0]["0"] as! Int64)!
        if (update) {
            pageLoader(animationDuaration: 0.0)
        }
        dataBase.update(
            table: "settings",
            parameters: "standartListǃ\(currentList)",
            condition: "user = \(userId)",
            userId: userId
        )
    }
    
    func loadSettings () {
        
        var settings: [String: Any?] = dataBase.select(
            table: "settings",
            parameters: "*",
            condition: "user = \(userId)"
        )[0]
        
        let settingsKeys: [String: String] = [
            "0": "id",
            "1": "user",
            "2": "folder",
            "3": "standartFolder",
            "4": "list",
            "5": "standartList",
            "6": "notifications",
            "7": "timeUntilEnd",
            "8": "language",
            "9": "warningBeforeComplete"
        ]
        
        for i in 0...9 {
            let key = String(i)
            let elem = settings[key]
            settings.removeValue(forKey: key)
            settings[settingsKeys[key]!] = elem
        }
        
        if (Int(exactly: settings["folder"] as! Int64) == 0) {
            SettingsFolderSwitch.isOn = Int(exactly: settings["folder"] as! Int64)! != 0
            standartDeep = 1
            let dirs: [String] = dataBase.dictToListString(
                dict: dataBase.select(
                    table: "folders",
                    parameters: "name",
                    condition: "user = \(userId)"
                )
            )
            if (dirs.isEmpty) {
                dataBase.insert(
                    table: "folders",
                    parameters: "\(userId)ǃǃ'StandartFolder'ǃǃ'Clear'",
                    userId: userId
                )
                currentDir = Int(exactly: dataBase.select(
                    table: "folders",
                    parameters: "id",
                    condition: "name = 'StandartFolder' and user = \(userId)"
                )[0]["0"] as! Int64)!
            }
            else if (dirs.count == 1) {
                currentDir = Int(exactly: dataBase.select(
                    table: "folders",
                    parameters: "id",
                    condition: "name = '\(dirs[0])' and user = \(userId)"
                )[0]["0"] as! Int64)!
            }
            else {
                settingsChooseDirButtonShowed = true
                currentDir = Int(exactly: settings["standartFolder"] as! Int64)!
                if (currentDir == 0) {
                    currentDir = Int(exactly: dataBase.select(
                        table: "folders",
                        parameters: "id",
                        condition: "user = \(userId)"
                    )[0]["0"] as! Int64)!
                }
            }
            settingsListsShowed = true
            if (Int(exactly: settings["list"] as! Int64)! == 0) {
                standartDeep = 2
                let lists: [String] = dataBase.dictToListString(
                    dict: dataBase.select(
                        table: "lists",
                        parameters: "name",
                        condition: "folder = \(currentDir)"
                    )
                )
                if (lists.isEmpty) {
                    dataBase.insert(
                        table: "lists",
                        parameters: "\(currentDir)ǃǃ'StandartList'ǃǃ'Clear'",
                        userId: userId
                    )
                    currentList = Int(exactly: dataBase.select(
                        table: "lists",
                        parameters: "id",
                        condition: "folder = \(currentDir) and name = 'StandartList'"
                    )[0]["0"] as! Int64)!
                }
                else if (lists.count == 1) {
                    currentList = Int(exactly: dataBase.select(
                        table: "lists",
                        parameters: "id",
                        condition: "folder = \(currentDir) and name = '\(lists[0])'"
                    )[0]["0"] as! Int64)!
                }
                else {
                    settingsChooseListButtonShowed = true
                    currentList = Int(exactly: settings["standartList"] as! Int64)!
                }
            }
        }
        if (Int(exactly: settings["notifications"] as! Int64) == 0) {
            SettingsNotificationsAdditionLabel.alpha = 0.0
            SettingsNotificationsSwitch.isOn = false
            SettingsChooseTimeDatePicker.alpha = 0.0
        }
        else {
            let interval: Int = Int(exactly: settings["timeUntilEnd"] as! Int64)! - 3 * 60 * 60
            let date = Date(timeIntervalSince1970: TimeInterval(interval))
            SettingsChooseTimeDatePicker.date = date
        }
        messageCompleteTask = Int(exactly: settings["warningBeforeComplete"] as! Int64) != 0
        SettingsAskToCompleteSwitch.isOn = messageCompleteTask
    }
    
    func settingsOnOffNotifications (sender: UISwitch) {
        notificationsIsOn = sender.isOn
        dataBase.update(
            table: "settings",
            parameters: "notificationsǃ\(notificationsIsOn ? 1 : 0)",
            condition: "user = \(userId)",
            userId: userId
        )
        if (notificationsIsOn) {
            let y = SettingsNotificationLabel.frame.origin.y + 37
            UIView.animate(withDuration: 1, animations: {
                self.SettingsNotificationsAdditionLabel.alpha = 1.0
                self.SettingsChooseTimeDatePicker.alpha = 1.0
            })
            UIView.animate(withDuration: 0.5, animations: {
                self.SettingsNotificationsAdditionLabel.frame.origin.y = y
                self.SettingsChooseTimeDatePicker.frame.origin.y = y
            }, completion: {_ in
                self.SettingsChooseTimeDatePicker.isEnabled = true
            })
            
        }
        else {
            SettingsChooseTimeDatePicker.isEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.SettingsNotificationsAdditionLabel.alpha = 0.0
                self.SettingsChooseTimeDatePicker.alpha = 0.0
            }
            UIView.animate(withDuration: 0.8, animations: {
                self.SettingsNotificationsAdditionLabel.frame.origin.y = self.SettingsNotificationLabel.frame.origin.y
                self.SettingsChooseTimeDatePicker.frame.origin.y = self.SettingsNotificationsSwitch.frame.origin.y
            }, completion: {_ in
                self.SettingsChooseTimeDatePicker.isEnabled = false
            })
        }
    }
    
    func settingsNotificationsDatePickerAction (sender: UIDatePicker) {
        var date = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sender.date)
        date.year = 1970
        date.month = 1
        date.day = 1
        date.timeZone = TimeZone(identifier: "GMT")
        if let date_ = Calendar.current.date(from: date) {
            settingsDatePickerTimestamp = Int(Double(date_.timeIntervalSince1970))
        } else {}
        dataBase.update(
            table: "settings",
            parameters: "timeUntilEndǃ\(settingsDatePickerTimestamp)",
            condition: "user = \(userId)",
            userId: userId
        )
        sendAllNotifications()
    }
    
    func popUpButtonLanguage (active: String = "") {
        let optionClosure = {(action: UIAction) in
            self.popUpButtonLanguageAction(action: action.title)
        }
        var optionsArray = [UIAction]()
        var indexActive = 0
        let langs: [String] = dataBase.dictToListString(
            dict: dataBase.select(
                table: "languages",
                parameters: "name"
            )
        )
        for i in 0...(langs.count - 1) {
            let action = UIAction(title: langs[i], state: .off, handler: optionClosure)
            optionsArray.append(action)
            if (langs[i] == active) {
                indexActive = i
            }
        }
        optionsArray[indexActive].state = .on
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        SettingsLanguagePopUp.menu = optionsMenu
        SettingsLanguagePopUp.changesSelectionAsPrimaryAction = true
        SettingsLanguagePopUp.showsMenuAsPrimaryAction = true
    }
    
    func popUpButtonLanguageAction(action: String) {
        if (action != lang) {
            Tint.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.Tint.alpha = 1.00
            }, completion: {_ in
                self.languageDirctionary = self.translation.translate(lang: action)
                let langId: Int = Int(exactly: self.dataBase.select(
                    table: "languages",
                    parameters: "id",
                    condition: "name = '\(action)'"
                )[0]["0"] as! Int64)!
                self.dataBase.update(
                    table: "settings",
                    parameters: "languageǃ\(langId)",
                    condition: "user = \(self.userId)",
                    userId: self.userId
                )
                self.lang = action
                self.setLanguage()
            })
            UIView.animate(withDuration: 0.5, animations: {
                self.Tint.alpha = 0.00
            }, completion: {_ in
                self.Tint.isHidden = true
            })
        }
    }
    
    func settingsAskToCompleteSwitchAction (sender: UISwitch) {
        messageCompleteTask = sender.isOn
        dataBase.update(
            table: "settings",
            parameters: "warningBeforeCompleteǃ\(messageCompleteTask ? 1 : 0)",
            condition: "user = \(userId)",
            userId: userId
        )
    }
}
