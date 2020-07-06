import Foundation

/*
*
* A consumption object represents a Drink which can be consumed
* The Nutrition Data is loaded from essential .plist Files
* Call calculateHKValuesForSetup(coffee: Coffee, milk: Milk, size: Size, sugar: Sugar)
* to setup the Object with all Nutritionfacts
*/
struct ConsumableProperties {

    let title = NSLocalizedString("ConsumptionTitle", comment: "Caffeine Companion")

    private(set) var volume: Double = 0.0
    private(set) var caffeine: Double = 0.0
    private(set) var energyCalories: Double = 0.0
    private(set) var fat: Double = 0.0
    private(set) var saturatedFat: Double = 0.0
    private(set) var unsaturatedFat: Double = 0.0
    private(set) var sodium: Double = 0.0
    private(set) var potassium: Double = 0.0
    private(set) var carbs: Double = 0.0
    private(set) var sugar: Double = 0.0
    private(set) var protein: Double = 0.0
    private(set) var amountOfMilk: Double = 0.0

    init(_ consumable: Consumable) {
        loadDataForCoffee(consumable.coffee)
        loadDataForMilk(consumable.milk, size: consumable.size)
        loadDataForSugar(consumable.sugar)
    }

    // MARK: Loading From plist Files

    /*
    *
    * Loads nutrition Data for Coffee depending on the
    * kind of coffee
    *
    */
    private mutating func loadDataForCoffee(_ coffee: Coffee) {
        let path = Bundle.main.path(forResource: "Coffee", ofType: "plist")
        let coffeeArray = NSArray(contentsOfFile: path!)
        var data: Dictionary<String, AnyObject>
        let modifier: Double = 1.0

        switch(coffee) {
        case .noShot:
            data = coffeeArray?.object(at: 0) as! Dictionary<String, AnyObject>
        case .singleShot:
            data = (coffeeArray?.object(at: 1))! as! Dictionary<String, AnyObject>
        case .doubleShot:
            data = coffeeArray?.object(at: 2) as! Dictionary<String, AnyObject>
        case .tripleShot:
            data = coffeeArray?.object(at: 3) as! Dictionary<String, AnyObject>
        }
        loadNutritionDataWithModifier(data, modifier: modifier)
    }

    /*
    *
    * Loads nutrition Data for Milk depending on the
    * kind of milk and the size of the mug into the vars
    *
    */
    private mutating func loadDataForMilk(_ milk: Milk, size: Size) {
        let path = Bundle.main.path(forResource: "Milk", ofType: "plist")
        let milkArray = NSArray(contentsOfFile: path!)
        var data: Dictionary<String, AnyObject> = Dictionary()

        switch(milk) {
        case .black:
            data = milkArray?.object(at: 0) as! Dictionary<String, AnyObject>
        case .lactoseFree:
            data = milkArray?.object(at: 1) as! Dictionary<String, AnyObject>
        case .fullFat:
            data = milkArray?.object(at: 2) as! Dictionary<String, AnyObject>
        case .soyMilk:
            data = milkArray?.object(at: 3) as! Dictionary<String, AnyObject>
        }

        let sizePath = Bundle.main.path(forResource: "Size", ofType: "plist")
        let sizeArray = NSArray(contentsOfFile: sizePath!)
        var sizeDict: Dictionary<String, AnyObject> = Dictionary()
        var modifier: Double = 1.0

        switch(size) {
        case .noSize:
            sizeDict = sizeArray?.object(at: 0) as! Dictionary<String, AnyObject>
        case .small:
            sizeDict = sizeArray?.object(at: 1) as! Dictionary<String, AnyObject>
        case .medium:
            sizeDict = sizeArray?.object(at: 2) as! Dictionary<String, AnyObject>
        case .large:
            sizeDict = sizeArray?.object(at: 3) as! Dictionary<String, AnyObject>
        }
        modifier = (sizeDict["volume"] as! Double - volume) / 100
        amountOfMilk = data["volume"] as! Double * modifier
        loadNutritionDataWithModifier(data, modifier: modifier)
    }

    /*
    *
    * Loads nutrition Data for Sugar depending on the
    * selected number into the vars
    *
    */
    private mutating func loadDataForSugar(_ sugar: Sugar) {
        let path = Bundle.main.path(forResource: "Sugar", ofType: "plist")
        let sugarArray = NSArray(contentsOfFile: path!)
        var data: Dictionary<String, AnyObject> = Dictionary()
        let modifier: Double = 1.0

        switch(sugar) {
        case .noSugar:
            data = sugarArray?.object(at: 0) as! Dictionary<String, AnyObject>
        case .singlePiece:
            data = sugarArray?.object(at: 1) as! Dictionary<String, AnyObject>
        case .twoPieces:
            data = sugarArray?.object(at: 2) as! Dictionary<String, AnyObject>
        case .threePieces:
            data = sugarArray?.object(at: 3) as! Dictionary<String, AnyObject>
        }
        loadNutritionDataWithModifier(data, modifier: modifier)
    }

    /*
    *
    * Outsourcing of the Interpretation for all Load-Functions
    * modifies the class Variables with Data and Modifier
    *
    */
    private mutating func loadNutritionDataWithModifier(
        _ data: Dictionary<String, AnyObject>,
        modifier: Double
    ) {
        volume = volume + (data["volume"] as! Double) * modifier
        caffeine = caffeine + (data["hkcaffeine"] as! Double) * modifier
        energyCalories = energyCalories + (data["hkenergyCalories"] as! Double) * modifier
        fat = fat + (data["hkfat"] as! Double) * modifier
        saturatedFat = saturatedFat + (data["hksaturatedFat"] as! Double) * modifier
        unsaturatedFat = unsaturatedFat + (data["hkunsaturatedFat"] as! Double) * modifier
        sodium = sodium + (data["hksodium"] as! Double) * modifier
        potassium = potassium + (data["hkpotassium"] as! Double) * modifier
        carbs = carbs + (data["hkcarbs"] as! Double) * modifier
        sugar = sugar + (data["hksugar"] as! Double) * modifier
        protein = protein + (data["hkprotein"] as! Double) * modifier
    }
}
