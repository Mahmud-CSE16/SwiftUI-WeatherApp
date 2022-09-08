//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mahmud on 25/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack{
            
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                }else{
                    LoadingView().task {
                        do{
                            weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, logitude: location.longitude) 
                        }catch{
                            print("Error getting weather: \(error)")
                        }
                    }
                }
            }else{
                if locationManager.isLoading {
                    LoadingView()
                }else{
                    WelcomeView().environmentObject(locationManager)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hue: 0.665, saturation: 0.797, brightness: 0.126))
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
