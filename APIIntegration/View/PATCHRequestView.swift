//
//  PATCHRequestView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//





import SwiftUI
import Alamofire

struct PATCHRequestView: View {
    @State private var postID = "1"
    @State private var title = "Patched Title"
    @State private var isLoading = false
    @State private var responseText = ""
    @State private var errorMessage: String?
    @State private var timestamp = ""
    @State private var apiURL = ""
    @State private var showDetails = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("🔧 PATCH Post Title")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.indigo)
                        .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 16) {
                        CustomTextField(placeholder: "Post ID", text: $postID)
                            .keyboardType(.numberPad)

                        CustomTextField(placeholder: "New Title", text: $title)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(16)
                    .shadow(radius: 6)
                    .padding(.horizontal)

                    if isLoading {
                        ProgressView("Patching...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    }

                    Button(action: patchPost) {
                        Label("Patch Now", systemImage: "arrow.up.right.square")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal)

                    if showDetails {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("✅ Patched Response")
                                .font(.headline)
                                .foregroundColor(.green)

                            Divider()

                            Text("🆔 Post ID: \(postID)")
                            Text("🌐 API: \(apiURL)")
                            Text("🕒 Time: \(timestamp)")
                            Text("✏️ New Title: \(title)")

                            Divider()

                            Text("📦 Full Response:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(responseText)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(14)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .transition(.opacity)
                    }

                    if let error = errorMessage {
                        VStack {
                            Text("❌ Error")
                                .font(.headline)
                                .foregroundColor(.red)
                            Text(error)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.red.opacity(0.8))
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(14)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .transition(.opacity)
                    }

                    Button("Clear") {
                        postID = "1"
                        title = ""
                        responseText = ""
                        errorMessage = nil
                        timestamp = ""
                        apiURL = ""
                        showDetails = false
                    }
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                    Spacer(minLength: 40)
                }
            }
            .background(
                LinearGradient(colors: [.white, Color.indigo.opacity(0.05)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .navigationTitle("Patch API")
        }
    }

    func patchPost() {
        isLoading = true
        responseText = ""
        errorMessage = nil
        showDetails = false

        let parameters: [String: Any] = ["title": title]
        let url = "https://jsonplaceholder.typicode.com/posts/\(postID)"

        NetworkManager.shared.patchRequest(url: url, parameters: parameters) { (result: Result<Post, AFError>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let post):
                    apiURL = url
                    responseText = """
                    ID: \(post.id)
                    Title: \(post.title)
                    Body: \(post.body)
                    User ID: \(post.userId)
                    """
                    timestamp = formattedDate()
                    showDetails = true
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
}




//import SwiftUI
//import Alamofire
//
//struct PATCHRequestView: View {
//    @State private var title = "Patched Title"
//    @State private var responseText = ""
//
//    var body: some View {
//        VStack(spacing: 16) {
//
//            VStack{
//
//                Text("Pacth the title")
//                    .font(.subheadline)
//                    .bold()
//
//
//                CustomTextField(placeholder: "Enter new title", text: $title)
//            }.padding()
//                .background(Color.white.opacity(0.9))
//                .cornerRadius(20)
//                .shadow(radius: 10)
//                .padding(.horizontal)
//
//            Button("Patch Post") {
//                patchPost()
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
//                Text("✅ Response:")
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
//    func patchPost() {
//        let parameters: [String: Any] = [
//            "title": title
//        ]
//
//        NetworkManager.shared.patchRequest(
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
