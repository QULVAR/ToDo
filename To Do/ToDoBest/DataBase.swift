import Foundation
import SQLite

class DataBase {
    
    let db: Connection
    var connection: Bool = false

    init() throws {
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dbPath = documentsDirectory.appendingPathComponent("db.sqlite3").path
        self.db = try Connection(dbPath)
    }
    
    func dataBaseViewDidLoad () -> Int {
        if !self.dataBaseExists() {
            if (self.createDataBase()) {
                return 1
            }
            else {
                return 2
            }
        }
        else {
            let res = self.select(table: "users", parameters: "*")
            if (!res.isEmpty) {
                if (res[0]["0"] == nil) {
                    return 1
                }
            }
            else {
                return 1
            }
        }
        return 0
    }
    
    func dataBaseExists () -> Bool {
        do {
            let tableCount = try db.scalar("SELECT COUNT(*) FROM sqlite_master WHERE type='table'") as! Int64
            
            if tableCount == 0 {
                return false
            }
        }
        catch {}
        return true
    }
    
    func getCreationString () -> String {
        let result = self.select(
            table: "dump",
            parameters: "dump",
            network: true
        )
        if (result[0].isEmpty) {
            return ""
        }
        else {
            return result[0]["dump"] as! String
        }
    }
    
    func createDataBase () -> Bool{
        let request: String = getCreationString()
        if (request != "") {
            try! db.execute(request)
            return true
        }
        else {
            return false
        }
    }
    
    func checkConnectionNetwork () -> Bool {
        let checkConnectionResult: [String:Any] = self.jsonDecode(
            data: self.query(
                funcName: "net",
                parameters: [:]
            )
        )
        connection = !checkConnectionResult.isEmpty
        return connection
    }
}
