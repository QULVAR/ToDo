import Foundation
import SQLite

class DataBase {
    
    let db: Connection

    init() throws {
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dbPath = documentsDirectory.appendingPathComponent("db.sqlite3").path
        self.db = try Connection(dbPath)
    }
    
    func dataBaseViewDidLoad () -> Bool {
        if !self.dataBaseExists() {
            self.createDataBase()
            return true
        }
        else {
            let res = self.select(table: "users", parameters: "*")
            if (!res.isEmpty) {
                if (res[0]["0"] == nil) {
                    return true
                }
            }
            else {
                return true
            }
        }
        return false
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
        let result = select(table: "dump", parameters: "dump", network: true)
        return result[0]["dump"] as! String
    }
    
    func createDataBase () {
        try! db.execute(getCreationString())
    }
}
