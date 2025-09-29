//
//  LineChartView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/29/25.
//

import SwiftUI

struct LineChartView: View {
    let title: String
    let values: [Double]
    let maxValue: Double
    let color: Color

    private let yLabelWidth: CGFloat = 30

    @State private var offsetX: CGFloat = 0

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            GeometryReader { geometry in
                let fullWidth = geometry.size.width
                let height = geometry.size.height
                let chartWidth = fullWidth - yLabelWidth
                let stepX = chartWidth / CGFloat(Constants.lineChartMaxVisibleCount - 1)
                let scaleY = maxValue > 0 ? height / maxValue : 0

                let visibleValues = Array(values.suffix(Constants.lineChartMaxVisibleCount))
                let count = visibleValues.count

                HStack(alignment: .top, spacing: 0) {
                    // Y-Axis Labels
                    VStack(alignment: .trailing, spacing: 0) {
                        ForEach(0...Constants.lineChartGridLineCount, id: \.self) { idx in
                            let percent = 100 - (idx * (100 / Constants.lineChartGridLineCount))
                            Text("\(percent)%")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(
                                    height: height / CGFloat(Constants.lineChartGridLineCount),
                                    alignment: .top
                                )
                        }
                    }
                    .frame(width: yLabelWidth)

                    // Grid + Line Chart
                    ZStack {
                        // Grid lines
                        Path { path in
                            // Horizontal grid lines
                            for idx in 0...Constants.lineChartGridLineCount {
                                let yAxis = height / CGFloat(Constants.lineChartGridLineCount) * CGFloat(idx)
                                path.move(to: CGPoint(x: 0, y: yAxis))
                                path.addLine(to: CGPoint(x: chartWidth, y: yAxis))
                            }

                            // Vertical grid lines
                            let verticalSpacing = max(1, Constants.lineChartMaxVisibleCount / 10)
                            for idx in 0...Constants.lineChartMaxVisibleCount where idx % verticalSpacing == 0 {
                                let xAxis = CGFloat(idx) * stepX
                                path.move(to: CGPoint(x: xAxis, y: 0))
                                path.addLine(to: CGPoint(x: xAxis, y: height))
                            }
                        }
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)

                        // Line path
                        Path { path in
                            for (index, value) in visibleValues.enumerated() {
                                let reversedIndex = (count - 1) - index
                                let xAxis = chartWidth - CGFloat(reversedIndex) * stepX + offsetX
                                let yAxis = height - CGFloat(value) * scaleY

                                if index == 0 {
                                    path.move(to: CGPoint(x: xAxis, y: yAxis))
                                } else {
                                    path.addLine(to: CGPoint(x: xAxis, y: yAxis))
                                }
                            }
                        }
                        .stroke(color, lineWidth: 2)
                    }
                    .frame(width: chartWidth, height: height)
                    .clipped()
                    .onChange(of: values.count) { _ in
                        withAnimation(.linear(duration: 0.3)) {
                            offsetX -= stepX
                            if offsetX <= -stepX {
                                offsetX += stepX
                            }
                        }
                    }
                }
            }
            .frame(height: 100)
            .padding(.horizontal)
            .padding(.bottom, 4) // Bottom padding to avoid cutting off

            if let percentUsed = values.last {
                Text(String(format: "%.1f%% used", percentUsed))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
