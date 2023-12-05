//
//  ContentView.swift
//  sharedprogramingcalculation
//
//  Created by Monali Palhal on 05/12/23.
//

import SwiftUI

struct ContentView: View {
    @State var swiftresult : Float = 0
    @State var metalresult : Float = 0
    @State var swiftTime : Double = 0
    @State var metalTime : Double = 0
    @State var Legthofarray : String = ""
    

    var body: some View {
        VStack {
            
            Text("Array Summation Comparison")
                .font(.largeTitle)
                .padding()
            HStack{
                Spacer()
                Text("Enter legth of Array : ")
                    .font(.title2)
                TextField("Input Array Length", text: $Legthofarray).frame(alignment: .center).font(.title3)
                    .padding(.all,8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding([.vertical,.trailing])
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                Spacer()
            }.frame(alignment: .center).padding(.all)
            

            // Display Metal shader result and time
            Text("Metal Shader Result:")
            
            
           
            Text("Time: \(metalTime.formatted()) seconds")
                .padding()

            // Display Swift method result and time
            Text("Swift Result:")
            
            Text("Time: \(swiftTime.formatted()) seconds")
                .padding()
            
            
            Button(action: {
              
                print("Int(Legthofarray)",Int(Legthofarray))
                let arrayProcessor = ArrayProcessor(count: Int(Legthofarray) ?? 0)

                let metalResult = arrayProcessor.measureExecutionTime {
                    arrayProcessor.sumTwoArrayWithMetalShader()
                }
                metalTime = metalResult.time

                let swiftResult = arrayProcessor.measureExecutionTime {
                    arrayProcessor.sumOfTwoArrayWithSwift()
                }
                swiftTime = swiftResult.time
            }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10) 
                    }
                    .padding()
            
        }
    }
   
}

