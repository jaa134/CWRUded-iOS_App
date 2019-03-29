//
//  FavoriteLocationsController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/29/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class FavoriteLocationsController : UIViewController {
    
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
                 icon: Icons.heart,
                 title: " Favorites")
    }
    
    private func setTableView() {
        tableView.backgroundColor = ColorPallete.clay
        tableView.allowsMultipleSelection = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func updateTableData() {
        tableData = [Item]()
        let favorites = AppSettings.singleton.favoriteLocations()
        for location in CrowdedData.singleton.locations {
            tableData.append(Item(name: location.name,
                                  icon: Icons.heart,
                                  iconColor: ColorPallete.red,
                                  isSelected: favorites.contains(where: { $0.id == location.id }),
                                  onSelect: { AppSettings.singleton.addFavoriteLocation(location: location) },
                                  onDeselect: { AppSettings.singleton.removeFavoriteLocation(location: location) }))
        }
    }
}

extension FavoriteLocationsController : UITableViewDataSource {
    
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

extension FavoriteLocationsController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectionCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! SelectionCell
        cell.toggle()
    }
}

