//
//  ContentView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//


import SwiftUI
import Alamofire

struct ContentView: View {
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Buttons
                HStack {
                    Button("Fetch Posts") {
                        viewModel.fetchPosts()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Create Post") {
                        viewModel.createPost()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom)
                
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }

                // Error Message
                if let error = viewModel.errorMessage {
                    Text("❌ Error: \(error)")
                        .foregroundColor(.red)
                        .padding(.bottom)
                }

                // Success Message
                if let success = viewModel.successMessage {
                    Text(success)
                        .foregroundColor(.green)
                        .padding(.bottom)
                }

                // List of Posts
                List(viewModel.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Alamofire API")
        }
    }
}

#Preview {
    ContentView()
}
