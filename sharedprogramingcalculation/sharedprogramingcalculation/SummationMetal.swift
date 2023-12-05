//
//  summationmetal.swift
//  sharedprogramingcalculation
//
//  Created by Monali Palhal on 05/12/23.
//

import Foundation
import Metal

struct ArrayInfo {
    var array_length: UInt32
}

class MetalSummation {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    private let library: MTLLibrary
    
    init() {
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = device.makeCommandQueue()
        self.library = device.makeDefaultLibrary()!
    }
    
    func sumArrayWithMetalShader(inputArray: [Float]) -> Float {
        let arrayLength = UInt32(inputArray.count)
        
        // Set up Metal buffers
        let inputBuffer = device.makeBuffer(bytes: inputArray,
                                            length: inputArray.count * MemoryLayout<Float>.stride,
                                            options: [])!
        let outputBuffer = device.makeBuffer(length: MemoryLayout<Float>.stride, options: [])!
        var arrayInfo = ArrayInfo(array_length: arrayLength)
        let arrayInfoBuffer = device.makeBuffer(bytes: &arrayInfo,
                                                length: MemoryLayout<ArrayInfo>.stride,
                                                options: [])!

        
        // Set up Metal pipeline

        let kernelFunction = library.makeFunction(name: "sum_array")!
        let pipelineState = try! device.makeComputePipelineState(function: kernelFunction)
        
        // Set up Metal compute command
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let computeCommandEncoder = commandBuffer.makeComputeCommandEncoder()!
        computeCommandEncoder.setComputePipelineState(pipelineState)
        computeCommandEncoder.setBuffer(inputBuffer, offset: 0, index: 0)
        computeCommandEncoder.setBuffer(outputBuffer, offset: 0, index: 1)
        computeCommandEncoder.setBuffer(arrayInfoBuffer, offset: 0, index: 2)
        
        // Set up thread groups and dispatch them
        let threadExecutionWidth = pipelineState.threadExecutionWidth
        let threadsPerGroup = MTLSize(width: threadExecutionWidth, height: 1, depth: 1)
        let numThreadgroups = MTLSize(width: (inputArray.count + threadExecutionWidth - 1) / threadExecutionWidth, height: 1, depth: 1)
        computeCommandEncoder.dispatchThreadgroups(numThreadgroups, threadsPerThreadgroup: threadsPerGroup)
        
        // End encoding and execute command buffer
        computeCommandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        // Read result from Metal buffer
        var result: Float = 0.0
        memcpy(&result, outputBuffer.contents(), MemoryLayout<Float>.size)
        
        return result
    }
    func sumoftwoarray(arrayA: [Float], arrayB: [Float])->[Float] {

        // Create a Metal device
        

        // Create Metal buffers for the input arrays and the result array
        // let arrayA: [Float] = [1.0, 2.0, 3.0, 4.0]
        // let arrayB: [Float] = [5.0, 6.0, 7.0, 8.0]
        var result: [Float] =  Array<Float>(repeating: 0, count: arrayB.count)


        let bufferA = device.makeBuffer(bytes: arrayA, length: arrayA.count * MemoryLayout<Float>.stride, options: [])
        let bufferB = device.makeBuffer(bytes: arrayB, length: arrayB.count * MemoryLayout<Float>.stride, options: [])
        let bufferResult = device.makeBuffer(bytes: result, length: result.count * MemoryLayout<Float>.stride, options: [])

        // Create a Metal command queue
        let commandQueue = device.makeCommandQueue()!

        // Create a Metal compute pipeline with the sumArrays function
        let function = library.makeFunction(name: "sumArrays")!
        let pipelineState = try! device.makeComputePipelineState(function: function)

        // Create a Metal compute command encoder
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let computeEncoder = commandBuffer.makeComputeCommandEncoder()!

        // Set the pipeline state and buffers for the compute encoder
        computeEncoder.setComputePipelineState(pipelineState)
        computeEncoder.setBuffer(bufferA, offset: 0, index: 0)
        computeEncoder.setBuffer(bufferB, offset: 0, index: 1)
        computeEncoder.setBuffer(bufferResult, offset: 0, index: 2)
        
        // Set up thread groups and dispatch them
        let threadExecutionWidth = pipelineState.threadExecutionWidth
        let threadsPerGroup = MTLSize(width: threadExecutionWidth, height: 1, depth: 1)
        let numThreadgroups = MTLSize(width: (arrayA.count + threadExecutionWidth - 1) / threadExecutionWidth, height: 1, depth: 1)
        computeEncoder.dispatchThreadgroups(numThreadgroups, threadsPerThreadgroup: threadsPerGroup)

        // Set the threadgroup size and call the compute encoder

        computeEncoder.endEncoding()

        // Commit the command buffer and wait for it to complete
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        // Read the result from the buffer
        memcpy(&result, bufferResult!.contents(), result.count * MemoryLayout<Float>.stride)

        // Print the result
        // print("Sum of arrays: \(result)")
        return result

    }
    
    
}
