import UIKit
import Foundation

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    //Views
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var MainPage: UIView!
    @IBOutlet weak var NewPSD: UIView!
    @IBOutlet weak var Tint: UIView!
    @IBOutlet var Settings: UIView!
    @IBOutlet weak var TaskInfo: UIView!
    
    
    //Main Page elements
    @IBOutlet weak var MainPageMainLabel: UILabel!
    @IBOutlet weak var MainPageTrashButton: UIButton!
    @IBOutlet weak var MainPageScroll: UIScrollView!
    @IBOutlet weak var MainPageUpperLabel: UILabel!
    @IBOutlet weak var MainPagePlusButton: UIButton!
    @IBOutlet weak var MainPageBackButton: UIButton!
    @IBOutlet weak var MainPageInfoModeButton: UIButton!
    var lineView: UIView?
    
    
    //NewPSD View elements
    @IBOutlet weak var NewPSDLabel: UILabel!
    @IBOutlet weak var NewPSDTextField: UITextField!
    @IBOutlet weak var NewPSDContinueButton: UIButton!
    @IBOutlet weak var NewPSDColorButton: UIButton!
    @IBOutlet weak var NewPSDBackButton: UIButton!
    
    
    //Settings View elements
    @IBOutlet weak var SettingsMainLabel: UILabel!
    @IBOutlet weak var SettingsOnOffDirCategoryLabel: UILabel!
    @IBOutlet weak var SettingsFolderLabel: UILabel!
    @IBOutlet weak var SettingsFolderSwitch: UISwitch!
    @IBOutlet weak var SettingsListsSwitch: UISwitch!
    @IBOutlet weak var SettingsListsLabel: UILabel!
    @IBOutlet weak var SettingsDirectoryPopUp: UIButton!
    @IBOutlet weak var SettingsDirectoryLabel: UILabel!
    @IBOutlet weak var SettingsChooseListLabel: UILabel!
    @IBOutlet weak var SettingsChooseListPopUp: UIButton!
    @IBOutlet weak var SettingsNotificationCategoryLabel: UILabel!
    @IBOutlet weak var SettingsNotificationLabel: UILabel!
    @IBOutlet weak var SettingsNotificationsSwitch: UISwitch!
    @IBOutlet weak var SettingsNotificationsAdditionLabel: UILabel!
    @IBOutlet weak var SettingsChooseTimeDatePicker: UIDatePicker!
    @IBOutlet weak var SettingsLanguageLabel: UILabel!
    @IBOutlet weak var SettingsLanguagePopUp: UIButton!
    @IBOutlet weak var SettingsAskToCompleteLabel: UILabel!
    @IBOutlet weak var SettingsAskToCompleteSwitch: UISwitch!
    @IBOutlet weak var SettingsBackButton: UIButton!
    
    
    //TaskInfo View elements
    @IBOutlet weak var TaskInfoMainLabel: UILabel!
    @IBOutlet weak var TaskInfoTaskLabel: UILabel!
    @IBOutlet weak var TaskInfoDescriptionText: UITextView!
    @IBOutlet weak var TaskInfoDecriptionLabel: UILabel!
    @IBOutlet weak var TaskInfoTitleText: UITextField!
    @IBOutlet weak var TaskInfoDatePicker: UIDatePicker!
    @IBOutlet weak var TaskInfoDateLabel: UILabel!
    @IBOutlet weak var TaskInfoBackButton: UIButton!
    @IBOutlet weak var TaskInfoSaveButton: UIButton!
    
    
    //Variables for all project
    var languageDirctionary: [String: String] = ["":""]
    var langs: [String] = ["English", "Русский"]
    var lang: String = "English"
    var const = 0.0
    var const1 = 0.0
    var standartDeep: Int = 0
    var viewDeep: Int = 0
    var currentDir: Int = -1
    var currentList: Int = -1
    var currentTask: Int = -1
    var newPSDLabelTextPattern: String = ""
    var scrollButtons: [UIButton] = []
    var taskInfoOpen: Bool = false
    var scrollViewButtonPressed: Bool = false
    var settingsListsShowed: Bool = false
    var notificationsIsOn: Bool = true
    var messageCompleteTask: Bool = true
    var settingsChooseDirButtonShowed: Bool = false
    var settingsChooseListButtonShowed: Bool = false
    var textSize: CGSize?
    var buttonColor: UIColor = UIColor.clear
    var labelColor: UIColor = UIColor.clear
    var taskInfoDatePickerTimestamp: Int = 0
    var settingsDatePickerTimestamp: Int = 0
    
    var settingsClient: [String] = ["", "", "", "", "", "", "", ""]
    var dirsClient: [String] = []
    var dirsPropertiesClient: [[String]] = []
    var listsClient: [[String]] = []
    var listsPropertiesClient: [[[String]]] = []
    var tasksClient: [[[String]]] = []
    var tasksPropertiesClient: [[[[String]]]] = []
    var timestampClient: Int = 0
    
    var settingsServer: [String] = ["", "", "", "", "", "", "", ""]
    var dirsServer: [String] = []
    var dirsPropertiesServer: [[String]] = []
    var listsServer: [[String]] = []
    var listsPropertiesServer: [[[String]]] = []
    var tasksServer: [[[String]]] = []
    var tasksPropertiesServer: [[[[String]]]] = []
    var timestampServer: Int = 0
    
    let serverSaveName: String = "Qulvar"
    
    let translation = LanguageExtension()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLoader()
        lang = settingsClient[6]
        languageDirctionary = translation.translate(lang: lang)
        setLanguage()
        NotificationController.requestPermission()
        const = MainView.frame.size.width / 2
        const1 = NewPSD.frame.size.width / 2
        mainPageViewDidLoad()
        newPSDViewDidLoad()
        tintViewDidLoad()
        settingsViewDidLoad()
        taskInfoViewDidLoad()
        viewDeep = standartDeep
        pageLoader(animationDuaration: 0.0)
    }
    
    @IBAction func MainPagePlus(_ sender: UIButton) {
        mainPagePlusButtonAction(sender: sender)
    }
    
    @IBAction func NewPSDBackButton(_ sender: UIButton) {
        newPSDBackButtonAction(sender: sender)
    }
    
    @IBAction func MainPageSettings(_ sender: UIButton) {
        settingsLoader()
    }
    
    @IBAction func MainPageInfoModeButtonAction(_ sender: UIButton) {
        mainPageInfoModeButtonAction(sender: sender)
    }
    
    @IBAction func TaskInfoSaveButton(_ sender: UIButton) {
        taskInfoSaveButtonAction(sender: sender)
    }
    
    @IBAction func MainPageTrash(_ sender: UIButton) {
        mainPageTrashButtonAction(sender: sender)
    }
    
    @IBAction func MainPageBackButtonAction(_ sender: UIButton) {
        mainPageBackButtonAction(sender: sender)
    }
    
    @IBAction func NewPSDContinueButton(_ sender: UIButton) {
        newPSDContinueButtonAction(sender: sender)
    }
    
    @IBAction func SettingsOnOffFolders(_ sender: UISwitch) {
        settingsOnOffFoldersAction(sender: sender)
    }
    
    @IBAction func SettingsOnOffLists(_ sender: UISwitch) {
        settingsOnOffLists(sender: sender)
    }
    
    @IBAction func SettingsOnOffNotifications(_ sender: UISwitch) {
        settingsOnOffNotifications(sender: sender)
    }
    
    @IBAction func SettingsNotificationsDatePicker(_ sender: UIDatePicker) {
        settingsNotificationsDatePickerAction(sender: sender)
    }
    
    @IBAction func SettingsAskToCompleteSwitch(_ sender: UISwitch) {
        settingsAskToCompleteSwitchAction(sender: sender)
    }
    
    @IBAction func SettingsBackButton(_ sender: UIButton) {
        viewHide(object: Settings)
    }
    
    @IBAction func TaskInfoBackButton(_ sender: UIButton) {
        taskInfoBackButtonAction(sender: sender)
    }
    
    @IBAction func NewPSDSetColorButton(_ sender: UIButton) {
        newPSDColorButtonAction(sender: sender)
    }
    
    @IBAction func TaskInfoDatePickerAction(_ sender: UIDatePicker) {
        taskInfoDatePickerTimestamp = Int(Double(sender.date.timeIntervalSince1970))
    }
}
