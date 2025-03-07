import Foundation
import SQLite

extension DataBase {
    
    func select(table: String, parameters: String, condition: String = "", network: Bool = false) -> [[String: Any?]] {
        if (network && connection) {
            let json = jsonDecode(data: query(funcName: "select", parameters: [
                "table": table,
                "params": parameters,
                "condition": condition
            ]))
            return json.isEmpty ? [] : json["result"] as! [[String: Any?]]
        }
        else {
            var result: [[String: Any?]] = [[:]]
            var conditionWhere: String = ""
            if condition != "" {
                conditionWhere = " WHERE \(condition)"
            }
            let request = "SELECT \(parameters) FROM \(table)\(conditionWhere)"
            if request != "SELECT dump FROM dump" {
                for row in try! db.prepare(request) {
                    result.append(Dictionary(uniqueKeysWithValues: row.enumerated().map { (String($0), $1) }) as! [String: Any?])
                }
                result.removeFirst()
                return result
            }
            else {
                return [[:]]
            }
        }
    }
    
    func insert(table: String, parameters: String, userId: Int, createUser: Bool = false, local: Bool = true, network: Bool = true, id_ : Int = -1) {
        var id: Int = 0
        if (network && connection) {
            _ = query(funcName: "insert", parameters: [
                "table": table,
                "params": parameters
            ], async: true)
            if (local) {
                if table == "taskProperties" {
                    let request = self.select(
                        table: table,
                        parameters: "id",
                        condition: "task = \(parameters.split(separator: "ǃǃ")[0])",
                        network: true
                    )
                    if (!request.isEmpty) {
                        id = Int(request[0]["id"] as! String)!
                    }
                }
                else {
                    var columns = self.getColumns(
                        table: table
                    )
                    columns.remove(at: columns.firstIndex(of: "id")!)
                    let paramsSplit = parameters.split(separator: "ǃǃ")
                    var condition = ""
                    for i in 0...columns.count - 1{
                        condition += "\(columns[i]) = \(paramsSplit[i]) and "
                    }
                    for _ in 0...4 {
                        condition.remove(at: condition.index(before: condition.endIndex))
                    }
                    
                    let request = self.select(
                        table: table,
                        parameters: "id",
                        condition: condition,
                        network: true
                    )
                    
                    if (request.isEmpty) {
                        id = self.getFreeId(
                            table: table
                        )
                    }
                    else {
                        id = Int(request[0]["id"] as! String)!
                    }
                }
            }
        }
        else {
            if (id_ == -1) {
                id = self.getFreeId(
                    table: table
                )
            }
            else {
                id = id_
            }
        }
        if (local) {
            let params = "\(id), " + parameters.split(separator: "ǃǃ").joined(separator: ", ")
            try! self.db.execute("INSERT INTO \(table) VALUES (\(params))")
        }
        if (!createUser) {
            self.updateUserLastUpdate(userId: userId)
        }
    }
    
    func update(table: String, parameters: String, condition: String, userId: Int, userUpdate: Bool = true) {
        let params = parameters.replacingOccurrences(of: "ǃǃ", with: ", ").replacingOccurrences(of: "ǃ", with: " = ")
        try! self.db.execute("UPDATE \(table) SET \(params) WHERE \(condition)")
        if (connection) {
            _ = query(funcName: "update", parameters: [
                "table": table,
                "params": parameters,
                "condition": condition
            ], async: true)
        }
        if (userUpdate) {
            self.updateUserLastUpdate(userId: userId)
        }
    }
    
    func delete(table: String, condition: String, userId: Int, local: Bool = true, network: Bool = true) {
        if (local) {
            try! self.db.execute("DELETE FROM \(table) WHERE \(condition)")
        }
        if (network && connection) {
            _ = query(funcName: "delete", parameters: [
                "table": table,
                "condition": condition
            ], async: true)
        }
        self.updateUserLastUpdate(userId: userId)
    }
    
    func updateUserLastUpdate (userId: Int) {
        let timestamp: String = String(Int(Double(Date().timeIntervalSince1970)))
        self.update(
            table: "users",
            parameters: "lastUpdateǃ'\(timestamp)'",
            condition: "id = \(userId)",
            userId: 0,
            userUpdate: false
        )
    }
    
    func getColumns(table: String) -> [String] {
        var columns: [String] = []
        for row in try! self.db.prepare("PRAGMA table_info(\(table));") {
            columns.append(row[1] as! String)
        }
        return columns
    }
    
    func createUser(username: String, password: String, lastActivity: String) {
        let id: Int = Int(self.select(
            table: "users",
            parameters: "id",
            condition: "login = '\(username)'",
            network: true
        )[0]["id"] as! String)!
        self.insert(
            table: "users",
            parameters: "'\(username)'ǃǃ'\(password)'ǃǃ'\(lastActivity)'",
            userId: 0,
            createUser: true,
            network: false,
            id_: id
        )
        let settingsId: Int = Int(self.select(
            table: "settings",
            parameters: "id",
            condition: "user = \(id)",
            network: true
        )[0]["id"] as! String)!
        try! self.db.execute("INSERT INTO settings (id, user, language) VALUES (\(settingsId), \(id), 1)")
    }
    
    func dictToListString (dict: [[String: Any?]]) -> [String] {
        var stringMass: [String] = []
        if (!dict.isEmpty) {
            for i in 0...(dict.count - 1) {
                stringMass.append(dict[i]["0"] as! String)
            }
        }
        return stringMass
    }
    
