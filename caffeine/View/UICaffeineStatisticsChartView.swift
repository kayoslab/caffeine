import Foundation
import UIKit

/*
*
* This View will display the Caffeine Blod Concentration over a given period of time.
* Above that it could be possible to change the time eg. 12h, 24h, 48h.
* Maybe more statistical relevant content like how much milk, coffee, sugar was consumed
* during the last 30 days.
*
*/

class UICaffeineStatisticsChartView: UIView {
    private var items: [Double] = []
    private var catmullRom: Bool = true
    private var objectCounter: Int {
        return items.count
    }
    private var intersectDistance: Int = 4

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init () {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        if !items.isEmpty {
            // margin-left && margin-right
            let margin: CGFloat = 20.0
            let topBorder: CGFloat = 10
            let bottomBorder: CGFloat = 40
            let graphBorder: CGFloat = 30
            let graphHeight = rect.height - topBorder - bottomBorder - graphBorder

            let spacer = (rect.width - margin * 2) / CGFloat((items.count - 1))
            let maxValue: Int = Int(items.max() ?? 0.0)

            let columnXPoint = { (column: Int) -> CGFloat in
                var x: CGFloat = CGFloat(column) * spacer
                x += margin
                return x
            }
            let columnYPoint = { (graphPoint: Int) -> CGFloat in
                var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
                y = graphHeight + topBorder + graphBorder - y // Flip the graph
                return y
            }

            for index: Int in 0..<Int(objectCounter / intersectDistance) {
                let intersectHeight = (bounds.height - bottomBorder - topBorder)
                let intersectPath = UIBezierPath()

                let intersectStartPoint = CGPoint(x: columnXPoint(index * intersectDistance), y: bounds.height - bottomBorder)
                let intersectEndPoint = CGPoint(x: intersectStartPoint.x, y: intersectStartPoint.y - intersectHeight)
                intersectPath.move(to: intersectStartPoint)
                intersectPath.addLine(to: intersectEndPoint)

                UIColor.clear.setStroke()
                intersectPath.lineWidth = 1.0
                intersectPath.stroke()

                //2 - get the current context
                let context = UIGraphicsGetCurrentContext()
                let colors = [
                    CaffeineColors.statsSeparatorStart.color.cgColor,
                    CaffeineColors.statsSeparatorEnd.color.cgColor
                ]
                //3 - set up the color space
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                //4 - set up the color stops
                let colorLocations: [CGFloat] = [0.0, 0.95]
                //5 - create the gradient
                let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
                //save the state of the context
                context?.saveGState()
                context?.setLineWidth(intersectPath.lineWidth)
                context?.addPath(intersectPath.cgPath)
                context?.replacePathWithStrokedPath()
                context?.clip()

                context?.drawLinearGradient(gradient!, start: intersectStartPoint, end: intersectEndPoint, options: .drawsAfterEndLocation)
                context?.restoreGState()
            }

            var notZero: Bool = false
            for item in self.items {
                if item != 0.0 {
                    notZero = true
                }
            }

            // draw the line graph
            CaffeineColors.graph.color.setFill()
            CaffeineColors.graph.color.setStroke()
            let graphPath = UIBezierPath()

            if notZero {
                if catmullRom == false || items.count < 4 {
                    graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(Int(items[0]))))
                    for i in 1..<items.count {
                        let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(Int(items[i])))
                        graphPath.addLine(to: nextPoint)
                    }
                } else {
                    let startIndex = 1
                    let endIndex = items.count - 2
                    let alpha: CGFloat = 0.5
                    for i in startIndex ..< endIndex {
                        let p0 = CGPoint(x: columnXPoint(i - 1 < 0 ? items.count - 1 : i - 1), y: columnYPoint(Int(items[i - 1 < 0 ? items.count - 1 : i - 1])))
                        let p1 = CGPoint(x: columnXPoint(i), y: columnYPoint(Int(items[i])))
                        let p2 = CGPoint(x: columnXPoint((i + 1) % items.count), y: columnYPoint(Int(items[(i + 1) % items.count]))) // (i+1)%(self.items?.count)!
                        let p3 = CGPoint(x: columnXPoint((i + 1) % items.count + 1), y: columnYPoint(Int(items[(i + 1) % items.count + 1]))) // (i+1)%(self.items?.count)! + 1

                        let d1 = p1.deltaTo(p0).length()
                        let d2 = p2.deltaTo(p1).length()
                        let d3 = p3.deltaTo(p2).length()

                        var b1 = p2.multiplyBy(pow(d1, 2 * alpha))
                        b1 = b1.deltaTo(p0.multiplyBy(pow(d2, 2 * alpha)))
                        b1 = b1.addTo(p1.multiplyBy(2 * pow(d1, 2 * alpha) + 3 * pow(d1, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
                        b1 = b1.multiplyBy(1.0 / (3 * pow(d1, alpha) * (pow(d1, alpha) + pow(d2, alpha))))

                        var b2 = p1.multiplyBy(pow(d3, 2 * alpha))
                        b2 = b2.deltaTo(p3.multiplyBy(pow(d2, 2 * alpha)))
                        b2 = b2.addTo(p2.multiplyBy(2 * pow(d3, 2 * alpha) + 3 * pow(d3, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
                        b2 = b2.multiplyBy(1.0 / (3 * pow(d3, alpha) * (pow(d3, alpha) + pow(d2, alpha))))

                        if i == startIndex {
                            graphPath.move(to: p0)
                        }
                        graphPath.addCurve(to: p2, controlPoint1: b1, controlPoint2: b2)
                    }
                    let nextPoint = CGPoint(x: columnXPoint(items.count - 1), y: columnYPoint(Int(items[items.count - 1])))
                    graphPath.addLine(to: nextPoint)
                }
            } else {
                let zero = graphHeight + topBorder + graphBorder
                graphPath.move(to: CGPoint(x: columnXPoint(0), y: zero))
                for i in 1..<items.count {
                    let nextPoint = CGPoint(x: columnXPoint(i), y: zero)
                    graphPath.addLine(to: nextPoint)
                }
            }

            graphPath.lineWidth = 2.0
            graphPath.stroke()
            for i in 0..<items.count {
                if i % intersectDistance == 0 {
                    var point = CGPoint(x: columnXPoint(i), y: columnYPoint(Int(items[i])))
                    point.x -= 5.0 / 2
                    point.y -= 5.0 / 2

                    let circle = UIBezierPath(ovalIn:
                        CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
                    circle.fill()
                }
            }
        }
    }

    internal func setUpGraphView(
        _ items: [Double],
        intersectDistance: Int = 4,
        catmullRom: Bool = true
    ) {
        self.items = items
        self.intersectDistance = intersectDistance
        self.catmullRom = catmullRom

        self.setNeedsDisplay()
    }
}

extension CGPoint {
    func translate(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }

    func translateX(_ x: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y)
    }

    func translateY(_ y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y + y)
    }

    func invertY() -> CGPoint {
        return CGPoint(x: self.x, y: -self.y)
    }

    func xAxis() -> CGPoint {
        return CGPoint(x: 0, y: self.y)
    }

    func yAxis() -> CGPoint {
        return CGPoint(x: self.x, y: 0)
    }

    func addTo(_ a: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + a.x, y: self.y + a.y)
    }

    func deltaTo(_ a: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - a.x, y: self.y - a.y)
    }

    func multiplyBy(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * value, y: self.y * value)
    }

    func length() -> CGFloat {
        return CGFloat(
            sqrt(
                CDouble(
                    self.x * self.x + self.y * self.y
                )
            )
        )
    }

    func normalize() -> CGPoint {
        let l = self.length()
        return CGPoint(x: self.x / l, y: self.y / l)
    }

    static func fromString(_ string: String) -> CGPoint {
        var s = string.replacingOccurrences(of: "{", with: "")
        s = s.replacingOccurrences(of: "}", with: "")
        s = s.replacingOccurrences(of: " ", with: "")

        let x = NSString(string: s.components(separatedBy: ",").first! as String).doubleValue
        let y = NSString(string: s.components(separatedBy: ",").last! as String).doubleValue

        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
