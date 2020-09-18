//
//  https://github.com/k9doghouse/LRMG901.git
//
//  AppData.swift
//  LMRG901
//
//  Created by murph on 9/8/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import UIKit
import SwiftUI

extension String {
  var lines: [String] {
    var result: [String] = []
    enumerateLines { line, _ in result.append(line) }
    return result
  }
} // END: EXTENSION

// MARK: MODEL
struct Station {
  var stationName: String
  var stationFlood: String
  var obsDateTime: String
  var levelZero: String
  var levelDelta: String
  var levelOne: String
  var levelTwo: String
  var levelThree: String
  var levelFour: String
  var levelFive: String
}

// MARK: VIEW MODEL
struct StationViewModel: Identifiable {
  var id = UUID()
  var station: Station

  var stationName: String   { return station.stationName }
  var stationFlood: String  { return station.stationFlood }
  var obsDateTime: String   { return station.obsDateTime }
  var levelZero: String     { return station.levelZero }
  var levelDelta: String    { return station.levelDelta }
  var levelOne: String      { return station.levelOne }
  var levelTwo: String      { return station.levelTwo }
  var levelThree: String    { return station.levelThree }
  var levelFour: String     { return station.levelFour }
  var levelFive: String     { return station.levelFive }
}

// MARK: INTENTS - Get Data from web page; format, assemble, and write the data
class AppData: ObservableObject {
  @Published var userData: [StationViewModel] = []

  // < - - - Constants & Variables - - - >
  var spacesInt: Int = 0

  // MARK: NO API KEY REQUIRED
  // MARK: FOR FUTURE ENHANCEMENTS
  //  let observedURL: String = "https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=memt1&output=tabular&time_zone=cdt"
  let riverURL: String = "https://forecast.weather.gov/product.php?site=NWS&issuedby=ORN&product=RVA&format=TXT&version=1&glossary=0"

  var riverGauges: Array   = [[String]]()
  var line: String         = "line with station data"

  // MARK: INIT VARS FOR VIEW MODEL
  var stationName: String  = "MEMPHIS"
  var stationFlood: String = "34"
  var obsDateTime: String  = "time"
  var levelZero  = "0"
  var levelDelta = "D"
  var levelOne   = "1"
  var levelTwo   = "2"
  var levelThree = "3"
  var levelFour  = "4"
  var levelFive  = "5"

  //MARK: TEMP VARS FOR CUSTOMIZING VALUES
  var lines: [String] = []
  var words: [String] = []
  var timeOfObservation: String = ""

  // MARK: VARS FOR STATION DATA ELEMENTS
  var zeroInt: Int  = 2
  var deltaInt: Int = 3
  var oneInt: Int   = 4
  var twoInt: Int   = 5
  var threeInt: Int = 6
  var fourInt: Int  = 7
  var fiveInt: Int  = 8

  // MARK: CONSTANTS MATCHING WEB PAGE RESULT
  let stationArray: Array = ["CAPE GIRARDEAU", "NEW MADRID", "TIPTONVILLE", "CARUTHERSVILLE", "OSCEOLA",
                             "MEMPHIS", "MHOON LANDING", "HELENA", "ARKANSAS CITY", "GREENVILLE",
                             "VICKSBURG", "NATCHEZ", "RED RIVER LNDG", "BATON ROUGE", "DONALDSONVILLE", "RESERVE", "NEW ORLEANS"]

