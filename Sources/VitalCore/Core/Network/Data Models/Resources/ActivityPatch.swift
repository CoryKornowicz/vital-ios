import Foundation

public struct ActivityPatch: Encodable {
  public struct Activity: Encodable {
    public let date: Date
    public let activeEnergyBurned: Double
    public let exerciseTime: Double
    public let standingTime: Double
    public let moveTime: Double
    
    public var basalEnergyBurned: [QuantitySample] = []
    public var steps: [QuantitySample] = []
    public var floorsClimbed: [QuantitySample] = []
    public var distanceWalkingRunning: [QuantitySample] = []
    public var vo2Max: [QuantitySample] = []
    
    public init(
      date: Date,
      activeEnergyBurned: Double,
      exerciseTime: Double,
      standingTime: Double,
      moveTime: Double,
      basalEnergyBurned: [QuantitySample] = [],
      steps: [QuantitySample] = [],
      floorsClimbed: [QuantitySample] = [],
      distanceWalkingRunning: [QuantitySample] = [],
      vo2Max: [QuantitySample] = []
    ) {
      self.date = date
      self.activeEnergyBurned = activeEnergyBurned
      self.exerciseTime = exerciseTime
      self.standingTime = standingTime
      self.moveTime = moveTime
      self.basalEnergyBurned = basalEnergyBurned
      self.steps = steps
      self.floorsClimbed = floorsClimbed
      self.distanceWalkingRunning = distanceWalkingRunning
      self.vo2Max = vo2Max
    }
  }
  
  public let activities: [Activity]
  
  public init(activities: [Activity]) {
    self.activities = activities
  }
}