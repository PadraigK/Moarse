//
//  Morse.swift
//  Moarse
//
//  Created by Padraig O Cinneide on 2021-10-31.
//

import Foundation

enum Morse {
  static let morseMap: [String: [Character]] = alphabetMap.swapKeyValues()
  
  static let alphabetMap: [[Character]: String] = [
    [.dot, .dash]: "A",
    [.dash, .dot, .dot, .dot]: "B",
    [.dash, .dot, .dash, .dot]: "C",
    [.dash, .dot, .dot]: "D",
    [.dot]: "E",
    [.dot, .dot, .dash, .dot]: "F",
    [.dash, .dash, .dot]: "G",
    [.dot, .dot, .dot, .dot]: "H",
    [.dot, .dot]: "I",
    [.dot, .dash, .dash, .dash]: "J",
    [.dash, .dot, .dash]: "K",
    [.dot, .dash, .dot, .dot]: "L",
    [.dash, .dash]: "M",
    [.dash, .dot]: "N",
    [.dash, .dash, .dash]: "O",
    [.dot, .dash, .dash, .dot]: "P",
    [.dash, .dash, .dot, .dash]: "Q",
    [.dot, .dash, .dot]: "R",
    [.dot, .dot, .dot]: "S",
    [.dash]: "T",
    [.dot, .dot, .dash]: "U",
    [.dot, .dot, .dot, .dash]: "V",
    [.dot, .dash, .dash]: "W",
    [.dash, .dot, .dot, .dash]: "X",
    [.dash, .dot, .dash, .dash]: "Y",
    [.dash, .dash, .dot, .dot]: "Z",

    [.dot, .dash, .dash, .dot, .dash, .dot]: "@",
    [.dot, .dash, .dot, .dash, .dot, .dash]: ".",
    [.dot, .dot, .dash, .dash, .dot, .dot]: "?",

    [.dot, .dash, .dash, .dash, .dash]: "1",
    [.dash, .dash, .dash, .dash, .dot]: "2",
    [.dot, .dot, .dot, .dash, .dash]: "3",
    [.dot, .dot, .dot, .dot, .dash]: "4",
    [.dot, .dot, .dot, .dot, .dot]: "5",
    [.dash, .dot, .dot, .dot, .dot]: "6",
    [.dash, .dash, .dot, .dot, .dot]: "7",
    [.dash, .dash, .dash, .dot, .dot]: "8",
    [.dot, .dot, .dash, .dash, .dash]: "9",
    [.dash, .dash, .dash, .dash, .dash]: "0",
  ]

  enum Character: CustomStringConvertible {
    case dot
    case dash
    case space

    var description: String {
      switch self {
      case .dot:
        return "●"
      case .dash:
        return "—"
      case .space:
        return " "
      }
    }
  }
}


extension Dictionary where Value: Hashable {
  func swapKeyValues() -> [Value: Key] {
    assert(Set(values).count == keys.count, "Values must be unique")
    var newDict = [Value: Key]()
    for (key, value) in self {
      newDict[value] = key
    }
    return newDict
  }
}

