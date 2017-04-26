//
//  StarshipsViewController.swift
//  StarWars
//
//  Created by James Cobb on 3/27/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import UIKit

class StarshipsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var starshipsNameLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var starshipsPickerView: UIPickerView!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    let swapiClient = SWAPIClient()
    var starshipsCollection: [Starship]?
    var selectedStarship: Starship? {
        didSet {
            self.updateLabelsFor(selectedStarship!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starshipsPickerView.delegate = self
        starshipsPickerView.dataSource = self
        fetchingStarship()
        
        // Do any additional setup after loading the view.
    }
    
    func updateLabelsFor(_ starship: Starship) {
        self.starshipsNameLabel.text = selectedStarship?.name
        self.makeLabel.text = selectedStarship?.make
        self.costLabel.text = selectedStarship?.cost
        self.lengthLabel.text = selectedStarship?.length
        self.classLabel.text = selectedStarship?.starshipClass
        self.crewLabel.text = selectedStarship?.crew
    }
    
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchingStarship() {
        swapiClient.fetchStarships { result in
            
            switch result {
            case .success(let starships):
                self.starshipsCollection = starships
                self.starshipsPickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedStarship = starships[self.starshipsPickerView.selectedRow(inComponent: 0)]
                self.smallestLabel.text = self.smallestVsLargest(starships).smallest.name
                self.largestLabel.text = self.smallestVsLargest(starships).largest.name
                self.starshipsPickerView.reloadAllComponents()
            case .failure(let error as NSError):
                self.showAlert("Unable to retreive Starships", message: error.localizedDescription)
            default: break
            }
        }
    }
    
    
    
    // MARK: Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let starships = starshipsCollection {
            return starships.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let starships = starshipsCollection {
            let starship = starships[row]
            return starship.name
        } else {
            return "Awaiting starship arrival"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let starships = starshipsCollection {
            let starship = starships[row]
            selectedStarship = starship
        }
    }
    
    
    // Conversions
    @IBAction func englishToMetricConversion(_ sender: Any) {
        if let length = selectedStarship?.length {
            lengthLabel.text = "\(length) cm"
        }
        
    }
    
    @IBAction func metricToEnglishConversion(_ sender: Any) {
        if let length = selectedStarship?.length {
            let englishLength = Double(length)! * 0.328084
            lengthLabel.text = "\(englishLength) ft"
        }
    }
    
    @IBAction func creditsToUSDConversion(_ sender: Any) {
        if let cost = selectedStarship?.cost {
            let creditsToDollars = Double(cost)! * 0.66666
            costLabel.text = "\(creditsToDollars) USD"
        }        
    }
    
    @IBAction func usdToCreditsConversion(_ sender: Any) {
            costLabel.text = selectedStarship?.cost
    }
    
    
    // Smallest vs Largest
    
    func smallestVsLargest(_ starships: [Starship]) -> (smallest: Starship, largest: Starship) {
        var starshipsSmallestToLargest = [Starship]()
        for starship in starships {
            if starship.length?.hashValue != nil {
                starshipsSmallestToLargest.append(starship)
                
            }
        }
        let sortedStarships = starshipsSmallestToLargest.sorted { ($0.length?.hashValue)! < ($1.length?.hashValue)! }
        return (sortedStarships.first!, sortedStarships.last!)
    }
    
    
    
    
    
    
    
    
}

    

