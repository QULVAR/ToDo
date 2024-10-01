import UIKit

extension ViewController {
    
    func taskInfoViewDidLoad () {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        TaskInfo.addGestureRecognizer(tapGesture)
        TaskInfo.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
        TaskInfo.frame.origin.y = MainView.frame.height
        TaskInfo.isHidden = true
        TaskInfoDescriptionText.frame.origin.x = TaskInfoDecriptionLabel.frame.origin.x
        TaskInfoDescriptionText.frame.origin.y = TaskInfoDecriptionLabel.frame.origin.y + 30
        TaskInfoDescriptionText.layer.cornerRadius = 25
        TaskInfoDatePicker.date = Date()
    }
    
    func taskInfoSaveButtonAction (sender: UIButton) {
        dataBase.update(
            table: "taskProperties",
            parameters: "descriptionǃ'\(TaskInfoDescriptionText.text!)'",
            condition: "task = \(currentTask)",
            userId: userId
        )
        let task: String = dataBase.select(
            table: "tasks",
            parameters: "name",
            condition: "id = \(currentTask)"
        )[0]["0"] as! String
        let request = dataBase.select(
            table: "taskProperties",
            parameters: "timestamp",
            condition: "task = \(currentTask)"
        )
        var taskPropertiesTimestamp: Int = 0
        if let timestamp = request[0]["0"] as? Int64 {
            taskPropertiesTimestamp = Int(exactly: timestamp)!
        }
        else {
            taskPropertiesTimestamp = -1
        }
        if (taskPropertiesTimestamp != -1) {
            cancelNotification(task: "\(task)1")
            cancelNotification(task: "\(task)2")
        }
        dataBase.update(
            table: "tasks",
            parameters: "nameǃ'\(TaskInfoTitleText.text!)'",
            condition: "id = \(currentTask)",
            userId: userId
        )
        if (taskInfoDatePickerTimestamp != 0) {
            dataBase.update(
                table: "taskProperties",
                parameters: "timestampǃ\(taskInfoDatePickerTimestamp)",
                condition: "task = \(currentTask)",
                userId: userId
            )
            let dir: String = dataBase.select(
                table: "folders",
                parameters: "name",
                condition: "id = \(currentDir)"
            )[0]["0"] as! String
            
            let list: String = dataBase.select(
                table: "lists",
                parameters: "name",
                condition: "id = \(currentList)"
            )[0]["0"] as! String
            
            let task: String = dataBase.select(
                table: "tasks",
                parameters: "name",
                condition: "id = \(currentTask)"
            )[0]["0"] as! String
            
            let id_: String = dir + "/" + list + "/" + task
            
            let timestamp: Int = taskInfoDatePickerTimestamp
            
            sendNotification(
                id: id_ + "1",
                title: task,
                body: languageDirctionary["NotificationDeadline"]!,
                timestamp: timestamp
            )
            
            sendNotification(
                id: id_ + "2",
                title: task,
                body: languageDirctionary["NotificationDeadlineSoon"]!,
                timestamp: timestamp - settingsDatePickerTimestamp
            )
        }
        taskInfoDatePickerTimestamp = 0
        pageLoader(animationDuaration: 0.0)
        viewHide(object: TaskInfo)
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
        let request = dataBase.select(
            table: "taskProperties",
            parameters: "timestamp",
            condition: "task = \(currentTask)"
        )
        if (!request.isEmpty) {
            if let timestamp = request[0]["0"] as? Int64 {
                TaskInfoDatePicker.date = Date(timeIntervalSince1970: TimeInterval(Int(exactly: timestamp)!))
            }
        }
        viewShow(object: TaskInfo)
    }
    
}
