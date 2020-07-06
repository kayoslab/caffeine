import Foundation
import UIKit
import Spring

/*
*
* This ViewController will implement the UICaffeineStatisticsChartView (SwiftCharts Library)
* It will display the Caffeine Blod Concentration over a given period of time.
* Above that it could be possible to change the time eg. 12h, 24h, 48h.
* Maybe more statistical relevant content like how much milk, coffee, sugar was consumed
* during the last 30 days.
*
*/
class StatisticsViewController: UIViewController {

    @IBOutlet private weak var timeSelectorView: UICaffeineStatisticsTimeSelectorView?
    @IBOutlet private weak var statisticsChartView: UICaffeineStatisticsChartView?
    @IBOutlet private weak var caffeineRateLabel: UILabel?
    @IBOutlet private weak var totalCupsLabel: UILabel?
    @IBOutlet private weak var totalMilkLabel: UILabel?
    @IBOutlet private weak var totalSugarLabel: UILabel?

    @IBOutlet private weak var totalShotsImageView: DesignableImageView?
    @IBOutlet private weak var totalMilkImageView: DesignableImageView?
    @IBOutlet private weak var totalSugarImageView: DesignableImageView?

    @IBOutlet private weak var leftStatisticsDescriptionLabel: UILabel?
    @IBOutlet private weak var centerStatisticsDescriptionLabel: UILabel?
    @IBOutlet private weak var rightStatisticsDescriptionLabel: UILabel?

    private var selectorState: SelectorState = .day

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateStatisticsChartView()

        CaffeineDataService.shared.getCaffeineConcentration { (success, caffeineReturn) -> Void in
            guard success, let caffeineReturn = caffeineReturn else { return }
            DispatchQueue.main.async(
                execute: { [weak self] () -> Void in
                    self?.caffeineRateLabel?.text = "\(Int(round(caffeineReturn)))"
                }
            )
        }
        updateTotalLabels()
        animate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for totalImageView in [totalShotsImageView, totalMilkImageView, totalSugarImageView] {
            totalImageView?.isHidden = true
        }
    }

    @IBAction private func dayButtonTapped(_ sender: AnyObject) {
        timeSelectorView?.buttonTapped(with: .day)
        selectorState = .day
        updateStatisticsChartView()
        updateTotalLabels()
    }

    @IBAction private func weekButtonTapped(_ sender: AnyObject) {
        timeSelectorView?.buttonTapped(with: .week)
        selectorState = .week
        updateStatisticsChartView()
        updateTotalLabels()
    }

    @IBAction private func monthButtonTapped(_ sender: AnyObject) {
        timeSelectorView?.buttonTapped(with: .month)
        selectorState = .month
        updateStatisticsChartView()
        updateTotalLabels()
    }

    @IBAction private func yearButtonTapped(_ sender: AnyObject) {
        timeSelectorView?.buttonTapped(with: .year)
        selectorState = .year
        updateStatisticsChartView()
        updateTotalLabels()
    }

    private  func updateStatisticsChartView() {
        let consumption = DrinksService.shared.getConsumption(for: .init(with: selectorState))
        let distance = intersectDistance[selectorState.rawValue]
        let catmull = catmullRomSelection[selectorState.rawValue]

        statisticsChartView?.setUpGraphView(
            consumption.periodicData.map {
                $0.reduce(
                    0.0, { $0 + ConsumableProperties($1).caffeine }
                )
            },
            intersectDistance: distance,
            catmullRom: catmull
        )

        switch (selectorState) {
            case .day:
                leftStatisticsDescriptionLabel?.text = "0"
                centerStatisticsDescriptionLabel?.text = "12"
                rightStatisticsDescriptionLabel?.text = "24"
            case .week:
                guard Calendar.current.shortWeekdaySymbols.count >= 6 else { return }
                leftStatisticsDescriptionLabel?.text = Calendar.current.shortWeekdaySymbols[0]
                centerStatisticsDescriptionLabel?.text = Calendar.current.shortWeekdaySymbols[3]
                rightStatisticsDescriptionLabel?.text = Calendar.current.shortWeekdaySymbols[6]
            case .month:
                leftStatisticsDescriptionLabel?.text = "1st"
                centerStatisticsDescriptionLabel?.text = "15th"
                rightStatisticsDescriptionLabel?.text = "30th"
            case .year:
                guard Calendar.current.shortMonthSymbols.count >= 12 else { return }
                leftStatisticsDescriptionLabel?.text = Calendar.current.shortMonthSymbols[0]
                centerStatisticsDescriptionLabel?.text = ""
                rightStatisticsDescriptionLabel?.text = Calendar.current.shortMonthSymbols[11]
        }
    }

    private  func updateTotalLabels() {
        let consumption = DrinksService.shared.getConsumption(for: .init(with: selectorState))

        var milktext = ""
        if consumption.milk < 1000 {
            milktext = "\(Int(round(consumption.milk))) ml"
        } else if consumption.milk < 100000 {
            milktext = "\(String(format: "%.1f", consumption.milk / 1000)) l"
        } else {
            milktext = "\(Int(round(consumption.milk / 1000))) l"
        }

        var sugartext = ""
        if consumption.sugar < 1000 {
            sugartext = "\(String(format: "%.1f", Double(consumption.sugar))) g"
        } else if consumption.sugar < 100000 {
            sugartext = "\(String(format: "%.1f", Double(consumption.sugar) / Double(1000))) kg"
        } else {
            sugartext = "\(Int(round(Double(consumption.sugar) / Double(1000)))) kg"
        }

        totalCupsLabel?.text = "\(consumption.shots)"
        totalMilkLabel?.text = milktext
        totalSugarLabel?.text = sugartext
    }

    private  func animate() {
        var counter: Int = 0
        for totalImageView in [totalShotsImageView, totalMilkImageView, totalSugarImageView] {
            totalImageView?.isHidden = false
            totalImageView?.animation = "fadeIn"
            totalImageView?.delay = 0.1 + 0.3 * CGFloat(counter)
            totalImageView?.force = 1.0
            totalImageView?.duration = 0.5
            totalImageView?.damping = 0.9
            totalImageView?.velocity = 0.5
            totalImageView?.scaleX = 0.5
            totalImageView?.scaleY = 0.5
            totalImageView?.curve = "spring"
            counter += 1
            totalImageView?.animate()
        }
    }
}
