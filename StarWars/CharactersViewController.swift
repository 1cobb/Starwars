//
//  CharactersViewController.swift
//  StarWars
//
//  Created by James Cobb on 3/27/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyesLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var charactersPickerView: UIPickerView!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    

    
    let swapiClient = SWAPIClient()
    var charactersCollection: [Character]?
    var selectedCharacter: Character? {
        didSet {
            self.updateLabelsFor(selectedCharacter!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingCharacter()
        charactersPickerView.delegate = self
        charactersPickerView.dataSource = self
    }
    
    func updateLabelsFor(_ character: Character) {
        
        self.nameLabel.text = selectedCharacter?.name
        self.bornLabel.text = selectedCharacter?.born
        self.heightLabel.text = selectedCharacter?.height
        self.eyesLabel.text = selectedCharacter?.eyes
        self.hairLabel.text = selectedCharacter?.hair
        fetchCharacterHome(character)
    }

    
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    func fetchingCharacter() {
        swapiClient.fetchCharacters { result in
            
            switch result {
            case .success(let characters):
                self.charactersCollection = characters
                self.charactersPickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedCharacter = characters[self.charactersPickerView.selectedRow(inComponent: 0)]
                self.charactersPickerView.reloadAllComponents()
                self.smallestLabel.text = self.smallestVsLargest(characters).smallest.name
                self.largestLabel.text = self.smallestVsLargest(characters).largest.name
            case .failure(let error as NSError):
                self.showAlert("Unable to retreive Characters", message: error.localizedDescription)
            default: break
            }
        }
    }
    
    func fetchCharacterHome(_ character: Character) {
        self.swapiClient.fetchCharacterHome(character) { result in
            
            switch result {
            case .success(let home):
                self.homeLabel.text = home.name
            case .failure(let error):
                print(error)
            }
        }
    }

    

    // MARK: Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let characters = charactersCollection {
            return characters.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let characters = charactersCollection {
            let character = characters[row]
            return character.name
        } else {
            return "Awaiting character arrival"
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if let characters = charactersCollection {
                let character = characters[row]
                selectedCharacter = character
        }
    }
    
    // Conversions
    
    @IBAction func englishToMetricConversion(_ sender: Any) {
        if let height = selectedCharacter?.height {
            heightLabel.text = "\(height) cm"
        }
    }
    
    @IBAction func metricToEnglishConversion(_ sender: Any) {
        if let height = selectedCharacter?.height {
            let englishHeight = Double(height)! * 0.328084
            heightLabel.text = "\(englishHeight) ft"
        }
    }
    
    // Smallest vs Largest
    
    func smallestVsLargest(_ characters: [Character]) -> (smallest: Character, largest: Character) {
        var charactersSmallestToLargest = [Character]()
        for character in characters {
            if character.height?.hashValue != nil {
                charactersSmallestToLargest.append(character)
                
            }
        }
        let sortedCharacters = charactersSmallestToLargest.sorted { ($0.height?.hashValue)! < ($1.height?.hashValue)! }
        return (sortedCharacters.first!, sortedCharacters.last!)
    }
        







}






































