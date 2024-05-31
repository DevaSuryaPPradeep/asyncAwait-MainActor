//
//  ContentView.swift
//  async__mainactorApp.swift
//
//  Created by Devasurya on 27/04/24.
//

import SwiftUI

/// View.
struct WeatherView: View {
    
    /// Declaration for state property and @stateobject property wrappers.
    @State var temperatureDetails: Double = 0.0
    @State var locationDetails: String = ""
    @StateObject var viewmodelInstance : ViewModel =  ViewModel()
    @State var textFieldValue: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter the location here..", text: $textFieldValue)
                .frame(alignment: .center)
                .bold()
                .onSubmit {
                    Task {
                      try  await viewmodelInstance.extractData(_:textFieldValue)
                    }
                }
            HStack {
                Text("Location:")
                Text(String(describing: viewmodelInstance.dataSource.location))
            }
            HStack {
                Text("Temperature :")
                Text(String(describing: viewmodelInstance.dataSource.temperature))
            }
        }
        .padding()
    }
}

#Preview {
    WeatherView()
}


//Usage of Tasks.
/*
 A task is a unit of asynchronus work that can be added to the view to allow asynchrouns tasks to be performed.
 */
