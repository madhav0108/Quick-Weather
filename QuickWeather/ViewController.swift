//
//  ViewController.swift
//  QuickWeather
//
//  Created by madhav sharma on 7/12/20.
//  Copyright © 2020 madhav sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func getWeather(_ sender: Any) {
        
        let location = cityTextField.text!.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "-")
        
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + location + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            var message = ""
            
            if let error = error {
                print(error)
            } else {
                if let unwrappedData = data {
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "\"b-forecast__table-description-content\"><span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                
                            if newContentArray.count > 1 {
                                    
                                message = newContentArray[0]
                                    
                                print(message)
                                    
                            }
                        }
                    }
                }
            }
            if message == "" {
                message = "Oops! Having troubles in displaying the weather. Please try again!"
            }
            
            DispatchQueue.main.sync {
                self.resultLabel.text = message
            }
        }
        task.resume()
        } else {
            resultLabel.text = "Oops! Location not found! Please try again!"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = 5.0
        submitBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        submitBtn.layer.borderWidth = 1.0
        
        // Do any additional setup after loading the view.
    }


}

