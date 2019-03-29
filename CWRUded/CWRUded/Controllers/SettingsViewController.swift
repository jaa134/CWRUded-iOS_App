//
//  SettingsViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var tableData: [Setting]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
                 icon: Icons.cog,
                 title: " Settings")
    }
    
    private func setTableView() {
        tableView.backgroundColor = ColorPallete.clay
        tableView.allowsMultipleSelection = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func updateTableData() {
        tableData = [Setting]()
        tableData.append(Setting(icon: Icons.refresh,
                                 iconColor: ColorPallete.lightBlue,
                                 name: "Refresh Rate",
                                 onClick: {  }))
        tableData.append(Setting(icon: Icons.heart,
                                 iconColor: ColorPallete.red,
                                 name: "Favorite Locations",
                                 onClick: { self.performSegue(withIdentifier: "toFavoriteLocations", sender: nil) }))
        tableData.append(Setting(icon: Icons.ban,
                                 iconColor: ColorPallete.red,
                                 name: "Hidden Locations",
                                 onClick: { self.performSegue(withIdentifier: "toBlacklistedLocations", sender: nil) }))
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let setting = self.tableData![indexPath.item]
        cell.setupView(setting: setting)
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setting = self.tableData![indexPath.item]
        setting.onClick()
    }
}
