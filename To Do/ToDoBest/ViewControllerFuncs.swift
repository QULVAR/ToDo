import UIKit

extension ViewController {
    
    func viewShow (object: UIView, duration: Double = 0.6) {
        let duration_: TimeInterval = TimeInterval(duration)
        UIView.animate(withDuration: duration_) {
            object.frame.origin.y = 0
        }
    }
    
    func viewHide(object: UIView, duration: Double = 0.6) {
        let duration_: TimeInterval = TimeInterval(duration)
        UIView.animate(withDuration: duration_) {
            object.frame.origin.y = self.MainPage.frame.height
        }
    }
    
    func deleteElement () {
        var notificationIds: [String] = []
        var flag: Bool = false
        if (viewDeep == 1) {
            
            let dirName: String = dataBase.select(
                table: "folders",
                parameters: "name",
                condition: "id = \(currentDir)"
            )[0]["0"] as! String
            
            let lists: [String] = dataBase.dictToListString(
                dict: dataBase.select(
                    table: "lists",
                    parameters: "name",
                    condition: "folder = \(currentDir)"
                )
            )
            
            if (!lists.isEmpty) {
                for i in 0...(lists.count - 1) {
                    
                    let listId: Int = Int(exactly: dataBase.select(
                        table: "lists",
                        parameters: "id",
                        condition: "name = '\(lists[i])' and folder = \(currentDir)"
                    )[0]["0"] as! Int64)!
                    
                    let tasks: [String] = dataBase.dictToListString(
                        dict: dataBase.select(
                            table: "tasks",
                            parameters: "name",
                            condition: "list = \(listId)"
                        )
                    )
                    
                    if (!tasks.isEmpty) {
                        for j in 0...(tasks.count - 1) {
                            let id = "\(dirName)/\(lists[i])/\(tasks[j])"
                            notificationIds.append(id + "1")
                            notificationIds.append(id + "2")
                            
                            let taskId: Int = Int(exactly: dataBase.select(
                                table: "tasks",
                                parameters: "id",
                                condition: "name = '\(tasks[j])' and list = \(listId)"
                            )[0]["0"] as! Int64)!
                            
                            dataBase.delete(
                                table: "taskProperties",
                                condition: "task = \(taskId)",
                                userId: userId
                            )
                            
                            dataBase.delete(
                                table: "tasks",
                                condition: "id = \(taskId)",
                                userId: userId
                            )
                        }
                    }
                    
                    let settingsStandartList: Any? = dataBase.select(
                        table: "settings",
                        parameters: "standartList",
                        condition: "user = \(userId)"
                    )[0]["0"]!
                    
                    if (settingsStandartList == nil) {
                        flag = false
                    }
                    else {
                        flag = true
                    }
                    
                    if (flag) {
                        dataBase.update(
                            table: "settings",
                            parameters: "standartListǃNULL",
                            condition: "user = \(userId)",
                            userId: userId
                        )
                    }
                    
                    dataBase.delete(
                        table: "lists",
                        condition: "id = \(listId)",
                        userId: userId
                    )
                }
            }
            
            let settingsStandartFolder: Any? = dataBase.select(
                table: "settings",
                parameters: "standartFolder",
                condition: "user = \(userId)"
            )[0]["0"]!
            
            if (settingsStandartFolder == nil) {
                flag = false
            }
            else {
                flag = true
            }
            
            
            if (flag) {
                dataBase.update(
                    table: "settings",
                    parameters: "standartFolderǃNULL",
                    condition: "user = \(userId)",
                    userId: userId
                )
            }
            
            dataBase.delete(
                table: "folders",
                condition: "id = \(currentDir)",
                userId: userId
            )
            
        }
        else if (viewDeep == 2) {
            
            let dirName: String = dataBase.select(
                table: "folders",
                parameters: "name",
                condition: "id = \(currentDir)"
            )[0]["0"] as! String
            
            let listName: String = dataBase.select(
                table: "lists",
                parameters: "name",
                condition: "id = \(currentList)"
            )[0]["0"] as! String
            
            let tasks: [String] = dataBase.dictToListString(
                dict: dataBase.select(
                    table: "tasks",
                    parameters: "name",
                    condition: "list = \(currentList)"
                )
            )
            
            if (!tasks.isEmpty) {
                for i in 0...(tasks.count - 1) {
                    let id = "\(dirName)/\(listName)/\(tasks[i])"
                    notificationIds.append(id + "1")
                    notificationIds.append(id + "2")
                    
                    let taskId: Int = Int(exactly: dataBase.select(
                        table: "tasks",
                        parameters: "id",
                        condition: "name = '\(tasks[i])' and list = \(currentList)"
                    )[0]["0"] as! Int64)!
                    
                    dataBase.delete(
                        table: "taskProperties",
                        condition: "task = \(taskId)",
                        userId: userId
                    )
                    
                    dataBase.delete(
                        table: "tasks",
                        condition: "id = \(taskId)",
                        userId: userId
                    )
                }
            }
            
            dataBase.delete(
                table: "lists",
                condition: "id = \(currentList)",
                userId: userId
            )
        }
        cancelNotification(ids: notificationIds)
        viewDeep -= 1
    }
    
