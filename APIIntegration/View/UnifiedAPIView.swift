//
//  UnifiedAPIView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import SwiftUI

struct UnifiedAPIView: View {
    @State private var selectedTab = 0
    let tabs = ["GET", "POST", "PUT", "PATCH", "DELETE", "UPLOAD"]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("🚀 SwiftUI API Playground")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
                .padding(.top)

            // Tab Picker
            Picker("API Type", selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) {
                    Text(tabs[$0])
                        .font(.system(size: 5))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .frame(width: 400, height: 60)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)
            .padding()

            // Dynamic Content
            ScrollView {
                VStack {
                    switch selectedTab {
                    case 0: GETRequest()
                    case 1: POSTrequest()
                    case 2: PUTRequestView()
                    case 3: PATCHRequestView()
                    case 4: DELETERequestView()
                    case 5: UploadView()
                    default: Text("Please select a tab")
                }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                .animation(.easeInOut, value: selectedTab)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}
