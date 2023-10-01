//
//  DataManager.swift
//  FetchTest
//
//  Created by Rita Carlson on 9/29/23.
//

import Foundation

protocol DataManagerDelegate {
    func didUpdateList(_ listManager: ListManager, data: [ListData])
    func didFailWithError(error: Error)
}

struct ListManager {
    
    var delegate: DataManagerDelegate?
    
    func fetchData(at urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let listData = parseJSON(safeData) {
                        self.delegate?.didUpdateList(self, data: listData) // call to update list
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ listData: Data) -> [ListData]? {
        let decoder = JSONDecoder()
        
        do {
            var decodedData = try decoder.decode([ListData].self, from: listData)
            
            // remove all items that have a blank name
            decodedData = decodedData.filter { item in
                if item.name.isEmpty {
                    return false
                }
                return true
            }
            
            // Sort JSON by listId, if listIds are equal, sort by number in item name
            let sortedData = decodedData.sorted {
                if ($0.listId == $1.listId) {
                    let name1 = Int($0.name.components(separatedBy: " ")[1]) ?? 0
                    let name2 = Int($1.name.components(separatedBy: " ")[1]) ?? 0
                    
                    if (name1 < name2) {
                        return true
                    } else {
                        return false
                    }
                }
                return $0.listId < $1.listId
            }
            
            return sortedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