  let floodArray: Array = ["32", "34", "37", "32", "28", "34", "30", "44", "37", "48", "43", "48", "48", "35", "27", "22", "17"]
  let up: String   = "↑"        // "⬆️"
  let down: String = "↓"        // "⬇️"
  // MARK: INTENT(S) Get Data from web page; format, assemble, and write the data
  func fetchData() {
    if let url: URL = URL(string: riverURL) {
      do {
        let content: String = try String(contentsOf: url)
        let rivDat: String = String(content)

        // NOTE: regex for time the river gauge was observed: 0929AM, 1929PM, 2329PM
        let regex: NSRegularExpression = try NSRegularExpression(pattern: "(?:((0|1|2)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(A|P)M).*)")
        for match in regex.matches(in: rivDat, range: NSRange(0..<rivDat.utf16.count)) {

          // MARK: Date/Time of River level observation
          let lineRange: NSRange = match.range(at: 1)
          let line = lineRange.location != NSNotFound ? (rivDat as NSString).substring(with: lineRange): nil
          let spaces: String = line!

          // MARK: CLOSURE RIV DAT
          rivDat.enumerateLines { line, _ in
            if line.hasPrefix(spaces) {
              // MARK: FIX ALL-CAPS (obsDateTime) FROM WEB PAGE
              // MARK: 1005AM CDT SAT SEP 12 2020 becomes --> Sat Sep 12 2020 @ 1005am CDT
              self.obsDateTime = "\(line)"

              // MARK: BREAK DOWN THE STRING; FIX CASES FROM WEB PAGE
              if self.obsDateTime.hasPrefix(spaces) {
                let wordsInLine = line
                let words = wordsInLine.split(separator: " ")
                let word0 = words[0].lowercased() // time digits with am/pm
                let word1 = words[1]              // time zone characters
                let word2 = words[2].capitalized  // day of the week chars
                let word3 = words[3].capitalized  // month characters
                let word4 = words[4]              // day digits
                let word5 = words[5]              // year digits
                self.timeOfObservation = String("\(word2) \(word3) \(word4) \(word5) @ \(word0) \(word1)")
              } else { return }
            } // END: IF-ELSE

            // <- - fill the list with station data - ->
            for indexInt in 0..<self.stationArray.count {
              if line.contains("LEVEES") {
                // MARK:  in Swift, you can use a break statement to match and ignore a particular case
                break
              }

              // MARK: Only get lines with station-data as text
              if line.contains("\(self.stationArray[indexInt])") {
                self.lines.append(line)
                let currentLine: String = self.lines[indexInt]
                let currentRiverGauge: Array = currentLine.split(separator: " ", maxSplits: 16, omittingEmptySubsequences: true)
                let firstWord: ArraySlice = currentRiverGauge[...]

                // MARK: NO JSON; PARSE LINES OF PLAIN TEXT
                switch firstWord[self.spacesInt] {

                  // city name has 2 spaces
                  case "RED":
                    self.zeroInt   = 4
                    self.deltaInt  = 5
                    self.oneInt    = 6
                    self.twoInt    = 7
                    self.threeInt  = 8
                    self.fourInt   = 9
                    self.fiveInt   = 10

                  // city names has 1 space
                  case "NEW", "CAPE", "MHOON", "ARKANSAS", "BATON":
                    self.zeroInt   = 3
                    self.deltaInt  = 4
                    self.oneInt    = 5
                    self.twoInt    = 6
                    self.threeInt  = 7
                    self.fourInt   = 8
                    self.fiveInt   = 9

                  // city names having no spaces
                  default:
                    self.zeroInt   = 2
                    self.deltaInt  = 3
                    self.oneInt    = 4
                    self.twoInt    = 5
                    self.threeInt  = 6
                    self.fourInt   = 7
                    self.fiveInt   = 8
                } // END: SWITCH

                // MARK: GATHER DATA
                self.stationName  = self.stationArray[indexInt]
                self.stationFlood = "floods @ \(self.floodArray[indexInt])ft"
                self.obsDateTime  = self.timeOfObservation
                self.levelOne     = String(firstWord[self.oneInt])
                self.levelZero    = String(firstWord[self.zeroInt])

                // MARK:  When observing station has an error
                if firstWord[self.zeroInt].hasSuffix("E")  { self.levelZero = String("err ") }
                self.levelDelta   = "\(String(firstWord[self.deltaInt]))ft "

                // MARK: When observing station has an error
                if firstWord[self.deltaInt]           == "MSG" { self.levelDelta = String("err ") }

                // MARK: add directional signs to the CHANGE/DELTA TextView
                if firstWord[self.deltaInt].prefix(1) == "+"   { self.levelDelta = self.levelDelta.dropFirst() + self.up }
                if firstWord[self.deltaInt].prefix(1) == "-"   { self.levelDelta = self.levelDelta.dropFirst() + self.down }

                self.levelTwo     = String(firstWord[self.twoInt])
                self.levelThree   = String(firstWord[self.threeInt])
                self.levelFour    = String(firstWord[self.fourInt])
                self.levelFive    = String(firstWord[self.fiveInt])

                // MARK: WRITE DATA TO APP-DATA IF < 17
                if self.userData.count <= self.stationArray.count-1 {
                  self.userData.append(StationViewModel(station: Station(stationName:  self.stationName,
                                                                stationFlood: self.stationFlood,
                                                                obsDateTime:  self.obsDateTime,
                                                                levelZero:    self.levelZero,
                                                                levelDelta:   self.levelDelta,
                                                                levelOne:     self.levelOne,
                                                                levelTwo:     self.levelTwo,
                                                                levelThree:   self.levelThree,
                                                                levelFour:    self.levelFour,
                                                                levelFive:    self.levelFive)))
                } // END: IF(count)
              } // END: IF(line)
            } // END: FOR
          } // END: CLOSURE(enumerate)
        } // END: FOR MATCH
      } catch { print("\ncontents could not be loaded.\n") } // END: CATCH(do)
    } else { print("\nthe URL was bad!\n") }  // END: ELSE
  } // END: FUNC
} // END: CLASS

