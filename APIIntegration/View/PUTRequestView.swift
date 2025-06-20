//
//  PUTRequestView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//





import SwiftUI
import Alamofire

struct PUTRequestView: View {
    @State private var postID = "1"
    @State private var title = "Updated Title"
    @State private var bodyText = "Updated Body"
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var updatedPost: Post?
    @State private var apiURL = ""
    @State private var timestamp = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("✏️ PUT Request – Update Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 40)

                    VStack(spacing: 14) {
                        CustomTextField(placeholder: "Post ID", text: $postID)
                            .keyboardType(.numberPad)

                        CustomTextField(placeholder: "Enter New Title", text: $title)

                        CustomTextField(placeholder: "Enter New Body", text: $bodyText)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(16)
                    .shadow(radius: 6)
                    .padding(.horizontal)

                    if isLoading {
                        ProgressView("Updating...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .padding()
                    }

                    Button(action: updatePost) {
                        Label("Update Post", systemImage: "arrow.triangle.2.circlepath.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal)

                    if let post = updatedPost {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("✅ Post Updated Successfully")
                                .font(.headline)
                                .foregroundColor(.green)

                            Divider()

                            Text("🌐 API Used: \(apiURL)")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            Text("🕒 Updated At: \(timestamp)")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            Divider()

                            HStack {
                                Text("🆔 Post ID:")
                                Spacer()
                                Text("\(post.id)")
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
                            HStack {
                                Text("👤 User ID:")
                                Spacer()
                                Text("\(post.userId)")
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(14)
                        .shadow(radius: 5)
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

                    Button("Clear") {
                        resetForm()
                    }
                    .font(.callout)
                    .foregroundColor(.gray)

                    Spacer(minLength: 40)
                }
            }
            .background(
                LinearGradient(colors: [.white, Color.blue.opacity(0.05)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .navigationTitle("PUT Request")
        }
    }

    func updatePost() {
        isLoading = true
        errorMessage = nil
        updatedPost = nil
        timestamp = ""
        apiURL = ""

        guard let idInt = Int(postID) else {
            errorMessage = "Invalid Post ID"
            isLoading = false
            return
        }

        let parameters: [String: Any] = [
            "id": idInt,
            "title": title,
            "body": bodyText,
            "userId": 1
        ]

        let url = "https://jsonplaceholder.typicode.com/posts/\(idInt)"
        apiURL = url

        NetworkManager.shared.putRequest(url: url, parameters: parameters) { (result: Result<Post, AFError>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let post):
                    updatedPost = post
                    timestamp = formattedDate()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }

    func resetForm() {
        postID = "1"
        title = ""
        bodyText = ""
        updatedPost = nil
        errorMessage = nil
        apiURL = ""
        timestamp = ""
    }
}






//import SwiftUI
//import Alamofire
//
//struct PUTRequestView: View {
//    @State private var title = "Updated Title"
//    @State private var bodyText = "Updated Body"
//    @State private var responseText = ""
//
//    var body: some View {
//        VStack(spacing: 16) {
//
//            VStack(spacing: 15){
//
//                CustomTextField(placeholder: "Enter new title", text: $title)
//
//                CustomTextField(placeholder: "Enter new body", text: $bodyText)
//            }.padding()
//                .background(Color.white.opacity(0.9))
//                .cornerRadius(20)
//                .shadow(radius: 10)
//                .padding(.horizontal)
//
//
//            Button("Update Post (PUT)") {
//                updatePost()
//            }
//            .frame(width: 200, height: 22)
//            .padding()
//            .foregroundColor(.black)
//            .background(Color.blue.opacity(0.4))
//            .font(.headline)
//            .cornerRadius(15)
//            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
//
//            if !responseText.isEmpty {
//                Text("✅ Server Response:")
//                    .font(.headline)
//                Text(responseText)
//                    .frame(width: 280)
//                    .padding()
//                    .background(Color.green.opacity(0.1))
//                    .font(.subheadline)
//                    .cornerRadius(8)
//                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
//            }
//        }
//        .padding()
//    }
//
//    func updatePost() {
//        let parameters: [String: Any] = [
//            "id": 1,
//            "title": title,
//            "body": bodyText,
//            "userId": 1
//        ]
//
//        NetworkManager.shared.putRequest(
//            url: "https://jsonplaceholder.typicode.com/posts/1",
//            parameters: parameters
//        ) { (result: Result<Post, AFError>) in
//            switch result {
//            case .success(let post):
//                responseText = """
//                ID: \(post.id)
//                Title: \(post.title)
//                Body: \(post.body)
//                User ID: \(post.userId)
//                """
//            case .failure(let error):
//                responseText = "❌ Error: \(error.localizedDescription)"
//            }
//        }
//    }
//}
