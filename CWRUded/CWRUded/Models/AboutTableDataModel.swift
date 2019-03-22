//
//  AboutTableModel.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/21/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation

struct AboutTableItem {
    public let order: Int
    public let title: String
    public let content: String
    
    fileprivate init(order: Int, title: String, content: String) {
        self.order = order
        self.title = title
        self.content = content
    }
}

class AboutTableData {
    public static let singleton: AboutTableData = AboutTableData()
    
    public private(set) var items: [AboutTableItem]
    
    private init() {
        items = [AboutTableItem]()
        createItems()
    }
    
    private func createItems() {
        var order: Int
        var title: String
        var content: String
        
        order = 0
        title = "What does CWRUded do?"
        content = "CWRUded reports the real-time \"busyness\" for locations around campus. We are currently installed anywhere you can find CaseWireless."
        items.append(AboutTableItem(order: order, title: title, content: content))
        
        order = 1
        title = "How can I find \"busyness\" levels?"
        content = "Currently, our data is only available on this iOS app. We are working on releasing other ways to broadcast our data."
        items.append(AboutTableItem(order: order, title: title, content: content))
        
        order = 2
        title = "How does CWRUded work?"
        content = "CWRUded polls wireless access points throughout campus to check how many devices are connected to the network. The count is grouped by buildings and then normalized to reach a \"busyness\" measurement. Currently, our data is updated every five minutes."
        items.append(AboutTableItem(order: order, title: title, content: content))
        
        order = 3
        title = "Can CWRUded count my phone if I don't have the CWRUded app?"
        content = "Yes, our polling process will detect any device connected to the campus network."
        items.append(AboutTableItem(order: order, title: title, content: content))
        
        order = 4
        title = "Does CWRUded collect any personal information from the polling proccess?"
        content = "No. CWRUded is only concerned with how many devices are connected to the network."
        items.append(AboutTableItem(order: order, title: title, content: content))
        
        order = 5
        title = "Does CWRUded track where I go?"
        content = "No, CWRUded does not track any individual's movements. Our focus is on gathering estimates on the total number of people, rather than information on an individual."
        items.append(AboutTableItem(order: order, title: title, content: content))
        
        order = 6
        title = "How can I help increase CWRUded's accuracy?"
        content = "Easy! Simply keep your Wi-Fi on and carry on as you normally would."
        items.append(AboutTableItem(order: order, title: title, content: content))
        
        order = 7
        title = "Any other questions or comments?"
        content = "Please contact the U[Tech] help desk to report any questions, comments, or application issues."
        items.append(AboutTableItem(order: order, title: title, content: content))
    }
}
