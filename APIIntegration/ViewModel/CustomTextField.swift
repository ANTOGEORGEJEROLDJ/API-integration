//
//  CustomTextField.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import SwiftUI

struct CustomTextField: View {
    
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack{
            
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)

        }
    }

