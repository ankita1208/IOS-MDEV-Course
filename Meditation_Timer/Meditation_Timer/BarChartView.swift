import SwiftUI
import DGCharts

struct BarChartView: UIViewControllerRepresentable {
    var entries: [ProgressEntry]

    class Coordinator: NSObject, ChartViewDelegate {
        var parent: BarChartView

        init(parent: BarChartView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let chartViewController = UIViewController()

        // Use the DGCharts BarChartView here
        let chartView = DGCharts.BarChartView()
        chartView.delegate = context.coordinator

        chartViewController.view.addSubview(chartView)

        return chartViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the BarChartView in your view controller
        guard let chartView = uiViewController.view.subviews.first as? DGCharts.BarChartView else {
            return
        }

        var dataEntries: [ChartDataEntry] = []

        for (index, entry) in entries.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: entry.duration) // Assuming 'duration' is the property you want to use
            dataEntries.append(dataEntry)
        }

        let dataSet = BarChartDataSet(entries: dataEntries, label: "Session History")
        dataSet.colors = [NSUIColor.blue]
        let data = BarChartData(dataSet: dataSet)

        // Setting frame and other properties
        chartView.frame = uiViewController.view.bounds
        chartView.data = data
        chartView.animate(yAxisDuration: 1.0)
    }
}
