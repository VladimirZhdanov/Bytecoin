//
//  ViewController.swift
//  ByteCoin
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
        self.coinManager.getCoinPrice(for: coinManager.currencyArray[0])
    }
    
    
}

//MARK:- CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoinRate(_ weatherManager: CoinManager, _ coinData: CoinData) {
        DispatchQueue.main.async {
            self.bitCoinLabel.text = String(coinData.rate.format(toRound: 2))
            self.currencyLabel.text = coinData.asset_id_quote
        }
    }
    
    func didFaildWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}

//MARK:- Double

extension Double {
    func format(toRound round: Int) -> Double {
        return Double(String(format: "%.\(round)f", self)) ?? 0.0
    }
}

//MARK:- UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.capacity
    }
    
    
}

//MARK:- UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCurrensy = self.coinManager.currencyArray[row]
        self.coinManager.getCoinPrice(for: selectedCurrensy)
    }
}

