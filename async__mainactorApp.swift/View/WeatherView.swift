//
//  ContentView.swift
//  async__mainactorApp.swift
//
//  Created by Devasurya on 27/04/24.
//

import SwiftUI

struct WeatherView: View {
    
    /// Declarationfor state property and @stateobject property wrappers.
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
