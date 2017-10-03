//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
   var cells: [GridLocation] {
      get {
//
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
//            
//
            var occupiedCells = [GridLocation]()
        
        if isVertical {
            for y in start.y...end.y {
                occupiedCells.append(GridLocation(x: start.x, y: y))
            }
        }
        else {
            for x in start.x...end.x {
                occupiedCells.append(GridLocation(x: x, y: start.y))
            }
        }
        
         return occupiedCells
     }
   }
    
    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    
        var sunk: Bool {
            for hit in hitTracker.cellsHit {
                if hit.1 == false {
                    return false
                }
            }
            return true
        }
        
    

// TODO: Add custom initializers
    init(length: Int){
        self.length = length
        self.location = GridLocation(x: 0,y: 0)
        self.hitTracker = HitTracker()
        self.isVertical = false
        self.isWooden = false
        
    }
    
    init(length: Int,location: GridLocation,isVertical: Bool) {
       self.length = length
        self.location = location
        self.isVertical = isVertical
        self.hitTracker = HitTracker()
        self.isWooden = false
      }
   
    init(length: Int,location: GridLocation,isVertical: Bool,isWooden: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit:Bool {get}
    var PenaltyText:String {get set}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    var guaranteesHit: Bool
    
    var PenaltyText: String
    
    let location: GridLocation
  

}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    var PenaltyText: String
    
    let location: GridLocation
    
    var guaranteesHit: Bool
    

}

class ControlCenter {
    
    func placeItemsOnGrid(_ human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true)
        human.addShipToGrid(smallShip)
       
        
        let mediumShip1 = Ship(length: 3)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: true)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(guaranteesHit: true, PenaltyText: "YOU HIT A MINE", location: GridLocation(x: 6, y: 0))
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(guaranteesHit: true, PenaltyText: "YOU HIT A MINE", location: GridLocation(x: 3, y: 3))
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(PenaltyText: "YOU GET EXTRA TURN", location: GridLocation(x: 5, y: 6), guaranteesHit: true)
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(PenaltyText: "YOU GET EXTRA TURN", location: GridLocation(x: 2, y: 2), guaranteesHit: true)
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(_ gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}