    func getFreeId (table: String) -> Int {
        let res: [[String: Any?]] = self.select(
            table: table,
            parameters: "id"
        )
        var lastId: Int = -1
        if (!res.isEmpty) {
            lastId = Int(exactly: res[res.count - 1]["0"] as! Int64)!
        }
        return lastId + 1
    }
    
    func compareData (network: [[String:Any?]], local: [[String:Any?]]) -> [String: [[String: Any?]]] {
        var result: [String: [[String: Any?]]] = [
            "local": [],
            "network": []
        ]

        let count: Int = [network.count, local.count].min()!
        let newCount: Int = [network.count, local.count].max()! - count
        if (count > 0) {
            for i in 0...count - 1 {
                for j in 0...network[i].count - 1 {
                    if let networkElement = network[i][String(j)] as? Int, let localElement = local[i][String(j)] as? Int {
                        if networkElement != localElement {
                            result["network"]!.append(network[i])
                            result["local"]!.append(local[i])
                            break
                        }
                    }
                    else if let networkElement = network[i][String(j)] as? String, let localElement = local[i][String(j)] as? String {
                        if networkElement != localElement {
                            result["network"]!.append(network[i])
                            result["local"]!.append(local[i])
                            break
                        }
                    }
                    else {
                        if !((network[i][String(j)]! == nil) && (local[i][String(j)]! == nil)) {
                            result["network"]!.append(network[i])
                            result["local"]!.append(local[i])
                            break
                        }
                    }
                }
            }
        }
        if (network.count != local.count) {
            for i in count...count + newCount - 1 {
                if (network.count > local.count) {
                    result["network"]!.append(network[i])
                }
                else {
                    result["local"]!.append(local[i])
                }
            }
        }
        return result
    }
    
    func getTables () -> [String] {
        return self.dictToListString(
            dict: self.select(
                table: "sqlite_master",
                parameters: "name",
                condition: "type = 'table' and name <> 'users' and name <> 'languages'"
            )
        )
    }
    
    func synchronize (userId: Int) {
        if (connection) {
            let timestampLocal: Int = Int(self.select(
                table: "users",
                parameters: "lastUpdate",
                condition: "id = \(userId)"
            )[0]["0"] as! String)!
            
            let request = self.select(
                table: "users",
                parameters: "lastUpdate",
                condition: "id = \(userId)",
                network: true
            )
            
            var timestampNetwork: Int
            if (request.isEmpty) {
                timestampNetwork = timestampLocal
            }
            else {
                timestampNetwork = Int(request[0]["lastUpdate"] as! String)!
            }
            
            if (timestampLocal != timestampNetwork) {
                
                let tables: [String] = self.getTables()
                
                for table in tables {
                    let rawResult = self.select(
                        table: table,
                        parameters: "*",
                        network: true
                    )
                    let columns = self.getColumns(
                        table: table
                    )
                    var result: [[String: Any?]] = []
                    if (!rawResult.isEmpty) {
                        for i in 0...rawResult.count - 1 {
                            result.append([:])
                            for j in 0...columns.count - 1 {
                                result[i][String(j)] = rawResult[i][columns[j]]
                            }
                        }
                    }
                    let compares: [String: [[String: Any?]]] = self.compareData(
                        network: result,
                        local: self.select(
                            table: table,
                            parameters: "*"
                        )
                    )
                    if (timestampLocal > timestampNetwork) {
                        for i in compares["network"]! {
                            self.delete(
                                table: table,
                                condition: "id = \(Int(i["0"]! as! String)!)",
                                userId: userId,
                                local: false
                            )
                        }
                        for i in compares["local"]! {
                            var params: String = ""
                            for j in 1...i.count - 1 {
                                if let param = i[String(j)]! as? Int64 {
                                    params += "\(Int(exactly: param)!), "
                                }
                                else if let param = i[String(j)]! as? String {
                                    params += "'\(param)', "
                                }
                            }
                            params.remove(at: params.index(before: params.endIndex))
                            params.remove(at: params.index(before: params.endIndex))
                            self.insert(
                                table: table,
                                parameters: params,
                                userId: userId,
                                local: false,
                                id_: Int(exactly: i["0"] as! Int64)!
                            )
                            let request = self.select(
                                table: table,
                                parameters: "id",
                                network: true
                            )
                            let newId = Int(request[request.count - 1]["id"] as! String)!
                            self.update(
                                table: table,
                                parameters: "idǃ\(newId)",
                                condition: "id = \(Int(exactly: i["0"]! as! Int64)!)",
                                userId: userId
                            )
                        }
                    }
                    else {
                        for i in compares["local"]! {
                            self.delete(
                                table: table,
                                condition: "id = \(Int(exactly: i["0"]! as! Int64)!)",
                                userId: userId,
                                network: false
                            )
                        }
                        for i in compares["network"]! {
                            var params: String = ""
                            for j in 1...i.count - 1 {
                                if let param = i[String(j)]! as? String {
                                    if let param2 = Int(param) {
                                        params += "\(param2), "
                                    }
                                    else {
                                        params += "'\(param)', "
                                    }
                                }
                                else {
                                    params += "NULL, "
                                }
                            }
                            params.remove(at: params.index(before: params.endIndex))
                            params.remove(at: params.index(before: params.endIndex))
                            self.insert(
                                table: table,
                                parameters: params,
                                userId: userId,
                                network: false,
                                id_: Int(i["0"] as! String)!
                            )
                        }
                    }
                }
            }
        }
    }
}
