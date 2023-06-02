//
//  WeatherManager.swift
//  Clima
//
//  Created by HAMDI TLILI on 27/05/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c2122879715816905d687ef35e15f056&units=metric"
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        let string = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        print(string)
        if let url = URL(string: string) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give a session a task
            let task = session.dataTask(with: url) { data, respense, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self , from: weatherData)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
            
        } catch {
            print(error)
        }
    }
}
