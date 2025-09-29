//
//  PieChartView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/29/25.
//

import SwiftUI

struct PieChartView: View {
    let title: String
    let percentUsed: Double
    let formatUsed: () -> String
    let formatTotal: () -> String
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                .frame(width: 140, height: 140)

            Circle()
                .trim(from: 0, to: CGFloat(percentUsed))
                .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 140, height: 140)
                .animation(.easeInOut(duration: 0.4), value: percentUsed)

            VStack {
                Text(title)
                    .font(.headline)
                Text("\(formatUsed()) / \(formatTotal())")
                    .font(.subheadline)
                Text(String(format: "%.1f%% used", percentUsed * 100))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
