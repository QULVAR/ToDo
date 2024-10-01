import Foundation

extension DataBase {

    func query(funcName: String, parameters: [String: String]) -> Any {
        var result: Any = ""
        var urlComponents = URLComponents(string: "http://o91816ut.beget.tech/SQL/\(funcName).php")!
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                result = responseString
            } else {
                result = ""
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: .now() + 3)
        return result
    }
    
    func jsonDecode (data: Any) -> [String: Any] {
        if let jsonString = data as? String,
           let jsonData = jsonString.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    print(jsonObject)
                    return jsonObject
                } else {}} catch {}} else {}
        return [:]
    }
}
