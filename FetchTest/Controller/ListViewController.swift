//
//  DataViewController.swift
//  FetchTest
//
//  Created by Rita Carlson on 9/29/23.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var dataText: UITextView!
    
    var dataManager = ListManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        dataManager.fetchData(at: "https://fetch-hiring.s3.amazonaws.com/hiring.json")
    }
}

//MARK: - DataManagerDelegate

extension ListViewController: DataManagerDelegate {
    
    func didUpdateList(_ listManager: ListManager, data: [ListData]) {
        var html = """
            <p><strong><span style="font-size: 25px; color: #FF165D">Items Grouped by ListId:</span></strong></p>
            <p><strong><u><span style="font-size: 20px; color: #FF9A00">ListId 1</span></u></strong></p>
            """
        
        var currListId = 1
        for item in data {
            // writes new section for a new group of listIds
            if (item.listId != currListId) {
                currListId += 1
                html += """
                    <p><strong><u><span style="font-size: 20px; color: #FF9A00">ListId \(currListId)</span></u></strong></p>
                    """
            }
            
            // adds each item to list
            html += """
                <ul><strong><span style="font-size: 18px; color: #3EC1D3">id: \(item.id), listId: \(item.listId), name: \(item.name)</span></strong></ul>
                """
        }
    
        let data = Data(html.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            // update list
            DispatchQueue.main.async {
                self.dataText.attributedText = attributedString
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
