//
//  FetchPostByUserId.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//


import SwiftUI
import Alamofire

struct FetchPostByUserId: View {
    @State private var userId: String = "1"
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var posts: [Post] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("🔍 Fetch Posts by User ID")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.blue)

                    CustomTextFields(placeholder: "Enter User ID", text: $userId)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)

                    if isLoading {
                        ProgressView("Loading...")
                    }

                    Button("GET Posts") {
                        fetchPostsForUser()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    if let error = errorMessage {
                        Text("❌ \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }

                    ForEach(posts) { post in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🆔 ID: \(post.id)")
                            Text("📌 Title: \(post.title)")
                            Text("📝 Body: \(post.body)")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding()
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .navigationTitle("GET")
        }
    }

    func fetchPostsForUser() {
        isLoading = true
        errorMessage = nil
        posts = []

        guard let id = Int(userId), id > 0 else {
            errorMessage = "Please enter a valid User ID"
            isLoading = false
            return
        }

        let url = "https://jsonplaceholder.typicode.com/posts?userId=\(id)"

        AF.request(url)
            .validate()
            .responseDecodable(of: [Post].self) { response in
                DispatchQueue.main.async {
                    isLoading = false
                    switch response.result {
                    case .success(let fetched):
                        let localPosts = PostStore.shared.locallyCreatedPosts.filter { $0.userId == id }
                        posts = fetched + localPosts
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
    }
}

import SwiftUI

struct CustomTextFields: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
}

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
#endif
