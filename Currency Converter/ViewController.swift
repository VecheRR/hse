//
//  ViewController.swift
//  Currency Converter
//
//  Created by Владислав Вечерковский on 02.06.2020.
//  Copyright © 2020 Владислав Вечерковский. All rights reserved.
//

import UIKit
import Foundation

struct all : Decodable {
    var rates: [String:Double]
    var base: String
    var date: String
}

var courses: Dictionary<String, Double> = Dictionary()

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fromPicker: UIPickerView!
    
    override func viewDidLoad() {
        fromPicker.delegate = self
        fromPicker.dataSource = self
        

        let urlString = "https://api.exchangeratesapi.io/latest"
        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else { return }

            let result = try? JSONDecoder().decode(all.self, from: data)
            let ans = result!.rates
            
            for (key, value) in ans {
                courses[key] = value
            }
            
            courses["UER"] = 1
            courses["BTC"] = 0.00012 // 03.06.2020 17:12
            
            // print(courses.keys.sorted())
            

        }.resume()
        
        super.viewDidLoad()
    }
    
    var pickerData = ["AUD", "BGN", "BTC", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "ISK", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "USD", "ZAR"]
    
    let moneySymbol = ["AUD":"$", "BGN":"leva", "BTC":"₿", "BRL":"R$", "CAD":"C$", "CHF":"CHF", "CNY":"元", "CZK":"Kč", "DKK":"kr", "EUR":"€", "GBP":"£", "HKD":"HK$", "HRK":"kn", "HUF":"Ft", "IDR":"Rp", "ILS":"₪", "INR":"₹", "ISK":"kr", "JPY":"¥", "KRW":"₩", "MXN":"Mex$", "MYR":"RM", "NOK":"kr", "NZD":"NZ$", "PHP":"₱", "PLN":"zł", "RON":"L", "RUB":"₽", "SEK":"kr", "SGD":"S$", "THB":"฿", "TRY":"₺", "USD":"US$", "ZAR":"R"]
    
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
        
        let type1 = pickerData[fromPicker.selectedRow(inComponent: 0)]
        let type2 = pickerData[fromPicker.selectedRow(inComponent: 1)]
        
        let convertedMoney : Double
        
        if type1 == type2 {
            convertedMoney = Double(money)!
        } else if type1 == "EUR" {
            convertedMoney = round((Double(money)! * courses[type2]!) * 100000.0) / 100000.0
            print(courses[type2]!)
        } else if type2 == "EUR" {
            convertedMoney = round((Double(money)! / courses[type1]!) * 100000.0) / 100000.0
            //print(courses[type2]!)
        } else {
            let convertedToEurosMoney = Double(money)! / courses[type1]!
            
            convertedMoney = round((convertedToEurosMoney * courses[type2]!) * 100000.0) / 100000.0
        }
        label.text = "\(convertedMoney) \(moneySymbol[type2] ?? "")"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//This project was created specifically for the seventh school for the development of mobile applications from HSE.
