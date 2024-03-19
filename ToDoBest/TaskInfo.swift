import UIKit

extension ViewController {
    
    func taskInfoViewDidLoad () {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        TaskInfo.addGestureRecognizer(tapGesture)
        TaskInfo.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
        TaskInfo.isHidden = true
        TaskInfo.frame.origin.y = MainView.frame.height
        TaskInfoDescriptionText.frame.origin.x = TaskInfoDecriptionLabel.frame.origin.x
        TaskInfoDescriptionText.frame.origin.y = TaskInfoDecriptionLabel.frame.origin.y + 30
        TaskInfoDescriptionText.layer.cornerRadius = 25
        TaskInfoDatePicker.date = Date()
    }
    
    func taskInfoSaveButtonAction (sender: UIButton) {
        tasksPropertiesClient[currentDir][currentList][currentTask][2] = TaskInfoDescriptionText.text.unsafelyUnwrapped
        if (tasksPropertiesClient[currentDir][currentList][currentTask].count >= 2) {
            cancelNotification(task: tasksClient[currentDir][currentList][currentTask] + "1")
            cancelNotification(task: tasksClient[currentDir][currentList][currentTask] + "2")
        }
        tasksClient[currentDir][currentList][currentTask] = TaskInfoTitleText.text.unsafelyUnwrapped
        if (taskInfoDatePickerTimestamp != 0) {
            if (tasksPropertiesClient[currentDir][currentList][currentTask].count >= 2) {
                tasksPropertiesClient[currentDir][currentList][currentTask][1] = String(taskInfoDatePickerTimestamp)
                if (tasksPropertiesClient[currentDir][currentList][currentTask][1] != "") {
                    let id_ = dirsClient[currentDir] + "/" + listsClient[currentDir][currentList] + "/" + tasksClient[currentDir][currentList][currentTask]
                    sendNotification(id: id_ + "1", title: tasksClient[currentDir][currentList][currentTask], body: languageDirctionary["NotificationDeadline"].unsafelyUnwrapped, timestamp: Int(tasksPropertiesClient[currentDir][currentList][currentTask][1])!)
                    sendNotification(id: id_ + "2", title: tasksClient[currentDir][currentList][currentTask], body: languageDirctionary["NotificationDeadlineSoon"].unsafelyUnwrapped, timestamp: Int(tasksPropertiesClient[currentDir][currentList][currentTask][1])! - settingsDatePickerTimestamp)
                }
            }
        }
        taskInfoDatePickerTimestamp = 0
        pageLoader(animationDuaration: 0.0)
        viewHide(object: TaskInfo)
        saveData()
    }
    
    func taskInfoBackButtonAction (sender: UIButton) {
        viewHide(object: TaskInfo)
        taskInfoDatePickerTimestamp = 0
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func taskInfoLoader (name: String, description: String) {
        TaskInfoDatePicker.frame.size = CGSize(width: 195, height: 50)
        TaskInfoDescriptionText.frame.origin.x = TaskInfoDecriptionLabel.frame.origin.x
        TaskInfoDescriptionText.frame.origin.y = TaskInfoDecriptionLabel.frame.origin.y + 30
        TaskInfoTitleText.frame.origin.x = TaskInfoDecriptionLabel.frame.origin.x
        TaskInfoTitleText.frame.origin.y = TaskInfoDecriptionLabel.frame.origin.y - 53
        TaskInfoTitleText.text = name
        TaskInfoDescriptionText.text = description
        TaskInfoDatePicker.frame.origin.x = TaskInfoDateLabel.frame.origin.x - 23
        TaskInfoDatePicker.frame.origin.y = TaskInfoDateLabel.frame.origin.y + TaskInfoDateLabel.frame.height
        let timestamp = tasksPropertiesClient[currentDir][currentList][currentTask][1]
        if (timestamp != "") {
            TaskInfoDatePicker.date = Date(timeIntervalSince1970: TimeInterval(timestamp).unsafelyUnwrapped)
        }
        viewShow(object: TaskInfo)
    }
    
}
