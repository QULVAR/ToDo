class LanguageExtension {
    var RussianDict = [
        "MainPageMainLabelFolders": "Папки",
        "MainPageMainLabelLists": "Списки",
        "MainPageMainLabelTasks": "Дела",
        "MainPageUpperLabel": "Главная страница",
        "MainPageTrashButtonFolder": "у папку",
        "MainPageTrashButtonList": "от список",
        "MainPageBackButton": "Назад",
        
        "SettingsMainLabel": "Настройки",
        "SettingsCategoryDirs": "Вкл/Выкл папки",
        "SettingsFoldersLabel": "Папки",
        "SettingsChooseDir": "Выберите текущую папку",
        "SettingsListsLabel": "Списки",
        "SettingsChooseList": "Выберите текущий список",
        "SettingsCategoryNotifications": "Уведомления",
        "SettingsNotificationsLabel": "Уведомления",
        "SettingsChooseTimeLabel": "Выберите время до конца задания",
        "SettingsStandartDirectory": "Папка",
        "SettingsStandartList": "Список",
        "SettingsLanguageLabel": "Язык",
        "SettingsAskToCompleteTaskLabel": "Запрос о завершении дела",
        "SettingsBackButton": "Назад",
        
        "TaskInfoMainLabel": "Информация",
        "TaskInfoTaskNameLabel": "Задание",
        "TaskInfoTaskDescriptionLabel": "Описание",
        "TaskInfoTaskDateLabel": "Дата",
        "TaskInfoBackButton": "Назад",
        "TaskInfoSaveButton": "Сохранить",
        
        "NewPSDLabelTextPattern": "Дайте имя ваш",
        "NewPSDAddingToPatternFolder": "ей папке",
        "NewPSDAddingToPatternList": "ему списку",
        "NewPSDAddingToPatternTask": "ему заданию",
        "NewPSDContinueButton": "Продолжить",
        
        "MessageBoxDeleteTitle": "Предупреждение",
        "MessageBoxDeleteBody": "Вы уверены, что хотите удалить эт",
        "MessageBoxDeleteSecondAction": "Отмена",
        
        "MessageBoxExistErrorTitle": "Ошибка",
        "MessageBoxExistErrorBodyFolder": "Такая папка уже существует!",
        "MessageBoxExistErrorBodyList": "Такой список уже существует!",
        "MessageBoxExistErrorBodyTask": "Такое дело уже существует!",
        "MessageBoxExistErrorSecondAction": "Ок",
        
        "MessageBoxEmptyErrorTitle": "Ошибка",
        "MessageBoxEmptyErrorBody": "Имя не должно быть пустым!",
        "MessageBoxEmptyErrorSecondAction": "Ок",
        
        "MessageBoxCompleteTaskTitle": "Предупреждение",
        "MessageBoxCompleteTaskBody": "Вы уверены, что хотите завершить это дело?",
        "MessageBoxCompleteTaskSecondAction": "Отмена",
        
        "MessageBoxActionDelete": "Удалить",
        "MessageBoxActionComplete": "Завершить",
        
        "NotificationDeadline": "Время вышло!",
        "NotificationDeadlineSoon": "Время подходит к концу!"
    ]
    
    var EnglishDict = [
        "MainPageMainLabelFolders": "Folders",
        "MainPageMainLabelLists": "Lists",
        "MainPageMainLabelTasks": "Tasks",
        "MainPageUpperLabel": "Main page",
        "MainPageTrashButtonFolder": "folder",
        "MainPageTrashButtonList": "list",
        "MainPageBackButton": "Back",
        
        "SettingsMainLabel": "Settings",
        "SettingsCategoryDirs": "On/Off directories",
        "SettingsFoldersLabel": "Folders",
        "SettingsChooseDir": "Choose standart directory",
        "SettingsListsLabel": "Lists",
        "SettingsChooseList": "Choose standart list",
        "SettingsCategoryNotifications": "Notifications",
        "SettingsNotificationsLabel": "Notifications",
        "SettingsChooseTimeLabel": "Choose the time until the end of task",
        "SettingsStandartDirectory": "Directory",
        "SettingsStandartList": "List",
        "SettingsLanguageLabel": "Language",
        "SettingsAskToCompleteTaskLabel": "Warning to complete task",
        "SettingsBackButton": "Back",
        
        "TaskInfoMainLabel": "Info",
        "TaskInfoTaskNameLabel": "Task",
        "TaskInfoTaskDescriptionLabel": "Description",
        "TaskInfoTaskDateLabel": "Date",
        "TaskInfoBackButton": "Back",
        "TaskInfoSaveButton": "Save",
        
        "NewPSDLabelTextPattern": "Name for new ",
        "NewPSDAddingToPatternFolder": "folder",
        "NewPSDAddingToPatternList": "list",
        "NewPSDAddingToPatternTask": "task",
        "NewPSDContinueButton": "Continue",
        
        "MessageBoxDeleteTitle": "Warning",
        "MessageBoxDeleteBody": "Are you sure, that you want delete this ",
        "MessageBoxDeleteSecondAction": "Cancel",
        
        "MessageBoxExistErrorTitle": "Error",
        "MessageBoxExistErrorBodyFolder": "This folder already exist!",
        "MessageBoxExistErrorBodyList": "This list already exist!",
        "MessageBoxExistErrorBodyTask": "This task already exist!",
        "MessageBoxExistErrorSecondAction": "Ok",
        
        "MessageBoxEmptyErrorTitle": "Error",
        "MessageBoxEmptyErrorBody": "Name must not be empty!",
        "MessageBoxEmptyErrorSecondAction": "Ok",
        
        "MessageBoxActionDelete": "Delete",
        "MessageBoxActionComplete": "Complete",
        
        "MessageBoxCompleteTaskTitle": "Warning",
        "MessageBoxCompleteTaskBody": "Are you sure you want to complete the task?",
        "MessageBoxCompleteTaskSecondAction": "Cancel",
        
        "NotificationDeadline": "Time is up!",
        "NotificationDeadlineSoon": "Deadline is coming soon!"
    ]
    
    func translate(lang: String) -> [String: String] {
        if (lang == "Русский") {
            return RussianDict
        }
        else if (lang == "English") {
            return EnglishDict
        }
        return ["":""]
    }
}
