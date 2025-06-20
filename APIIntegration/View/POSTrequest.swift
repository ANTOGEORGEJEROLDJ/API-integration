//
//  POSTrequest.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//


import SwiftUI
import Alamofire

struct POSTrequest: View {
    @State private var userId = "1"
    @State private var title = ""
    @State private var bodyText = ""
    @State private var isLoading = false
    @State private var createdPost: Post?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("📝 Create a New Post")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.blue)
                    
                    CustomTextField(placeholder: "User ID", text: $userId)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    
                    CustomTextField(placeholder: "Post Title", text: $title)
                        .padding(.horizontal)
                    
                    CustomTextField(placeholder: "Post Body", text: $bodyText)
                        .padding(.horizontal)
                    
                    if isLoading {
                        ProgressView("Posting...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    }
                    
                    Button("Submit Post") {
                        postNewData()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(title.isEmpty || bodyText.isEmpty || userId.isEmpty)
                    
                    if let post = createdPost {
                        VStack(alignment: .leading) {
                            Text("✅ Created Post:")
                            Text("🆔 ID: \(post.id)")
                            Text("👤 User ID: \(post.userId)")
                            Text("📌 Title: \(post.title)")
                            Text("📝 Body: \(post.body)")
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    if let error = errorMessage {
                        Text("❌ \(error)")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("POST")
        }
    }
    
    func postNewData() {
        isLoading = true
        errorMessage = nil
        createdPost = nil
        
        guard let userID = Int(userId) else {
            errorMessage = "User ID must be a number"
            isLoading = false
            return
        }
        
        let parameters: [String: Any] = [
            "title": title,
            "body": bodyText,
            "userId": userID
        ]
        
        let url = "https://jsonplaceholder.typicode.com/posts"
        
        NetworkManager.shared.postRequest(url: url, parameters: parameters) { (result: Result<Post, AFError>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let post):
                    createdPost = post
                    PostStore.shared.locallyCreatedPosts.append(post)
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
    
}
