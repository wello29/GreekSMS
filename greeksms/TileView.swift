//
//  TileView.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/8/24.

//DECLARED ALREADY in HomePage.swift

//import Foundation
//import SwiftUI
//
//struct TileView: View {
//    var title: String
//    var subtitle: String?
//    var icon: String?
//    var backgroundColor: Color = Color.blue
//    var action: (() -> Void)?
//    
//    var body: some View {
//        Button(action: {
//            action?()
//        }) {
//            VStack {
//                if let icon = icon {
//                    Image(systemName: icon)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(.white)
//                }
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                
//                if let subtitle = subtitle {
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .padding()
//            .background(backgroundColor)
//            .cornerRadius(10)
//            .shadow(radius: 3)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
