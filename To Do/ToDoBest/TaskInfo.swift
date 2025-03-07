import UIKit

extension ViewController {
    
    func taskInfoViewDidLoad () {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        TaskInfo.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(datePickerHide))
        TaskInfoTint.addGestureRecognizer(tapGesture2)
        TaskInfo.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
        TaskInfo.isHidden = true
        TaskInfo.frame.origin.y = MainView.frame.height
        TaskInfoDescriptionText.frame.origin.x = TaskInfoDecriptionLabel.frame.origin.x
        TaskInfoDescriptionText.frame.origin.y = TaskInfoDecriptionLabel.frame.origin.y + 30
        TaskInfoDescriptionText.layer.cornerRadius = 25
        TaskInfoDatePicker.date = Date()
        changeButtonDate()
        TaskInfoDatePickerContainer.isHidden = true
        TaskInfoDatePickerContainer.frame.origin.x = 0
        TaskInfoDatePickerContainer.frame.origin.y = TaskInfo.frame.height
        TaskInfoDatePickerContainer.layer.cornerRadius = 25
        TaskInfoTint.isHidden = true
        TaskInfoTint.alpha = 0
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
            if (taskPropertiesTimestamp != -1) {
                dataBase.update(
                    table: "taskProperties",
                    parameters: "timestampǃ'\(String(taskInfoDatePickerTimestamp))'",
                    condition: "task = \(currentTask)",
                    userId: userId
                )
                if (String(taskInfoDatePickerTimestamp) != "") {
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
                    
                    let timestamp: Int = dataBase.select(
                        table: "taskProperties",
                        parameters: "timestamp",
                        condition: "task = \(currentTask)"
                    )[0]["0"] as! Int
                    
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
            }
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
        TaskInfoDescriptionText.frame.origin.x = TaskInfoDecriptionLabel.frame.origin.x
        TaskInfoDescriptionText.frame.origin.y = TaskInfoDecriptionLabel.frame.origin.y + 30
        TaskInfoTitleText.frame.origin.x = TaskInfoDecriptionLabel.frame.origin.x
        TaskInfoTitleText.frame.origin.y = TaskInfoDecriptionLabel.frame.origin.y - 53
        TaskInfoTitleText.text = name
        TaskInfoDescriptionText.text = description
        let request = dataBase.select(
            table: "taskProperties",
            parameters: "timestamp",
            condition: "task = \(currentTask)"
        )
        if (!request.isEmpty) {
            if let timestamp = request[0]["0"] as? Int64 {
                TaskInfoDatePicker.date = Date(timeIntervalSince1970: TimeInterval(Int(exactly: timestamp)!))
                changeButtonDate()
            }
        }
        viewShow(object: TaskInfo)
    }
    
    func taskInfoDateButtonAction (sender: UIButton) {
        datePickerShow()
    }
    
    func datePickerShow() {
        TaskInfoTint.isHidden = false
        TaskInfoDatePickerContainer.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.TaskInfoDatePickerContainer.frame.origin.y = self.TaskInfo.frame.height / 2 - 90
            self.TaskInfoTint.alpha = 0.5
        }
    }
    
    @objc func datePickerHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.TaskInfoDatePickerContainer.frame.origin.y = self.TaskInfo.frame.height
            self.TaskInfoTint.alpha = 0
        }, completion: {_ in
            self.TaskInfoTint.isHidden = true
            self.TaskInfoDatePickerContainer.isHidden = true
        })
    }
    
    func changeButtonDate() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 25),
            .foregroundColor: UIColor.link
        ]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: TaskInfoDatePicker.date)
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: TaskInfoDatePicker.date)
        let attributedText = NSAttributedString(string: "\(dateString) | \(timeString)", attributes: attributes)
        TaskInfoDateButton.setAttributedTitle(attributedText, for: .normal)
    }
}
