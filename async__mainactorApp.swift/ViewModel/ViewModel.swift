//
//  Viewmodel.swift
//  async__mainactorApp.swift
//
//  Created by Devasurya on 27/04/24.
//

import Foundation

/// Viewmodel.
class ViewModel: ObservableObject {
    
    /// Published Property declarations.
    @Published var dataSource: ModelStructure = ModelStructure(location: "", temperature:0.0)
    
    /// Function which is used in the view to call the asynchrounus call to the API, this function is called in the mainthread also
    /// - Parameter cityName: Is of type String that is used to analyse the location details typed in by the user.
    /// - Returns: Returns a result of ModelStructure.
    @MainActor
    func extractData(_ cityName: String)async throws -> ModelStructure {
        do {
            dataSource =  try await fetchWeatherData(cityName)
            return dataSource
        }
        catch {
            throw DataError.unknownError(errorValue: error)
        }
    }
    
    /// Function that is responsible for the API  call.
    /// - Parameter cityId: Is of type String that is used to analyse the location details typed in by the user.
    /// - Returns:  Returns a result of ModelStructure.
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

//Async-Await.
/*
 At first developers used completion closures and delegate patterns to implement asynchronus tasks.
 so then apple in WWD21 introduced async await functionality.
 By adding async to the method signature we are telling the compiler to stay on hold until the asynchronus functioned mentioned to return a value.
 */
