import UIKit

extension ViewController {
    
    func viewShow (object: UIView) {
        UIView.animate(withDuration: 0.6) {
            object.frame.origin.y = 0
        }
    }
    
    func viewHide(object: UIView) {
        UIView.animate(withDuration: 0.6) {
            object.frame.origin.y = self.MainPage.frame.height
        }
    }
    
    func deleteElement () {
        var notificationIds: [String] = []
        if (viewDeep == 1) {
            let listsCount = listsClient[currentDir].count - 1
            if (listsCount >= 0) {
                for i in 0...listsCount {
                    let tasksCount = tasksClient[currentDir][i].count - 1
                    if (tasksCount >= 0) {
                        for j in 0...tasksCount {
                            let id = dirsClient[currentDir] + "/" + listsClient[currentDir][i] + "/" + tasksClient[currentDir][i][j]
                            notificationIds.append(id + "1")
                            notificationIds.append(id + "2")
                        }
                    }
                }
            }
            dirsClient.remove(at: currentDir)
            dirsPropertiesClient.remove(at: currentDir)
            listsClient.remove(at: currentDir)
            listsPropertiesClient.remove(at: currentDir)
            tasksClient.remove(at: currentDir)
            tasksPropertiesClient.remove(at: currentDir)
        }
        else if (viewDeep == 2) {
            let tasksCount = tasksClient[currentDir][currentList].count - 1
            if (tasksCount >= 0) {
                for i in 0...tasksCount {
                    let id = dirsClient[currentDir] + "/" + listsClient[currentDir][currentList] + "/" + tasksClient[currentDir][currentList][i]
                    notificationIds.append(id + "1")
                    notificationIds.append(id + "2")
                }
            }
            listsClient[currentDir].remove(at: currentList)
            listsPropertiesClient[currentDir].remove(at: currentList)
            tasksClient[currentDir].remove(at: currentList)
            tasksPropertiesClient[currentDir].remove(at: currentList)
        }
        cancelNotification(ids: notificationIds)
        viewDeep -= 1
        saveData()
    }
    
    func messageBoxShow (title: String, message: String, delFlag: Bool, completeFlag: Bool = false, secondActionText: String, sender: UIButton) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if (delFlag) {
            let deleteAction = UIAlertAction(title: languageDirctionary["MessageBoxActionDelete"].unsafelyUnwrapped, style: .destructive) { _ in
                self.pageLoader(delete: true)
            }
            deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(deleteAction)
        }
        if (completeFlag) {
            let completeAction = UIAlertAction(title: languageDirctionary["MessageBoxActionComplete"].unsafelyUnwrapped, style: .destructive) { _ in
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
            print(id, timestamp)
        }
    }
    
    func cancelNotification (id: String = "", task: String = "", ids: [String] = []) {
        if (notificationsIsOn) {
            var id_ = ""
            if (task != "") {
                id_ = dirsClient[currentDir] + "/" + listsClient[currentDir][currentList] + "/" + task
            }
            NotificationController.cancelNotification(ids: [id])
            NotificationController.cancelNotification(ids: [id_])
            NotificationController.cancelNotification(ids: ids)
        }
    }
    
    func sendAllNotifications () {
        let dirsCount: Int = dirsClient.count - 1
        if (dirsCount >= 0) {
            for dir in 0...dirsCount {
                let listCount: Int = listsClient[dir].count - 1
                if (listCount >= 0) {
                    for list in 0...listCount {
                        let taskCount: Int = tasksClient[dir][list].count - 1
                        if (taskCount >= 0) {
                            for task in 0...taskCount {
                                let taskPropertiesCount: Int = tasksPropertiesClient[dir][list][task].count - 1
                                if (taskPropertiesCount >= 2) {
                                    let timestamp: String = tasksPropertiesClient[dir][list][task][1]
                                    if (timestamp != "") {
                                        let id_ = dirsClient[dir] + "/" + listsClient[dir][list] + "/" + tasksClient[dir][list][task]
                                        sendNotification(id: id_ + "1", title: tasksClient[dir][list][task], body: languageDirctionary["NotificationDeadline"].unsafelyUnwrapped, timestamp: Int(timestamp).unsafelyUnwrapped)
                                        sendNotification(id: id_ + "2", title: tasksClient[dir][list][task], body: languageDirctionary["NotificationDeadlineSoon"].unsafelyUnwrapped, timestamp: Int(timestamp).unsafelyUnwrapped - settingsDatePickerTimestamp)
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
        newPSDLabelTextPattern = languageDirctionary["NewPSDLabelTextPattern"].unsafelyUnwrapped
        var attributedText = NSAttributedString(string: languageDirctionary["MainPageBackButton"].unsafelyUnwrapped, attributes: attributes)
        MainPageBackButton.setAttributedTitle(attributedText, for: .normal)
        attributedText = NSAttributedString(string: languageDirctionary["NewPSDContinueButton"].unsafelyUnwrapped, attributes: attributes)
        NewPSDContinueButton.setAttributedTitle(attributedText, for: .normal)
        SettingsFolderLabel.text = languageDirctionary["SettingsFoldersLabel"].unsafelyUnwrapped
        SettingsDirectoryLabel.text = languageDirctionary["SettingsChooseDir"].unsafelyUnwrapped
        SettingsListsLabel.text = languageDirctionary["SettingsListsLabel"].unsafelyUnwrapped
        SettingsChooseListLabel.text = languageDirctionary["SettingsChooseList"].unsafelyUnwrapped
        SettingsNotificationCategoryLabel.text = languageDirctionary["SettingsCategoryNotifications"].unsafelyUnwrapped
        SettingsNotificationLabel.text = languageDirctionary["SettingsNotificationsLabel"].unsafelyUnwrapped
        SettingsNotificationsAdditionLabel.text = languageDirctionary["SettingsChooseTimeLabel"].unsafelyUnwrapped
        TaskInfoDateLabel.text = languageDirctionary["TaskInfoTaskDateLabel"].unsafelyUnwrapped
        TaskInfoDecriptionLabel.text = languageDirctionary["TaskInfoTaskDescriptionLabel"].unsafelyUnwrapped
        SettingsMainLabel.text = languageDirctionary["SettingsMainLabel"].unsafelyUnwrapped
        SettingsOnOffDirCategoryLabel.text = languageDirctionary["SettingsCategoryDirs"].unsafelyUnwrapped
        SettingsLanguageLabel.text = languageDirctionary["SettingsLanguageLabel"].unsafelyUnwrapped
        SettingsAskToCompleteLabel.text = languageDirctionary["SettingsAskToCompleteTaskLabel"].unsafelyUnwrapped
        attributedText = NSAttributedString(string: languageDirctionary["SettingsBackButton"].unsafelyUnwrapped, attributes: attributes)
        SettingsBackButton.setAttributedTitle(attributedText, for: .normal)
        TaskInfoMainLabel.text = languageDirctionary["TaskInfoMainLabel"].unsafelyUnwrapped
        TaskInfoTaskLabel.text = languageDirctionary["TaskInfoTaskNameLabel"].unsafelyUnwrapped
        attributedText = NSAttributedString(string: languageDirctionary["TaskInfoBackButton"].unsafelyUnwrapped, attributes: attributes)
        TaskInfoBackButton.setAttributedTitle(attributedText, for: .normal)
        attributedText = NSAttributedString(string: languageDirctionary["TaskInfoSaveButton"].unsafelyUnwrapped, attributes: attributes)
        TaskInfoSaveButton.setAttributedTitle(attributedText, for: .normal)
        sendAllNotifications()
        pageLoader(animationDuaration: 0.0)
    }
}
