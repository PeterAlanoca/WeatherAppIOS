//
//  HistoryView.swift
//  Weather App
//
//  Created by Peter Alanoca on 30/12/22.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel
    @State var isSearch = false
    @State var place: Place?

    var body: some View {
        ZStack {
            NavigationView {
                List(viewModel.places) { place in
                    Text(place.address ?? "")
                    .onTapGesture {
                        self.place = place
                        viewModel.getCurrentData(place: place)
                    }
                }
                .onAppear {
                    viewModel.getPlaces()
                }
                .sheet(isPresented: $viewModel.showSheet) {
                    if let weatherResponse = $viewModel.weatherResponse,
                       let value = weatherResponse.wrappedValue,
                       let info = value.info,
                       let weather = value.weather,
                       let place = place {
                        VStack(spacing: 10) {
                            VStack(spacing: 0) {
                                Text(place.country ?? "")
                                    .font(.system(size: 35, weight: .semibold))
                                Text(place.address ?? "")
                                    .lineLimit(2)
                                    .font(.system(size: 16, weight: .light))
                            }
                            HStack(spacing: 0) {
                                Text("\((info.temp ?? 0.0).toInt())")
                                    .font(.system(size: 80, weight: .black))
                                Text("ºc")
                                    .font(.system(size: 80, weight: .medium))
                            }
                            Text("-------------------")
                                .font(.system(size: 20, weight: .light))
                            VStack(spacing: 10) {
                                if let weather = weather.first {
                                    Text((weather.description ?? "").capitalized)
                                        .font(.system(size: 16, weight: .semibold))
                                    HStack(spacing: 2) {
                                        HStack(spacing: 0) {
                                            Text("\((info.tempMax ?? 0.0).toInt())")
                                                .font(.system(size: 18, weight: .bold))
                                            Text("ºc")
                                                .font(.system(size: 18, weight: .light))
                                        }
                                        Text("/")
                                            .font(.system(size: 18, weight: .light))
                                        HStack(spacing: 0) {
                                            Text("\((info.tempMin ?? 0.0).toInt())")
                                                .font(.system(size: 18, weight: .bold))
                                            Text("ºc")
                                                .font(.system(size: 18, weight: .light))
                                        }
                                    }
                                    if let image = UIImage(named: (weather.icon ?? "")) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 90, height: 90, alignment: .center)
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                        .presentationDetents([.height(395), .large])
                    }
                }
                .ignoresSafeArea(.keyboard)
                .navigationBarTitle("Historial", displayMode: .inline)
            }
            .disabled(viewModel.isLoading)
            ActivityIndicatorView(isAnimating: $viewModel.isLoading, style: .large)
        }.background(Color.blue.edgesIgnoringSafeArea(.all))
        
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: .init())
    }
}
