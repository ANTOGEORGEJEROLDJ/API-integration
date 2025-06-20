//
//  UnifiedAPIView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import SwiftUI

struct UnifiedAPIView: View {
    @State private var selectedTab = 0
    let tabs = ["GET", "POST", "FetchID" ,"PUT", "PATCH", "DELETE", "UPLOAD"]
    
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
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
            .frame(width: 300, height: 60)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)
            .padding()
            .environment(\.sizeCategory, .small) // 👈 This shrinks the Picker text


            // Dynamic Content
            ScrollView {
                VStack {
                    switch selectedTab {
                    case 0: GETRequest()
                    case 1: POSTrequest()
                    case 2: FetchPostByUserId()
                    case 3: PUTRequestView()
                    case 4: PATCHRequestView()
                    case 5: DELETERequestView()
                    case 6: UploadView()
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
