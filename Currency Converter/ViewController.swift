//
//  ViewController.swift
//  Currency Converter
//
//  Created by Владислав Вечерковский on 02.06.2020.
//  Copyright © 2020 Владислав Вечерковский. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerData = ["Rubles", "Dollars", "Euros", "Pounds", "Hryvni"]
    let moneySign = ["₽", "$", "€", "£", "₴"]
    let course = [1.0, 74.0, 80.0, 86.0, 3.0]
    
    @IBOutlet weak var fromPicker: UIPickerView!
    
    override func viewDidLoad() {
        fromPicker.delegate = self
        fromPicker.dataSource = self
        
        super.viewDidLoad()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var moneyTF: UITextField!
    @IBAction func convertTapped(_ sender: UIButton) {
        guard let money = moneyTF.text else { return }
        
        let type1 = fromPicker.selectedRow(inComponent: 0)
        let type2 = fromPicker.selectedRow(inComponent: 1)
        
        // guard type1 != type2 else { return }
        
        let convertedMoney : Double
        
        if type1 == type2 {
            convertedMoney = Double(money)!
        } else if type1 == 0 {
            convertedMoney = round((Double(money)! / course[type2]) * 1000) / 1000
        } else {
            // First, convert to rubles, and then from rubles to another currency
            
            let convertedToRublesMoney = Double(money)! * course[type1]
            
            convertedMoney = round((convertedToRublesMoney / course[type2]) * 1000) / 1000
        }
        label.text = "\(convertedMoney)\(moneySign[type2])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//This project was created specifically for the seventh school for the development of mobile applications from HSE.
