//
//  RemoteImage.swift
//  TravelPlanner
//
//  Created by ankita sharma on 04/12/23.
//

// RemoteImage.swift

import SwiftUI
import SDWebImageSwiftUI

struct RemoteImage: View {
    let url: String?

    var body: some View {
        if let urlString = url, let imageUrl = URL(string: urlString) {
            WebImage(url: imageUrl)
                .resizable()
                .scaledToFit()
        } else {
            // Placeholder Image or Loading Indicator
            Image(systemName: "photo")
                .resizable()
                .foregroundColor(.gray)
        }
    }
}
