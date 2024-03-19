import Foundation

extension ViewController {
    
    func serverGet(completion: @escaping (String?) -> Void) {
        let url = URL(string: "http://o91816ut.beget.tech/ToDo/dataToDo" + serverSaveName +  ".txt")!
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil)
            } else if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    completion(dataString)
                } else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func serverPost(data: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "http://o91816ut.beget.tech/ToDo/addToDo" + serverSaveName + ".php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36", forHTTPHeaderField: "User-Agent")

        let parameters = ["s": data]
        request.httpBody = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil)
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    completion(responseString)
                } else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func wait (flag: () -> Bool) {
        while (!flag()) {
            usleep(250000)
        }
    }
}
