//
//  arrayProcessor.swift
//  sharedprogramingcalculation
//
//  Created by Monali Palhal on 05/12/23.
//

import Foundation
import SwiftUI

class ArrayProcessor {
    let inputArray: [Float]

    init(count: Int) {
        // Initialize the random array with the specified count
        self.inputArray = ArrayProcessor.generateRandomArray(count: count)
    }

    // Function to generate a random array of floats
    private static func generateRandomArray(count: Int) -> [Float] {
        return (0..<count).map { _ in Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max) }
    }

    // Function to sum the array using Metal shader
    func sumArrayWithMetalShader() -> Float {
        let metalSummation = MetalSummation()
        return metalSummation.sumArrayWithMetalShader(inputArray: inputArray)
    }
    // Function to sum the array using Metal shader
    func sumTwoArrayWithMetalShader() -> [Float] {
        let metalSummation = MetalSummation()
        return metalSummation.sumoftwoarray(arrayA: inputArray, arrayB: inputArray)
    }

    // Function to sum the array using Swift method
    func sumArrayWithSwift() -> Float {
        return sumArrayWithSwift(inputArray: inputArray)
    }
    func sumOfTwoArrayWithSwift() -> [Float] {
        return sumoftwoarrya(array1: inputArray, array2: inputArray)
    }
    func sumArrayWithSwift(inputArray: [Float]) -> Float {
        return inputArray.reduce(0, +)
    }
    func sumoftwoarrya(array1 : [Float] , array2 : [Float])-> [Float]{
        zip(array1, array2).map { $0 + $1 }
    }
    // Function to measure execution time
    func measureExecutionTime<T>(_ block: () -> T) -> (result: T, time: Double) {
        let startTime = CACurrentMediaTime()
        let result = block()
        let endTime = CACurrentMediaTime()
        let executionTime = endTime - startTime
        return (result, executionTime)
    }
}



