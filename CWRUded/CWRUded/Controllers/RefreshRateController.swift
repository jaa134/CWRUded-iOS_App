//
//  RefreshRateController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/29/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class RefreshRateController : UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var tableData: [Item]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView() {
        setTitle()
        updateTableData()
        setTableView()
    }
    
    private func setTitle() {
        setTitle(container: titleView,
                 iconLabel: titleIconLabel,
                 textLabel: titleTextLabel,
                 icon: Icons.refresh,
                 title: " Update")
    }
    
    private func setTableView() {
        tableView.backgroundColor = ColorPallete.clay
        tableView.allowsMultipleSelection = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func updateTableData() {
        tableData = [Item]()
        let rate = AppSettings.singleton.refreshRate()
        tableData.append(Item(name: "5 seconds",
                              icon: Icons.check,
                              iconColor: ColorPallete.green,
                              isSelected: rate == 5,
                              onSelect: { AppSettings. },
                              onDeselect: {  }))
        tableData.append(Item(name: "10 seconds",
                              icon: Icons.check,
                              iconColor: ColorPallete.green,
                              isSelected: rate == 10,
                              onSelect: {  },
                              onDeselect: {  }))
        tableData.append(Item(name: "30 seconds",
                              icon: Icons.check,
                              iconColor: ColorPallete.green,
                              isSelected: rate == 20,
                              onSelect: {  },
                              onDeselect: {  }))
        tableData.append(Item(name: "60 seconds",
                              icon: Icons.check,
                              iconColor: ColorPallete.green,
                              isSelected: rate == 60,
                              onSelect: {  },
                              onDeselect: {  }))
    }
}

extension RefreshRateController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        let location = self.tableData![indexPath.item]
        cell.setupView(item: location)
        return cell
    }
}

extension RefreshRateController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectionCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! SelectionCell
        cell.toggle()
    }
}
