import Foundation

extension ViewController {
    
    func dataReader (data: String, mode: String) {
        var settings: [String] = []
        var dirs: [String] = []
        var dirsProperties: [[String]] = []
        var lists: [[String]] = []
        var listsProperties: [[[String]]] = []
        var tasks: [[[String]]] = []
        var tasksProperties: [[[[String]]]] = []
        var timestamp: Int = 0
        var splitData: [String] = data.split(separator: "\n").map(String.init)
        let timestampSettings: [String] = splitData[splitData.count - 1].split(separator: "/S/").map(String.init)
        splitData.removeLast()
        if (timestampSettings.count == 2) {
            settings = timestampSettings[1].split(separator: ",", omittingEmptySubsequences: false).map(String.init)
        }
        timestamp = Int(Double(timestampSettings[0]).unsafelyUnwrapped)
        if (splitData.count > 0) {
            let splitDataP: [String] = splitData[0].split(separator: "/separatorP/").map(String.init)
            if (splitDataP.count > 0) {
                for i in 0...(splitDataP.count - 1) {
                    var listsDir: [String] = []
                    var listsDirProperties: [[String]] = []
                    var tasksDir: [[String]] = []
                    var tasksDirProperties: [[[String]]] = []
                    var splitDataPS: [String] = []
                    let a: [String] = splitDataP[i].split(separator: "/separatorS/").map(String.init)
                    for j in 0...(a.count - 1) {
                        splitDataPS.append(a[j])
                    }
                    var splitDir: [String] = splitDataPS[0].split(separator: "***", omittingEmptySubsequences: false).map(String.init)
                    dirs.append(splitDir[0])
                    splitDir.removeFirst()
                    dirsProperties.append(splitDir)
                    splitDataPS.removeFirst()
                    if (splitDataPS.count > 0) {
                        for j in 0...(splitDataPS.count - 1) {
                            var tasksList: [String] = []
                            var tasksListProperties: [[String]] = []
                            var splitDataPSD: [String] = []
                            let a: [String] = splitDataPS[j].split(separator: "/separatorD/").map(String.init)
                            for k in 0...(a.count - 1) {
                                splitDataPSD.append(a[k])
                            }
                            splitDir = splitDataPSD[0].split(separator: "***", omittingEmptySubsequences: false).map(String.init)
                            listsDir.append(splitDir[0])
                            splitDir.removeFirst()
                            listsDirProperties.append(splitDir)
                            splitDataPSD.removeFirst()
                            if (splitDataPSD.count > 0) {
                                for k in 0...(splitDataPSD.count - 1) {
                                    var a: [String] = splitDataPSD[k].split(separator: "***", omittingEmptySubsequences: false).map(String.init)
                                    tasksList.append(a[0])
                                    a.removeFirst()
                                    tasksListProperties.append(a)
                                }
                            }
                            tasksDir.append(tasksList)
                            tasksDirProperties.append(tasksListProperties)
                        }
                    }
                    lists.append(listsDir)
                    listsProperties.append(listsDirProperties)
                    tasks.append(tasksDir)
                    tasksProperties.append(tasksDirProperties)
                }
            }
        }
        if (mode == "Client") {
            settingsClient = settings
            dirsClient = dirs
            dirsPropertiesClient = dirsProperties
            listsClient = lists
            listsPropertiesClient = listsProperties
            tasksClient = tasks
            tasksPropertiesClient = tasksProperties
            timestampClient = timestamp
        }
        else if (mode == "Server") {
            settingsServer = settings
            dirsServer = dirs
            dirsPropertiesServer = dirsProperties
            listsServer = lists
            listsPropertiesServer = listsProperties
            tasksServer = tasks
            tasksPropertiesServer = tasksProperties
            timestampServer = timestamp
        }
    }
    
    func dataWriter () -> String {
        var string: String = ""
        if (dirsClient.count > 0) {
            for dir in 0...(dirsClient.count - 1) {
                string += "/separatorP/" + dirsClient[dir]
                if (dirsPropertiesClient[dir].count > 0) {
                    for dirProperty in 0...(dirsPropertiesClient[dir].count - 1) {
                        string += "***" + dirsPropertiesClient[dir][dirProperty]
                    }
                }
                if (listsClient[dir].count > 0) {
                    for list in 0...(listsClient[dir].count - 1) {
                        string += "/separatorS/" + listsClient[dir][list]
                        if (listsPropertiesClient[dir][list].count > 0) {
                            for listProperty in 0...(listsPropertiesClient[dir][list].count - 1) {
                                string += "***" + listsPropertiesClient[dir][list][listProperty]
                            }
                        }
                        if (tasksClient[dir][list].count > 0) {
                            for task in 0...(tasksClient[dir][list].count - 1) {
                                string += "/separatorD/" + tasksClient[dir][list][task]
                                if (tasksPropertiesClient[dir][list][task].count > 0) {
                                    for taskProperty in 0...(tasksPropertiesClient[dir][list][task].count - 1) {
                                        string += "***" + tasksPropertiesClient[dir][list][task][taskProperty]
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        string += "\n" + String(Int(Date().timeIntervalSince1970)) + "/S/"
        for opt in 0...(settingsClient.count - 1) {
            string += settingsClient[opt]
            if (opt != settingsClient.count - 1) {
                string += ","
            }
        }
        return string
    }
    
    func saveData () {
        let data = dataWriter()
        if let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.QULVAR.ToDo") {
            let fileURL = directory.appendingPathComponent("Text.txt")
            do {
                try data.write(to: fileURL, atomically: true, encoding: .utf8)
            }
            catch {}
        }
        serverPost(data: data) { responseString in if responseString != nil {} else {}}
    }
    
    func dataLoader() {
        var dataServer: String = ""
        var flag: Bool = false
        serverGet { dataString in
            if let dataString = dataString {
                dataServer = dataString
                flag = true
            } else {flag = true}
        }
        wait {return flag}
        var dataClient = ""
        if let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.QULVAR.ToDo") {
            let fileURL = directory.appendingPathComponent("Text.txt")
            do {
                dataClient = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {}
        }
        if (dataServer != "") {
            dataReader(data: dataServer, mode: "Server")
        }
        if (dataClient != "") {
            dataReader(data: dataClient, mode: "Client")
        }
        while (settingsClient.count < 8) {
            settingsClient.append("")
        }
        while (settingsServer.count < 8) {
            settingsServer.append("")
        }
        if (timestampClient > timestampServer) {
            serverPost(data: dataClient) { responseString in if responseString != nil {} else {}}
        }
        else if (timestampClient < timestampServer) {
            settingsClient = settingsServer
            dirsClient = dirsServer
            dirsPropertiesClient = dirsPropertiesServer
            listsClient = listsServer
            listsPropertiesClient = listsPropertiesServer
            tasksClient = tasksServer
            tasksPropertiesClient = tasksPropertiesServer
            timestampClient = timestampServer
            saveData()
        }
        if (settingsClient[5] == "") {
            settingsClient[5] = String(Int(Double(Date().timeIntervalSince1970)))
        }
        settingsDatePickerTimestamp = Int(settingsClient[5]).unsafelyUnwrapped
    }
}
