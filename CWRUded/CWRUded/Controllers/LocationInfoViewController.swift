//
//  LocationInfoViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/24/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import MapKit

class LocationInfoViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    public var location: Location?
    private var locationView: LocationInfo!
    
    private var historyContainer: UIView!
    private var chart: LineChart!
    private var legend: UIView!
    
    private var favoriteToggle: UISwitch!
    private var blacklistToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        setTitle()
        setScrollView()
        layoutComponents()
        setScrollHeight()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateLocationViewContent), userInfo: nil, repeats: true)
    }
    
    private func setTitle() {
        setTitle(container: titleView,
                 iconLabel: titleIconLabel,
                 textLabel: titleTextLabel,
                 icon: Icons.info,
                 title: " Info")
    }
    
    private func setScrollView() {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        scrollView.backgroundColor = ColorPallete.clay
    }
    
    @objc private func updateLocationViewContent() {
        for location in CrowdedData.singleton.locations {
            if (self.location!.id == location.id) {
                self.location = location
                break;
            }
        }
        self.locationView!.update(location: self.location!)
        
        chart.clearView()
        chart = historyChart(x: 0, y: 30, width: UIScreen.main.bounds.width - 20)
        historyContainer.addSubview(chart.view)
    }
    
    private func layoutComponents() {
        locationView = LocationInfo(location: location!)
        locationView.transform = CGAffineTransform(translationX: 0, y: 10)
        scrollView.addSubview(locationView!)
        
        chart = historyChart(x: 0, y: 30, width: UIScreen.main.bounds.width - 20)
        legend = historyLegend(x: 10, y: chart.frame.origin.y + chart.frame.height - 5, width: UIScreen.main.bounds.width - 40)
        historyContainer = UIView()
        historyContainer.addSubview(chart.view)
        historyContainer.addSubview(legend)
        
        historyContainer.frame.origin.x = 10
        historyContainer.frame.origin.y = locationView.frame.origin.y + locationView.frame.height + 10
        historyContainer.frame.size.width = UIScreen.main.bounds.width - 20
        historyContainer.frame.size.height = chart.view.frame.height + legend.frame.height + 30
        historyContainer.backgroundColor = ColorPallete.white
        historyContainer.layer.cornerRadius = 5
        historyContainer.clipsToBounds = true
        scrollView.addSubview(historyContainer)
        
        let containerWidth = UIScreen.main.bounds.width - 20
        let directionsButton = self.directionsButton(x: 10, y: 10, width: containerWidth - 20)
        let favoriteToggleRow = self.favoriteContainer(x: 10, y: directionsButton.frame.origin.y + directionsButton.frame.height + 10, width: containerWidth - 20)
        let blacklistToggleRow = self.blacklistContainer(x: 10, y: favoriteToggleRow.frame.origin.y + favoriteToggleRow.frame.height + 10, width: containerWidth - 20)
        let actionsContainer = UIView()
        actionsContainer.addSubview(directionsButton)
        actionsContainer.addSubview(favoriteToggleRow)
        actionsContainer.addSubview(blacklistToggleRow)
        
        actionsContainer.frame.origin.x = 10
        actionsContainer.frame.origin.y = historyContainer.frame.origin.y + historyContainer.frame.height + 10
        actionsContainer.frame.size.width = containerWidth
        actionsContainer.frame.size.height = directionsButton.frame.height + favoriteToggleRow.frame.height + blacklistToggleRow.frame.height + 40
        actionsContainer.backgroundColor = ColorPallete.white
        actionsContainer.layer.cornerRadius = 5
        actionsContainer.clipsToBounds = true
        scrollView.addSubview(actionsContainer)
    }
    
    private func historyChart(x: CGFloat, y: CGFloat, width: CGFloat) -> LineChart {
        var chartSettings = ChartSettings()
        chartSettings.leading = -50
        chartSettings.top = 10
        chartSettings.trailing = 13
        chartSettings.bottom = -50
        chartSettings.labelsToAxisSpacingX = 20
        chartSettings.labelsToAxisSpacingY = 20
        let numDataPoints = location?.spaces.map({ return $0.history.count }).max() ?? 10
        let xAxisConfig = ChartAxisConfig(from: 1, to: Double(numDataPoints), by: 1)
        let yAxisConfig = ChartAxisConfig(from: 0, to: 100, by: 10)
        let xAxisLabelSettings = ChartLabelSettings()
        let yAxisLabelSettings = ChartLabelSettings()
        let guidelinesConfig = GuidelinesConfig()
        
        let chartConfig = ChartConfigXY(chartSettings: chartSettings,
                                        xAxisConfig: xAxisConfig,
                                        yAxisConfig: yAxisConfig,
                                        xAxisLabelSettings: xAxisLabelSettings,
                                        yAxisLabelSettings: yAxisLabelSettings,
                                        guidelinesConfig: guidelinesConfig)
        
        var data = [LineChart.ChartLine]()
        for (si, space) in location!.spaces.enumerated() {
            var points = [(Double, Double)]()
            for (ri, rating) in space.history.sorted(by: { r1, r2 in r1.createdOn < r2.createdOn }).enumerated() {
                points.append((Double(ri + 1), Double(rating.value)))
            }
            let lineColor = ColorPallete.chartLineColors[si % ColorPallete.chartLineColors.count]
            data.append((chartPoints: points, color: lineColor))
        }
        
        let frame = CGRect(x: x, y: y, width: width, height: 200)
        let chart = LineChart(frame: frame, chartConfig: chartConfig, xTitle: "", yTitle: "", lines: data)
        chart.view.backgroundColor = ColorPallete.transparent
        
        return chart
    }
    
    private func historyLegend(x: CGFloat, y: CGFloat, width: CGFloat) -> UIView {
        let frame = CGRect(x: x, y: y, width: width, height: 0)
        let legend = UIView(frame: frame)
        
        var x: CGFloat = 3
        var y: CGFloat = 0
        for (i, space) in location!.spaces.enumerated() {
            let text = space.name
            let color = ColorPallete.chartLineColors[i % ColorPallete.chartLineColors.count]
            let label = LegendLabel(text: text, color: color)
            legend.addSubview(label)
            
            if ((x + label.expectedWidth) > (legend.frame.width - 10)) {
                x = 3
                y += LegendLabel.height + 3
            }
            
            legend.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: legend, attribute: .leading, multiplier: 1, constant: x))
            legend.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: legend, attribute: .top, multiplier: 1, constant: y))
            x += label.expectedWidth + 25
        }
        
        legend.frame.size.height = y + LegendLabel.height
        return legend
    }
    
    private func directionsButton(x: CGFloat, y: CGFloat, width: CGFloat) -> ActionButton {
        return ActionButton(text: "Directions",
                            textFont: Fonts.app(size: 23, weight: .bold),
                            icon: Icons.compass,
                            iconFont: Fonts.fontAwesome(size: 18),
                            backgroundColor: ColorPallete.darkGrey,
                            foregroundColor: ColorPallete.white,
                            frame: CGRect(x: x,
                                          y: y,
                                          width: width,
                                          height: 40),
                            action: { self.directionsButtonTapped() })
    }
    
    private func directionsButtonTapped() {
        guard let location = location else { return }
        let addressDict = [CNPostalAddressStreetKey: location.name]
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    private func favoriteContainer(x: CGFloat, y: CGFloat, width: CGFloat) -> UIView {
        let favoriteToggleContainer = UIView(frame: CGRect(x: x,
                                                           y: y,
                                                           width: width,
                                                           height: 40))
        
        let iconLabel = UILabel()
        iconLabel.text = Icons.heart
        iconLabel.font = Fonts.fontAwesome(size: 18)
        iconLabel.textColor = ColorPallete.red
        iconLabel.backgroundColor = ColorPallete.transparent
        iconLabel.textAlignment = .center
        iconLabel.baselineAdjustment = .alignCenters
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = "Favorite"
        textLabel.font = Fonts.app(size: 23, weight: .bold)
        textLabel.textColor = ColorPallete.black
        textLabel.backgroundColor = ColorPallete.transparent
        textLabel.textAlignment = .left
        textLabel.baselineAdjustment = .alignCenters
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = AppSettings.singleton.favoriteLocations().contains(where: { simpleLocation in simpleLocation.id == self.location!.id })
        toggleSwitch.addTarget(self, action: #selector(favoriteToggled), for: .valueChanged)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteToggleContainer.addSubview(iconLabel)
        favoriteToggleContainer.addSubview(textLabel)
        favoriteToggleContainer.addSubview(toggleSwitch)
        
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .leading, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .leading, multiplier: 1, constant: 0))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        textLabel.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: iconLabel, attribute: .trailing, multiplier: 1, constant: 0))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .trailing, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .trailing, multiplier: 1, constant: -10))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .leading, relatedBy: .equal, toItem: textLabel, attribute: .trailing, multiplier: 1, constant: 10))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .centerY, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        favoriteToggle = toggleSwitch
        return favoriteToggleContainer
    }
    
    @objc private func favoriteToggled() {
        if (favoriteToggle.isOn) {
            AppSettings.singleton.addFavoriteLocation(location: location!)
            //does not trigger the other toggles event so we hanbdle it below
            blacklistToggle.setOn(false, animated: true)
            blacklistToggled()
        }
        else {
            AppSettings.singleton.removeFavoriteLocation(location: location!)
        }
    }
    
    private func blacklistContainer(x: CGFloat, y: CGFloat, width: CGFloat) -> UIView {
        let blacklistToggleContainer = UIView(frame: CGRect(x: x,
                                                            y: y,
                                                            width: width,
                                                            height: 40))
        
        let iconLabel = UILabel()
        iconLabel.text = Icons.ban
        iconLabel.font = Fonts.fontAwesome(size: 18)
        iconLabel.textColor = ColorPallete.red
        iconLabel.backgroundColor = ColorPallete.transparent
        iconLabel.textAlignment = .center
        iconLabel.baselineAdjustment = .alignCenters
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = "Hide"
        textLabel.font = Fonts.app(size: 23, weight: .bold)
        textLabel.textColor = ColorPallete.black
        textLabel.backgroundColor = ColorPallete.transparent
        textLabel.textAlignment = .left
        textLabel.baselineAdjustment = .alignCenters
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = AppSettings.singleton.blacklistedLocations().contains(where: { simpleLocation in simpleLocation.id == self.location!.id })
        toggleSwitch.addTarget(self, action: #selector(blacklistToggled), for: .valueChanged)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        blacklistToggleContainer.addSubview(iconLabel)
        blacklistToggleContainer.addSubview(textLabel)
        blacklistToggleContainer.addSubview(toggleSwitch)
        
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .leading, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .leading, multiplier: 1, constant: 0))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        textLabel.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: iconLabel, attribute: .trailing, multiplier: 1, constant: 0))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .trailing, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .trailing, multiplier: 1, constant: -10))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .leading, relatedBy: .equal, toItem: textLabel, attribute: .trailing, multiplier: 1, constant: 10))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .centerY, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        blacklistToggle = toggleSwitch
        return blacklistToggleContainer
    }
    
    @objc private func blacklistToggled() {
        if (blacklistToggle.isOn) {
            AppSettings.singleton.addBlacklistedLocation(location: location!)
            //does not trigger the other toggles event so we hanbdle it below
            favoriteToggle.setOn(false, animated: true)
            favoriteToggled()
        }
        else {
            AppSettings.singleton.removeBlacklistedLocation(location: location!)
        }
    }
    
    private func setScrollHeight() {
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        let bottomPadding: CGFloat = 10
        contentRect.size.height += bottomPadding
        scrollView.contentSize = contentRect.size
    }
}
