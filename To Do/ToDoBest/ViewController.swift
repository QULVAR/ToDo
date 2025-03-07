import UIKit
import Foundation

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    //Views
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var MainPage: UIView!
    @IBOutlet var AuthPage: UIView!
    @IBOutlet weak var NewPSD: UIView!
    @IBOutlet weak var Tint: UIView!
    @IBOutlet var Settings: UIView!
    @IBOutlet weak var TaskInfo: UIView!
    @IBOutlet weak var RegisterPage: UIView!
    @IBOutlet weak var LookingForNetView: UIView!
    
    //LookingForNet
    @IBOutlet weak var LookingForNetLabel: UILabel!
    
    
    //Auth Page elements
    @IBOutlet weak var AuthPageLoginTextField: UITextField!
    @IBOutlet weak var AuthPagePasswordTextField: UITextField!
    
    
    //Register Page elements
    @IBOutlet weak var RegisterPageLoginTextField: UITextField!
    @IBOutlet weak var RegisterPagePasswordTextField: UITextField!
    @IBOutlet weak var RegisterPagePasswordConfirmTextField: UITextField!
    
    
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
    @IBOutlet weak var TaskInfoDatePickerContainer: UIView!
    @IBOutlet weak var TaskInfoDateButton: UIButton!
    @IBOutlet var TaskInfoTint: UIView!
    
    
    //Variables for all project
    var languageDirctionary: [String: String] = ["":""]
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
    var loaderLayer: CAShapeLayer?
    var connectionCheckTimer: Timer?
    var savedStrokeStart: CGFloat = 0
    var savedStrokeEnd: CGFloat = 0
    var complitingTaskFlag: Bool = false
    
    let translation = LanguageExtension()
    
    let dataBase = try! DataBase()
    var userId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainPage.isHidden = true
        TaskInfo.isHidden = true
        Settings.isHidden = true
        NewPSD.isHidden = true
        Tint.isHidden = true
        RegisterPage.isHidden = true
        AuthPage.isHidden = true
        LookingForNetView.isHidden = true
        
        _ = dataBase.checkConnectionNetwork()
        let dataBaseLoadCode: Int = dataBase.dataBaseViewDidLoad()
        if (dataBaseLoadCode == 2) {
            LookingForNetViewDidLoad()
        }
        else if (dataBaseLoadCode == 1) {
            registerPageViewDidLoad()
            authPageViewDidLoad()
        }
        else if (dataBaseLoadCode == 0) {
            viewControllerViewDidLoad()
        }
    }

    
    func viewControllerViewDidLoad () {
        TaskInfoDatePicker.datePickerMode = .dateAndTime
        TaskInfoDatePicker.preferredDatePickerStyle = .inline
        MainPage.isHidden = false
        TaskInfo.isHidden = false
        Settings.isHidden = false
        NewPSD.isHidden = false
        Tint.isHidden = false
        userId = Int(exactly: dataBase.select(
            table: "users",
            parameters: "id"
        )[0]["0"] as! Int64)!
        dataBase.synchronize(userId: userId)
        let langId: Int = Int(exactly: dataBase.select(
            table: "settings",
            parameters: "language",
            condition: "user = \(userId)"
        )[0]["0"] as! Int64)!
        lang = dataBase.select(
            table: "languages",
            parameters: "name",
            condition: "id = \(langId)"
        )[0]["0"] as! String
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
    
    @IBAction func AuthPageSignInButton(_ sender: UIButton) {
        authPageSignInButtonAction(sender: sender)
    }
    
    @IBAction func AuthPageSignUpButton(_ sender: UIButton) {
        authPageSignUpButtonAction(sender: sender)
    }
    
    @IBAction func RegisterPageSignUpButton(_ sender: UIButton) {
        registerPageSignInButtonAction(sender: sender)
    }
    
    @IBAction func RegisterPageSignInButton(_ sender: UIButton) {
        registerPageSignUpButtonAction(sender: sender)
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
        changeButtonDate()
    }
    
    @IBAction func TaskInfoDateButtonAction(_ sender: UIButton) {
        taskInfoDateButtonAction(sender: sender)
    }
    
}
