//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Mahmud on 25/6/22.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    var apiKey = "78cb4a1471ecdb7d875eb729c90a4cdf"
    
    func getCurrentWeather(latitude: CLLocationDegrees, logitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(logitude)&appid=\(apiKey)&units=metric") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        print(response)
        
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
}



// MARK: - ResponseBody
class ResponseBody: Decodable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String

    init(coord: Coord, weather: [Weather],main: Main, visibility: Int, wind: Wind, name: String) {
        self.coord = coord
        self.weather = weather
        self.main = main
        self.wind = wind
        self.name = name
    }
}

// MARK: - Coord
class Coord: Decodable {
    let lon, lat: Double

    init(lon: Double, lat: Double) {
        self.lon = lon
        self.lat = lat
    }
}

// MARK: - Main
class Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }

    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, pressure: Int, humidity: Int) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
    }
}

// MARK: - Weather
class Weather: Decodable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }

    init(id: Int, main: String, weatherDescription: String, icon: String) {
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}

// MARK: - Wind
class Wind: Decodable {
    let speed: Double
    let deg: Int

    init(speed: Double, deg: Int) {
        self.speed = speed
        self.deg = deg
    }
}
