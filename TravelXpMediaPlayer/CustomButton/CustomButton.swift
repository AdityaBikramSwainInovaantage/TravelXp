//
//  OutlineButton.swift
//  TravelXpMediaPlayer
//
//  Created by Aditya Bikram Swain on 17/02/25.
//

import SwiftUI


struct CustomButton: View {
    var title: String
    
    var body: some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}
