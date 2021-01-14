//
//  CoinManager.swift
//  ByteCoin
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinRate(_ weatherManager: CoinManager, _ coinData: CoinData)
    func didFaildWithError(_ error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "{API_KEY}"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        perfomeRequest(urlString)
    }
    
    func perfomeRequest(_ urlString: String) {
        // 1. Create URL
        if let url = URL(string: urlString) {
            
            // 2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFaildWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let coinRate = parseJSON(safeData) {
                       delegate?.didUpdateCoinRate(self, coinRate)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {

            let decodedData = try decoder.decode(CoinData.self, from: weatherData)

            let rate = decodedData.rate
            let priceIn = decodedData.asset_id_quote

            let coinRate = CoinData(rate: rate, asset_id_quote: priceIn)
            return coinRate

        } catch let error {
            delegate?.didFaildWithError(error)
            return nil
        }
    }
   
}
