//
//  main.swift
//  ArithmeticPermutations
//
//  Created by Imran on 1/22/16.
//  Copyright © 2016 Fazle Rab. All rights reserved.
//

/*
 * Arithmetic Permutations
 * -----------------------
 * Given a string of number, generate all possible scenarios where
 * breaking the string in various substrings and applying various
 * operators (+,	-,	/,	*) will evaluate to the sum provided.
 * String should stay in the same order;
 */

import Foundation

let operatorSymbols:[String] = ["", "+", "-", "/", "*"] // empty string represents 'no-operator'
var count = 0

// Function that evalutes the expression and checks if it satisfies the expected result
func evalute(expression:String, withExpectedResult expectedResult:Double) -> String? {
    // Get the operator symbols in the expression, by spliting it using number as delimiter
    // The split causes empty strings for multi-digit number, so filter out the empty strings
    var expressionOperators = expression
        .componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
        .filter { (oprtr) -> Bool in oprtr != "" }
    
    // Add '=' as a first element, so that the operation performed on the first term 
    // or the only term of the expression is assignment
    expressionOperators.insert("=", atIndex: 0)
    var index:Int = 0 // index to iterate the operators to apply to each terms of the expression
    
    // Evaulate the expression by first spliting the expression using arithmetic operators as delimiters
    // Then using the mapping function to convert the number strings to double values
    // Finally, using the reduce function to evalute the expression
    let operatorCharacterSet = NSCharacterSet(charactersInString: "+-/*")
    let evalutedResult:Double = expression
        .componentsSeparatedByCharactersInSet(operatorCharacterSet)
        .map { (numString) -> Double in Double(numString)! }
        .reduce(0.0) { (var result, term) -> Double in
            switch expressionOperators[index++] {
                case "=": result = term
                case "+": result += term
                case "-": result -= term
                case "/": result /= term
                case "*": result *= term
                default: break
            }
            return result
    }
    print("\(++count):\t\(expression) = \(evalutedResult)")
    return evalutedResult == expectedResult ? expression : nil
}

// Recursive function to finds the expression that satisfies the given result
func findArithmeticExpressionsOf(var numString:String, thatEvaluatesTo expectedResult:Double, startingIndex index:Int, inout foundExpressions:[String]) {
    
    // End conditon of this recursion, index has reahed the last digit of numString
    // An expression is complet, so evaluate it and if it satisfies expectedResult, add it to foundExpressions
    if numString.startIndex.advancedBy(index) == numString.endIndex.predecessor() {
        if let found = evalute(numString, withExpectedResult:expectedResult) {
            foundExpressions.append(found)
        }
        return
    }
    
    // Repeat for every operator by inserting it after the current digit and call itself on the following sub-string
    // Empty string represent 'no-operator' for a case where the number sub-string is more then one digit
    for op:String in operatorSymbols {
        if op != "" {
            // insert operator
            let i = numString.startIndex.advancedBy(index + 1)
            numString.insert(Character(op), atIndex:i)
        }
        
        // call itself to permutate over the sub-string following the operator
        let nextIndex = (op == "") ? index + 1 : index + 2
        findArithmeticExpressionsOf(numString, thatEvaluatesTo:expectedResult, startingIndex:nextIndex, foundExpressions:&foundExpressions)
        
        // On return, remove the inserted operator
        if op != "" {
            let i = numString.startIndex.advancedBy(index + 1)
            numString.removeAtIndex(i)
        }
    }
    
    return
}

// Function that setup and calls the recursive function findArithmeticExpressionsOf
func findArithmeticExpressionsOf(numberString:String, thatEvaluatesTo expectedResult:Double) -> [String] {
    var foundExpressions:[String] = []
    findArithmeticExpressionsOf(numberString, thatEvaluatesTo:expectedResult, startingIndex:0, foundExpressions: &foundExpressions);
    return foundExpressions;
}




let expressions:[String] = findArithmeticExpressionsOf("31426", thatEvaluatesTo:51)
print("\n")
if expressions.isEmpty {
    print("There are no arithmetic permutation of '31426' that evaluates to 51")
}

for expression in expressions {
    print("\(expression) evaluates to 51")
}
