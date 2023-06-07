//
//  WeatherManager.swift
//  Clima
//
//  Created by HAMDI TLILI on 27/05/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c2122879715816905d687ef35e15f056&units=metric"
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString) 
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        let string = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        //print(string)
        if let url = URL(string: string) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give a session a task
            let task = session.dataTask(with: url) { data, respense, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self , from: weatherData)
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
       
    }
    
}

