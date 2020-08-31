import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=28E713DA-90A7-48A7-BB20-A8157510377A"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var currencySelected = ""
    var finalURL = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row] + apiKey
        print(finalURL)
        currencySelected = symbolArray[row]
        getBitcoinData(url: finalURL)
    }


    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method:.get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Ура! Данные Bitcoin получены")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    print(bitcoinJSON)
                   self.updateBitcoinData(json: bitcoinJSON)
                } else {
                   print("Ошибка: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Проблемы с подключением"
                }
            }
    }


    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        
            let bitcoinData = json["rates"][2]
        if let bitcoinResult = bitcoinData["rate"].double {
            bitcoinPriceLabel.text = "\(currencySelected)\(bitcoinResult)"
        } else {
            bitcoinPriceLabel.text =  "Цена недоступна"
        }
    }
}