    func messageBoxShow (title: String, message: String, delFlag: Bool, completeFlag: Bool = false, secondActionText: String, sender: UIButton) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if (delFlag) {
            let deleteAction = UIAlertAction(title: languageDirctionary["MessageBoxActionDelete"]!, style: .destructive) { _ in
                self.pageLoader(delete: true)
            }
            deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(deleteAction)
        }
        if (completeFlag) {
            let completeAction = UIAlertAction(title: languageDirctionary["MessageBoxActionComplete"]!, style: .destructive) { _ in
                self.mainPageScrollButtonCompleteTask(sender: sender)
            }
            completeAction.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(completeAction)
        }
        let cancelAction = UIAlertAction(title: secondActionText, style: .cancel) { _ in}
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendNotification (id: String, title: String, body: String, timestamp: Int) {
        if (notificationsIsOn) {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            NotificationController.scheduleNotificationAtSpecificTime(title: title, body: body, dateComponents: dateComponents, id: id)
        }
    }
    
    func cancelNotification (id: String = "", task: String = "", ids: [String] = []) {
        if (notificationsIsOn) {
            var id_ = ""
            if (task != "") {
                let dirName: String = dataBase.select(
                    table: "folders",
                    parameters: "name",
                    condition: "id = \(currentDir)"
                )[0]["0"] as! String
                let listName: String = dataBase.select(
                    table: "lists",
                    parameters: "name",
                    condition: "id = \(currentList)"
                )[0]["0"] as! String
                id_ = "\(dirName)/\(listName)/\(task)"
            }
            NotificationController.cancelNotification(ids: [id])
            NotificationController.cancelNotification(ids: [id_])
            NotificationController.cancelNotification(ids: ids)
        }
    }
    
