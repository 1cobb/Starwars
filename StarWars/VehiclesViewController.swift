//
//  VehiclesViewController.swift
//  StarWars
//
//  Created by James Cobb on 3/27/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import UIKit

class VehiclesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var vehiclesNameLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var vehiclesPickerView: UIPickerView!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    let swapiClient = SWAPIClient()
    var vehiclesCollection: [Vehicle]?
    var selectedVehicle: Vehicle? {
        didSet {
            self.updateLabelsFor(selectedVehicle!)
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vehiclesPickerView.delegate = self
        vehiclesPickerView.dataSource = self
        fetchingVehicle()

        // Do any additional setup after loading the view.
    }
    
    func updateLabelsFor(_ vehicle: Vehicle) {
        self.vehiclesNameLabel.text = selectedVehicle?.name
        self.makeLabel.text = selectedVehicle?.make
        self.costLabel.text = selectedVehicle?.cost
        self.lengthLabel.text = selectedVehicle?.length
        self.classLabel.text = selectedVehicle?.vehicleClass
        self.crewLabel.text = selectedVehicle?.crew
    }
    
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchingVehicle() {
        swapiClient.fetchVehicles { result in
            
            switch result {
            case .success(let vehicles):
                self.vehiclesCollection = vehicles
                self.vehiclesPickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedVehicle = vehicles[self.vehiclesPickerView.selectedRow(inComponent: 0)]
                self.smallestLabel.text = self.smallestVsLargest(vehicles).smallest.name
                self.largestLabel.text = self.smallestVsLargest(vehicles).largest.name
                self.vehiclesPickerView.reloadAllComponents()
            case .failure(let error as NSError):
                self.showAlert("Unable to retreive Vehicles", message: error.localizedDescription)
            default: break
            }
        }
    }
    


    // MARK: Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let vehicles = vehiclesCollection {
            return vehicles.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let vehicles = vehiclesCollection {
            let vehicle = vehicles[row]
            return vehicle.name
        } else {
            return "Awaiting vehicle arrival"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let vehicles = vehiclesCollection {
            let vehicle = vehicles[row]
            selectedVehicle = vehicle
        }
    }


    // Conversions
    @IBAction func englishToMetricConversion(_ sender: Any) {
        if let length = selectedVehicle?.length {
            lengthLabel.text = "\(length) cm"
        }

    }
    
    @IBAction func metricToEnglishConversion(_ sender: Any) {
        if let length = selectedVehicle?.length {
            let englishLength = Double(length)! * 0.328084
            lengthLabel.text = "\(englishLength) ft"
        }
    }
    
    @IBAction func creditsToUSDConversion(_ sender: Any) {
        if let cost = selectedVehicle?.cost {
            let creditsToDollars = Double(cost)! * 0.66666
            costLabel.text = "\(creditsToDollars) USD"
        }
        
    }
    
    @IBAction func usdToCreditsConversion(_ sender: Any) {
            costLabel.text = selectedVehicle?.cost
    }
    
    
    // Smallest vs Largest
    
    func smallestVsLargest(_ vehicles: [Vehicle]) -> (smallest: Vehicle, largest: Vehicle) {
        var vehiclesSmallestToLargest = [Vehicle]()
        for vehicle in vehicles {
            if vehicle.length?.hashValue != nil {
                vehiclesSmallestToLargest.append(vehicle)
                
            }
        }
        let sortedVehicles = vehiclesSmallestToLargest.sorted { ($0.length?.hashValue)! < ($1.length?.hashValue)! }
        return (sortedVehicles.first!, sortedVehicles.last!)
    }

    
    
    




}





























