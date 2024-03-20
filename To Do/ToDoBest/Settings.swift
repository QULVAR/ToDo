import UIKit

extension ViewController {
    
    func settingsViewDidLoad () {
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
        settingsClient[0] = String(sender.isOn)
        if (!(SettingsFolderSwitch.isOn)) {
            standartDeep = 1
            if (viewDeep == 0) {
                viewDeep = standartDeep
            }
            currentDir = 0
            if (dirsClient.count == 0) {
                dirsClient.append(languageDirctionary["SettingsStandartDirectory"].unsafelyUnwrapped)
                dirsPropertiesClient.append([])
                listsClient.append([])
                listsPropertiesClient.append([])
                tasksClient.append([])
                tasksPropertiesClient.append([])
                settingsClient[1] = languageDirctionary["SettingsStandartDirectory"].unsafelyUnwrapped
            }
            else if (dirsClient.count > 1) {
                settingsClient[1] = dirsClient[currentDir]
                settingsChooseStandrartDirShow()
            }
            settingsClient[2] = "true"
            settingsClient[3] = ""
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
                self.settingsClient[2] = "true"
                self.settingsClient[1] = ""
            })
        }
        saveData()
    }
    
    func settingsOnOffLists(sender: UISwitch) {
        settingsClient[2] = String(sender.isOn)
        if (!(sender.isOn)) {
            standartDeep = 2
            if (viewDeep == 1) {
                viewDeep = standartDeep
            }
            currentList = 0
            if (listsClient[currentDir].count == 0) {
                listsClient[currentDir].append(languageDirctionary["SettingsStandartList"].unsafelyUnwrapped)
                listsPropertiesClient[currentDir].append([])
                tasksClient[currentDir].append([])
                tasksPropertiesClient[currentDir].append([])
                settingsClient[3] = languageDirctionary["SettingsStandartList"].unsafelyUnwrapped
            }
            else if (listsClient[currentDir].count > 1) {
                settingsClient[3] = listsClient[currentDir][currentList]
                settingsChooseStandrartListShow()
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
        saveData()
    }
    
    func settingsLoader () {
        SettingsDirectoryLabel.frame.origin.x = SettingsFolderLabel.frame.origin.x
        SettingsListsLabel.frame.origin.x = SettingsFolderLabel.frame.origin.x
        SettingsListsSwitch.frame.origin.x = SettingsFolderSwitch.frame.origin.x
        SettingsDirectoryPopUp.frame.origin.x = SettingsFolderSwitch.frame.origin.x - 102
        SettingsChooseListLabel.frame.origin.x = SettingsFolderLabel.frame.origin.x
        SettingsChooseListPopUp.frame.origin.x = SettingsFolderSwitch.frame.origin.x - 151
        if (settingsClient[0] == "false") {
            SettingsFolderSwitch.isOn = false
            if (settingsChooseDirButtonShowed) {
                settingsChooseStandrartDirShow(active: settingsClient[1])
            }
            if (settingsClient[2] == "false") {
                settingsListsSwitchShow(isOn: false)
                if (settingsChooseListButtonShowed) {
                    settingsChooseStandrartListShow(active: settingsClient[3])
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
        for i in 0...(dirsClient.count - 1) {
            let action = UIAction(title: dirsClient[i], state: .off, handler: optionClosure)
            optionsArray.append(action)
            if (dirsClient[i] == active) {
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
        currentDir = dirsClient.firstIndex(of: action).unsafelyUnwrapped
        if (listsClient[currentDir].count == 0) {
            listsClient[currentDir].append(languageDirctionary["SettingsStandartList"].unsafelyUnwrapped)
            listsPropertiesClient[currentDir].append([])
            tasksClient[currentDir].append([])
            tasksPropertiesClient[currentDir].append([])
        }
        if (SettingsListsSwitch.isOn == false) {
            currentList = 0
            if (listsClient[currentDir].count == 1) {
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
        settingsClient[1] = action
        saveData()
    }
    
    func popUpButtonList (active: String = "") {
        let optionClosure = {(action: UIAction) in
            self.popUpButtonListAction(action: action.title, update: true)
        }
        var optionsArray = [UIAction]()
        var indexActive: Int = 0
        for i in 0...(listsClient[currentDir].count - 1) {
            let action = UIAction(title: listsClient[currentDir][i], state: .off, handler: optionClosure)
            optionsArray.append(action)
            if (listsClient[currentDir][i] == active) {
                indexActive = i
            }
        }
        optionsArray[indexActive].state = .on
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        SettingsChooseListPopUp.menu = optionsMenu
        SettingsChooseListPopUp.changesSelectionAsPrimaryAction = true
        SettingsChooseListPopUp.showsMenuAsPrimaryAction = true
    }
    
    func popUpButtonListAction(action: String, update: Bool) {
        currentList = listsClient[currentDir].firstIndex(of: action).unsafelyUnwrapped
        if (update) {
            pageLoader(animationDuaration: 0.0)
        }
        settingsClient[3] = action
        saveData()
    }
    
    func loadSettings () {
        if (settingsClient[0] == "false") {
            SettingsFolderSwitch.isOn = Bool(settingsClient[0]).unsafelyUnwrapped
            standartDeep = 1
            if (dirsClient.count == 0) {
                dirsClient.append(languageDirctionary["SettingsStandartDirectory"].unsafelyUnwrapped)
                dirsPropertiesClient.append([])
                listsClient.append([])
                listsPropertiesClient.append([])
                tasksClient.append([])
                tasksPropertiesClient.append([])
                currentDir = 0
            }
            else if (dirsClient.count == 1) {currentDir = 0}
            else {
                settingsChooseDirButtonShowed = true
                currentDir = dirsClient.firstIndex(of: settingsClient[1]).unsafelyUnwrapped
            }
            settingsListsShowed = true
            if (settingsClient[2] == "false") {
                standartDeep = 2
                if (listsClient[currentDir].count == 0) {
                    listsClient[currentDir].append(languageDirctionary["SettingsStandartList"].unsafelyUnwrapped)
                    listsPropertiesClient[currentDir].append([])
                    tasksClient[currentDir].append([])
                    tasksPropertiesClient[currentDir].append([])
                    currentList = 0
                }
                else if (listsClient[currentDir].count == 1) {currentList = 0}
                else {
                    settingsChooseListButtonShowed = true
                    currentList = listsClient[currentDir].firstIndex(of: settingsClient[3]).unsafelyUnwrapped
                }
            }
        }
        if (settingsClient[4] == "") {
            settingsClient[4] = "true"
        }
        if (!Bool(settingsClient[4]).unsafelyUnwrapped) {
            SettingsNotificationsAdditionLabel.alpha = 0.0
            SettingsNotificationsSwitch.isOn = false
            SettingsChooseTimeDatePicker.alpha = 0.0
        }
        else {
            let date = Date(timeIntervalSince1970: TimeInterval(Int(settingsClient[5]).unsafelyUnwrapped - 10800))
            SettingsChooseTimeDatePicker.date = date
        }
        messageCompleteTask = Bool(settingsClient[7]).unsafelyUnwrapped
        SettingsAskToCompleteSwitch.isOn = messageCompleteTask
    }
    
    func settingsOnOffNotifications (sender: UISwitch) {
        notificationsIsOn = sender.isOn
        settingsClient[4] = String(notificationsIsOn)
        if (sender.isOn) {
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
        saveData()
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
        settingsClient[5] = String(settingsDatePickerTimestamp)
        sendAllNotifications()
        saveData()
    }
    
    func popUpButtonLanguage (active: String = "") {
        let optionClosure = {(action: UIAction) in
            self.popUpButtonLanguageAction(action: action.title)
        }
        var optionsArray = [UIAction]()
        var indexActive = 0
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
                self.settingsClient[6] = action
                self.lang = action
                self.setLanguage()
                self.saveData()
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
        settingsClient[7] = String(messageCompleteTask)
    }
}
