//
//  UploadView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//


import SwiftUI

struct UploadView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0
    @State private var statusMessage: String?
    @State private var uploadedImageURL: String?
    @State private var isError = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("📤 Upload Image to imgbb")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 6)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                        .foregroundColor(.gray)
                        .frame(height: 200)
                        .overlay(Text("No Image Selected").foregroundColor(.gray))
                }

                HStack(spacing: 20) {
                    Button("📷 Pick Image") {
                        showImagePicker = true
                    }
                    .buttonStyle(.borderedProminent)

                    Button("🚀 Upload") {
                        uploadSelectedImage()
                    }
                    .buttonStyle(.bordered)
                    .disabled(selectedImage == nil || isUploading)
                }

                if isUploading {
                    ProgressView(value: uploadProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.horizontal)
                }

                if let msg = statusMessage {
                    Text(msg)
                        .font(.body)
                        .foregroundColor(isError ? .red : .green)
                        .padding()
                        .background(isError ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                if let url = uploadedImageURL {
                    Link("🖼 View Uploaded Image", destination: URL(string: url)!)
                        .font(.headline)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(image: $selectedImage)
            }
        }
    }

    func uploadSelectedImage() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        isUploading = true
        statusMessage = nil
        isError = false
        uploadProgress = 0

        NetworkManager.shared.uploadImage(imageData: imageData, progressHandler: { progress in
            uploadProgress = progress
        }) { result in
            isUploading = false
            switch result {
            case .success(let url):
                uploadedImageURL = url
                statusMessage = "✅ Image Uploaded Successfully!"
            case .failure(let error):
                isError = true
                statusMessage = "❌ Upload failed: \(error.localizedDescription)"
            }
        }
    }
}





//import Foundation
//import SwiftUI
//
//struct UploadView: View {
//    @State private var selectedImage: UIImage?
//    @State private var showImagePicker = false
//
//    var body: some View {
//        VStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//            }
//
//            Button("Pick Image") {
//                showImagePicker = true
//            }
//
//            Button("Upload Image") {
//                if let data = selectedImage?.jpegData(compressionQuality: 0.8) {
//                    NetworkManager.shared.uploadImage(imageData: data) { result in
//                        switch result {
//                        case .success(let msg):
//                            print("✅ \(msg)")
//                        case .failure(let error):
//                            print("❌ \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePickerView(image: $selectedImage)
//        }
//    }
//}
//
//
//  UploadView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

//import Foundation
//import SwiftUI
//
//struct UploadView: View {
//    @State private var selectedImage: UIImage?
//    @State private var showImagePicker = false
//
//    var body: some View {
//        VStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//            }
//
//            Button("Pick Image") {
//                showImagePicker = true
//            }
//
//            Button("Upload Image") {
//                if let data = selectedImage?.jpegData(compressionQuality: 0.8) {
//                    NetworkManager.shared.uploadImage(imageData: data) { result in
//                        switch result {
//                        case .success(let msg):
//                            print("✅ \(msg)")
//                        case .failure(let error):
//                            print("❌ \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePickerView(image: $selectedImage)
//        }
//    }
//}
//
