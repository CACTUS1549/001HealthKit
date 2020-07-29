//
//  ViewController.swift
//  001HealthKit
//
//  Created by Deepak Reddy on 28/07/20.
//  Copyright © 2020 Deepak Reddy. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    var query: HKStatisticsCollectionQuery?
    
    let startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())
    let endDate = Date()
    let anchorDate = Date.mondayAt12AM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if HKHealthStore.isHealthDataAvailable() {
            print("Health Kit data is available in this device")
            requestPermissionsAndGetData()
        }
    }
    
    func requestPermissionsAndGetData(){
        let forDataTypes = Set([HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])

        healthStore.requestAuthorization(toShare: forDataTypes, read: forDataTypes) { (success, error) in
            if !success {
                // Handle the error here.
                fatalError("Could not get permissions from the user")
            } else{
                print("Permissions already granted. Getting Data")
                self.calculateDistanceData() { statisticsCollection in
                    self.updateFromStatistics(statisticsCollection!)
                }
            }
        }
    }
    
    func calculateDistanceData(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        let distanceWalkingRunning = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        let interval = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: distanceWalkingRunning, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        query!.initialResultsHandler = {query, statisticsColletion, error in
            completion(statisticsColletion)
        }
        
        healthStore.execute(query!)
    }
    
    func updateFromStatistics(_ statisticsCollection: HKStatisticsCollection){
        
        statisticsCollection.enumerateStatistics(from: startDate!, to: endDate) { (statistics, stop) in
            let distance = statistics.sumQuantity()?.doubleValue(for: HKUnit.mile())
            let distanceInKilometers = (distance ?? 0) * 1.609
            print(distanceInKilometers)
        }
    }
}
