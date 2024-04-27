//
//  Viewmodel.swift
//  async__mainactorApp.swift
//
//  Created by Devasurya on 27/04/24.
//

import Foundation

class Viewmodel: ObservableObject {
    
    @Published var dataSource: ModelStructure = ModelStructure(location: "", temperature:0.0)
    
    func extractData(_ cityName: String)async throws -> ModelStructure {
        do {
            dataSource =  try await fetchWeatherData(cityName)
            return dataSource
        }
        catch {
            throw DataError.unknownError(errorValue: error)
        }
    }
    
    func fetchWeatherData(_ cityId: String) async throws -> ModelStructure {
        guard let urlValue = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityId)&appid=8984d739fa91d7031fff0e84a3d2c520&units=imperial") else {
            throw DataError.invalidURL
        }
        let requestValue = URLRequest(url: urlValue)
        do {
            let (data,response) = try await URLSession.shared.data(for: requestValue)
            guard let response = response as? HTTPURLResponse, 200...400 ~= response.statusCode else {
                throw DataError.invalidResponse
            }
            let result = try JSONDecoder().decode(ModelData.self, from: data)
            let temp = result.main.temp
            let name = result.name
            let returnValue = ModelStructure(location: name, temperature: temp)
            return returnValue
        }
        catch {
            throw DataError.unknownError(errorValue: error)
        }
    }
}

/// Custom error Block.
enum DataError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case unknownError(errorValue: Error)
}