    func sendAllNotifications () {
        let dirs: [String] = dataBase.dictToListString(
            dict: dataBase.select(
                table: "folders",
                parameters: "name",
                condition: "user = \(userId)"
            )
        )
        if (!dirs.isEmpty) {
            for dir in 0...(dirs.count - 1) {
                
                let dirId: Int = Int(exactly: dataBase.select(
                    table: "folders",
                    parameters: "id",
                    condition: "name = '\(dirs[dir])' and user = \(userId)"
                )[0]["0"] as! Int64)!
                
                let lists: [String] = dataBase.dictToListString(
                    dict: dataBase.select(
                        table: "lists",
                        parameters: "name",
                        condition: "folder = \(dirId)"
                    )
                )
                
                if (!lists.isEmpty) {
                    for list in 0...(lists.count - 1) {
                        
                        let listId: Int = Int(exactly: dataBase.select(
                            table: "lists",
                            parameters: "id",
                            condition: "name = '\(lists[list])' and folder = \(dirId)"
                        )[0]["0"] as! Int64)!
                        
                        let tasks: [String] = dataBase.dictToListString(
                            dict: dataBase.select(
                                table: "tasks",
                                parameters: "name",
                                condition: "list = \(listId)"
                            )
                        )
                        
                        if (!tasks.isEmpty) {
                            for task in 0...(tasks.count - 1) {
                                
                                let taskId: Int = Int(exactly: dataBase.select(
                                    table: "tasks",
                                    parameters: "id",
                                    condition: "name = '\(tasks[task])' and list = \(listId)"
                                )[0]["0"] as! Int64)!
                                
                                let request = dataBase.select(
                                    table: "taskProperties",
                                    parameters: "timestamp",
                                    condition: "task = \(taskId)"
                                )
                                
                                if (!request.isEmpty) {
                                    if let timestamp = request[0]["0"] as? Int64 {
                                        
                                        let id = "\(dirs[dir])/\(lists[list])/\(tasks[task])"
                                        
                                        sendNotification(
                                            id: id + "1",
                                            title: tasks[task],
                                            body: languageDirctionary["NotificationDeadline"]!,
                                            timestamp: Int(exactly: timestamp)!
                                        )
                                        
                                        sendNotification(
                                            id: id + "2",
                                            title: tasks[task],
                                            body: languageDirctionary["NotificationDeadlineSoon"]!,
                                            timestamp: Int(exactly: timestamp)! - settingsDatePickerTimestamp
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setLanguage() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 25),
            .foregroundColor: UIColor.link
        ]
        newPSDLabelTextPattern = languageDirctionary["NewPSDLabelTextPattern"]!
        var attributedText = NSAttributedString(string: languageDirctionary["MainPageBackButton"]!, attributes: attributes)
        MainPageBackButton.setAttributedTitle(attributedText, for: .normal)
        attributedText = NSAttributedString(string: languageDirctionary["NewPSDContinueButton"]!, attributes: attributes)
        NewPSDContinueButton.setAttributedTitle(attributedText, for: .normal)
        SettingsFolderLabel.text = languageDirctionary["SettingsFoldersLabel"]!
        SettingsDirectoryLabel.text = languageDirctionary["SettingsChooseDir"]!
        SettingsListsLabel.text = languageDirctionary["SettingsListsLabel"]!
        SettingsChooseListLabel.text = languageDirctionary["SettingsChooseList"]!
        SettingsNotificationCategoryLabel.text = languageDirctionary["SettingsCategoryNotifications"]!
        SettingsNotificationLabel.text = languageDirctionary["SettingsNotificationsLabel"]!
        SettingsNotificationsAdditionLabel.text = languageDirctionary["SettingsChooseTimeLabel"]!
        TaskInfoDateLabel.text = languageDirctionary["TaskInfoTaskDateLabel"]!
        TaskInfoDecriptionLabel.text = languageDirctionary["TaskInfoTaskDescriptionLabel"]!
        SettingsMainLabel.text = languageDirctionary["SettingsMainLabel"]!
        SettingsOnOffDirCategoryLabel.text = languageDirctionary["SettingsCategoryDirs"]!
        SettingsLanguageLabel.text = languageDirctionary["SettingsLanguageLabel"]!
        SettingsAskToCompleteLabel.text = languageDirctionary["SettingsAskToCompleteTaskLabel"]!
        attributedText = NSAttributedString(string: languageDirctionary["SettingsBackButton"]!, attributes: attributes)
        SettingsBackButton.setAttributedTitle(attributedText, for: .normal)
        TaskInfoMainLabel.text = languageDirctionary["TaskInfoMainLabel"]!
        TaskInfoTaskLabel.text = languageDirctionary["TaskInfoTaskNameLabel"]!
        attributedText = NSAttributedString(string: languageDirctionary["TaskInfoBackButton"]!, attributes: attributes)
        TaskInfoBackButton.setAttributedTitle(attributedText, for: .normal)
        attributedText = NSAttributedString(string: languageDirctionary["TaskInfoSaveButton"]!, attributes: attributes)
        TaskInfoSaveButton.setAttributedTitle(attributedText, for: .normal)
        sendAllNotifications()
        pageLoader(animationDuaration: 0.0)
    }
}
