import Foundation
import UIKit

enum SelectorState: Int {
    case day
    case week
    case month
    case year
}

class UICaffeineStatisticsTimeSelectorView: UIView {
    @IBOutlet private weak var dayButton: UIButton?
    @IBOutlet private weak var weekButton: UIButton?
    @IBOutlet private weak var monthButton: UIButton?
    @IBOutlet private weak var yearButton: UIButton?
    @IBOutlet private weak var dayIndicatorView: UIView?
    @IBOutlet private weak var weekIndicatorView: UIView?
    @IBOutlet private weak var monthIndicatorView: UIView?
    @IBOutlet private weak var yearIndicatorView: UIView?
    private var selectorState: SelectorState = .day

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init () {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func updateIndicatorState() {
        for indicator in [
            dayIndicatorView,
            weekIndicatorView,
            monthIndicatorView,
            yearIndicatorView
        ] {
            indicator?.isHidden = true
        }
        switch selectorState {
        case .day:
            dayIndicatorView?.isHidden = false
        case .week:
            weekIndicatorView?.isHidden = false
        case .month:
            monthIndicatorView?.isHidden = false
        case .year:
            yearIndicatorView?.isHidden = false
        }
    }

    func buttonTapped(with selectorState: SelectorState) {
        self.selectorState = selectorState
        updateIndicatorState()
    }
}
