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
    @State private var successMessage: String = ""
    @State private var errorMessage: String?
    @State private var createdPost: Post?
    @State private var apiURL = ""
    @State private var timestamp = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("📝 Create a New Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top)

                    VStack(spacing: 15) {
                        CustomTextField(placeholder: "User ID", text: $userId)
                            .keyboardType(.numberPad)

                        CustomTextField(placeholder: "Enter Post Title", text: $title)

                        CustomTextField(placeholder: "Enter Post Body", text: $bodyText)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(16)
                    .shadow(radius: 8)
                    .padding(.horizontal)

                    if isLoading {
                        ProgressView("Posting...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .padding()
                    }

                    Button(action: postNewData) {
                        Label("Submit Post", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty || bodyText.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .disabled(title.isEmpty || bodyText.isEmpty || isLoading)
                    .padding(.horizontal)

                    if let post = createdPost {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("✅ Post Created Successfully")
                                .font(.headline)
                                .foregroundColor(.green)

                            Divider()

                            Text("🌐 API Endpoint: \(apiURL)")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            Text("🕒 Created At: \(timestamp)")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            Divider()

                            HStack {
                                Text("🆔 ID:")
                                Spacer()
                                Text("\(post.id)")
                            }
                            HStack {
                                Text("👤 User ID:")
                                Spacer()
                                Text("\(post.userId)")
                            }
                            HStack {
                                Text("📌 Title:")
                                Spacer()
                                Text(post.title)
                            }
                            HStack {
                                Text("📝 Body:")
                                Spacer()
                                Text(post.body)
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(14)
                        .shadow(radius: 6)
                        .padding(.horizontal)
                        .transition(.opacity)
                    }

                    if let error = errorMessage {
                        Text("❌ Error: \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    Button("Clear Form") {
                        resetForm()
                    }
                    .font(.callout)
                    .foregroundColor(.gray)
                }
                .padding(.bottom, 40)
            }
            .background(
                LinearGradient(colors: [.white, Color.blue.opacity(0.05)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .navigationTitle("POST Request")
        }
    }

    func postNewData() {
        isLoading = true
        errorMessage = nil
        createdPost = nil
        timestamp = ""
        apiURL = ""

        guard let userID = Int(userId) else {
            errorMessage = "Invalid User ID"
            isLoading = false
            return
        }

        let parameters: [String: Any] = [
            "title": title,
            "body": bodyText,
            "userId": userID
        ]

        let url = "https://jsonplaceholder.typicode.com/posts"
        apiURL = url

        NetworkManager.shared.postRequest(
            url: url,
            parameters: parameters
        ) { (result: Result<Post, AFError>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let post):
                    createdPost = post
                    timestamp = formattedDate()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func resetForm() {
        title = ""
        bodyText = ""
        createdPost = nil
        errorMessage = nil
        successMessage = ""
        timestamp = ""
        userId = "1"
    }

    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}
