//
//  BarChartView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/29/25.
//

import SwiftUI

struct BarChartView: View {
    let title: String
    let percentUsed: Double
    let formatUsed: () -> String
    let formatTotal: () -> String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)

            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(10)

                Rectangle()
                    .frame(width: CGFloat(percentUsed) * 200, height: 20)
                    .foregroundColor(color)
                    .cornerRadius(10)
                    .animation(.easeInOut(duration: 0.4), value: percentUsed)
            }
            .frame(width: 200)

            Text("\(formatUsed()) / \(formatTotal())")
                .font(.subheadline)
            Text(String(format: "%.1f%% used", percentUsed * 100))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
