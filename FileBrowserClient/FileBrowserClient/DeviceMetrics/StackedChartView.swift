//
//  StackedChartView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/29/25.
//

import SwiftUI

struct StackedChartView: View {
    let title: String
    let percentUsed: Double
    let formatUsed: () -> String
    let formatTotal: () -> String
    let color: Color

    var barCount: Int { 10 }

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)

            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<barCount, id: \.self) { index in
                    Rectangle()
                        .fill(index < Int(percentUsed * Double(barCount)) ? color : Color.gray.opacity(0.2))
                        .frame(width: 12, height: CGFloat(index + 1) * 10)
                        .animation(.easeInOut(duration: 0.4), value: percentUsed)
                }
            }
            .frame(height: 120)

            Text("\(formatUsed()) / \(formatTotal())")
                .font(.subheadline)
            Text(String(format: "%.1f%% used", percentUsed * 100))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
