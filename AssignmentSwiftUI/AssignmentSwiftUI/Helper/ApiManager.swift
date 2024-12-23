//
//  ApiManager.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import Foundation

class NetworkManager {
    
    private var activeTasks: [String: URLSessionDataTask] = [:]
    private let taskQueue = DispatchQueue(label: "com.CatApp.networkQueue")
    
    // Fetches data from a given URL and calls the completion handler when done.
    // - Parameters:
    //   - url: The URL to fetch data from.
    //   - completion: A closure that is called with the fetched data or nil if an error occurs.
    func fetchData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        taskQueue.sync {
            if let activeTask = activeTasks[url.absoluteString] {
                activeTask.cancel()
                print("Cancelled previous request for URL: \(url.absoluteString)")
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                defer {
                    self.clearActiveTask(for: url)
                }
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                // Handle invalid response codes (non-2xx)
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    let statusCodeError = NSError(domain: "NetworkError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Received invalid HTTP response with status code \(httpResponse.statusCode)"])
                    print("HTTP error: \(statusCodeError.localizedDescription)")
                    completion(nil, statusCodeError)
                    return
                }
                
                // Handle empty response body
                guard let data = data, !data.isEmpty else {
                    let emptyDataError = NSError(domain: "NetworkError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Received empty response body"])
                    print("Error: \(emptyDataError.localizedDescription)")
                    completion(nil, emptyDataError)
                    return
                }
                
                // Success - return the data
                completion(data, nil)
            }
            activeTasks[url.absoluteString] = task
            task.resume()
        }
    }
    
    //To clear the active task (useful if the task completes or you want to manually manage)
    func clearActiveTask(for url: URL) {
        taskQueue.sync {
            activeTasks[url.absoluteString] = nil
        }
    }
}

class DataDecoder {
    
    // Decodes a given Data object to a specified type that conforms to the Codable protocol.
    // - Parameters:
    //   - data: The data to be decoded.
    //   - type: The type of the object to decode to (inferred by T).
    // - Returns: A decoded object of type T, or nil if decoding fails.
    func decode<T: Codable>(_ data: Data, to type: T.Type) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}

/// A struct to hold all the constants related to API endpoints.
struct APIConstants {
    static let catImagesURL = "https://api.thecatapi.com/v1/images/search?limit=5"
    static func catBreedsURL(page: Int, limit: Int = 5) -> String {
        return "https://api.thecatapi.com/v1/breeds?page=\(page)&limit=\(limit)"
    }
}
