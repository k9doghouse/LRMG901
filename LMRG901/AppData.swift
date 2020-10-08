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
  var lines1: [String] {
    var result1: [String] = []
    enumerateLines { line1, _ in result1.append(line1) }
    return result1
  } // END: VAR RESULT-1
} // END: EXTENSION-1

struct Entry: Codable {
  var line1: String
}

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
  var minusOne: String
  var minusTwo: String
  var minusThree: String
  var minusFour: String
  var minusFive: String
}

// MARK: VIEW MODEL
struct StationViewModel: Identifiable {
  var id = UUID()
  var station: Station

  var stationName: String  { return station.stationName }
  var stationFlood: String { return station.stationFlood }
  var obsDateTime: String  { return station.obsDateTime }
  var levelZero: String    { return station.levelZero }
  var levelDelta: String   { return station.levelDelta }
  var levelOne: String     { return station.levelOne }
  var levelTwo: String     { return station.levelTwo }
  var levelThree: String   { return station.levelThree }
  var levelFour: String    { return station.levelFour }
  var levelFive: String    { return station.levelFive }
  var minusOne: String     { return station.minusOne }
  var minusTwo: String     { return station.minusTwo }
  var minusThree: String   { return station.minusThree }
  var minusFour: String    { return station.minusFour }
  var minusFive: String    { return station.minusFive }
}

// MARK: INTENTS - Get Data from web page; format, assemble, and write the data
class AppData: ObservableObject {
  @Published var userData: [StationViewModel] = []

  // < - - - Constants & Variables - - - >
  private var spacesInt: Int = 0

  // MARK: NO API KEY REQUIRED
  private let riverURL: String = "https://forecast.weather.gov/product.php?site=NWS&issuedby=ORN&product=RVA&format=TXT&version=1&glossary=0"

  private var riverGauges: Array   = [[String]]()
  private var line: String         = "line with station data"

  // MARK: INIT VARS FOR VIEW MODEL
  private var stationName: String  = "MEMPHIS"
  private var stationFlood: String = "34"
  private var obsDateTime: String  = "time"
  private var levelZero  = "0"
  private var levelDelta = "D"
  private var levelOne   = "1"
  private var levelTwo   = "2"
  private var levelThree = "3"
  private var levelFour  = "4"
  private var levelFive  = "5"
  private var minusOne   = "-1"
  private var minusTwo   = "-2"
  private var minusThree = "-3"
  private var minusFour  = "-4"
  private var minusFive  = "-5"

  //MARK: TEMP VARS FOR CUSTOMIZING VALUES
  private var lines: [String] = []
  private var words: [String] = []
  private var timeOfObservation: String = ""

  // MARK: VARS FOR FORECAST DATA
  private var historyArray: [String] = []

  // MARK: VARS FOR STATION DATA ELEMENTS
  private var zeroInt:  Int = 2
  private var deltaInt: Int = 3
  private var oneInt:   Int = 4
  private var twoInt:   Int = 5
  private var threeInt: Int = 6
  private var fourInt:  Int = 7
  private var fiveInt:  Int = 8

  // MARK: CONSTANTS MATCHING WEB PAGE RESULT
  private let stationArray: Array = ["CAPE GIRARDEAU", "NEW MADRID", "TIPTONVILLE", "CARUTHERSVILLE", "OSCEOLA",
                                     "MEMPHIS", "MHOON LANDING", "HELENA", "ARKANSAS CITY", "GREENVILLE",
                                     "VICKSBURG", "NATCHEZ", "RED RIVER LNDG", "BATON ROUGE", "DONALDSONVILLE",
                                     "RESERVE", "NEW ORLEANS"]

  private let floodArray: Array = ["32", "34", "37", "32", "28", "34", "30", "44", "37",
                                   "48", "43", "48", "48", "35", "27", "22", "17"]
  private let up: String   = "↑"
  private let down: String = "↓"
  
  // MARK: INTENT(S) Get Data from web page; format, assemble, and write the data
  func fetchRivData() {
    if let url: URL = URL(string: riverURL) {
      do {
        let content: String = try String(contentsOf: url)
        let rivDat: String = String(content)

        historyArray = fetchObsData(gauge: "memt1")

        minusOne   = historyArray[0]
        minusTwo   = historyArray[1]
        minusThree = historyArray[2]
        minusFour  = historyArray[3]
        minusFive  = historyArray[4]

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
                self.stationFlood = self.floodArray[indexInt]
                self.obsDateTime  = self.timeOfObservation
                self.levelOne     = String(firstWord[self.oneInt])
                self.levelZero    = String(firstWord[self.zeroInt])

                // MARK:  When observing station has an error
                if firstWord[self.zeroInt].hasSuffix("E")  { self.levelZero = String("err ") }
                self.levelDelta   = "\(String(firstWord[self.deltaInt]))ft "

                // MARK: When observing station has an error
                if firstWord[self.deltaInt].contains("MSG") { self.levelDelta = String("err ") }

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
                                                                         levelFive:    self.levelFive,
                                                                         minusOne:     self.minusOne,
                                                                         minusTwo:     self.minusTwo,
                                                                         minusThree:   self.minusThree,
                                                                         minusFour:    self.minusFour,
                                                                         minusFive:    self.minusFive)))
                } // END: IF(count)
              } // END: IF(line)
            } // END: FOR
          } // END: CLOSURE(enumerate)
        } // END: FOR MATCH
      } catch { print("\ncontents could not be loaded.\n") } // END: CATCH(do)
    } else { print("\nthe URL was bad!\n") }  // END: ELSE
  } // END: FUNC

  // MARK: GET OBSERVED DATA FROM TABULAR WEB PAGE
  func fetchObsData(gauge: String) -> [String] {

    // <- - -  Constants and Variables  - - ->
    let urlFirstPart: String  = "https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage="
    let urlLastPart:  String  = "&output=tabular&time_zone=cdt"

    let urlGauges:   [String] = ["cpgm7", "nmdm7", "tptm7", "crtm7", "osga4","memt1", "mhom6",
                                 "heea4", "arsa4", "geem6", "vckm6", "ntzm6", "rrll1", "btrl1",
                                 "donl1", "rrvl1", "norl1"]

    var urlGagePart:  String  = "memt1"

    // Note: "https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=memt1&output=tabular&time_zone=cdt"
    // TODO: FIX THIS TO BE DYNAMIC - HARDCODED FOR NOW
    urlGagePart = urlGauges[5]
    let observedURL: String = String("\(urlFirstPart + urlGagePart + urlLastPart)")

    let start:  String = "<td nowrap>"
    let kcfs:   String = "<td nowrap>-999kcfs</td>"
    let dCDT:   String = "          <td nowrap>|Date(CDT)|</td>"
    let begin:  String = "  <td nowrap>"
    let stage:  String = "<td nowrap>|Stage|</td>"
    let flow:   String = "<td nowrap>|--Flow-|</td>"
    let oddStr: String = "this is to make the leve data an even index"
    let day:    Int    = 24

    var tempStr1:   String  = ""
    var footStr:    String  = ""
    var days:      [String] = []
    var allLevels: [String] = []
    var lines1:    [String] = []
    var levels:    [String] = []

    if let url1: URL = URL(string: observedURL) {
      do {
        let content1: String = try String(contentsOf: url1)
        let obsDat: String = String(content1)

        // MARK: SETUP
        obsDat.enumerateLines { line1, _ in
          if line1.contains(start)
              && !line1.contains(kcfs)
              && !line1.contains(dCDT)
              && !line1.contains(stage)
              && !line1.contains(flow) {
            lines1.append(line1)
          } // END: IF(start)
        } // END: ENUMERATE(line1)

        // MARK: MANIPULATE "LINES1" SO THAT "LEVELS" IS A MULTIPLE OF 2
        lines1.insert(String(oddStr), at: 0)
        // END: MANIPULATE (lines)  // END: SETUP

        // MARK: LEVELS
        allLevels = lines1.enumerated().compactMap { tuple in
          tuple.offset.isMultiple(of: 2) ? tuple.element : nil
        }

        for (_,item1) in allLevels.enumerated() {
          if item1 != oddStr {
            if item1.contains(begin) {
              tempStr1 = String(item1.dropFirst(13))
              footStr =  String(tempStr1.dropLast(5))

              // MARK: PAST LINE 120 GOES INTO THE FORECAST TABLE
              if levels.count <= 119 {
                levels.append(footStr)
              } // END: IF
            } // END: IF(item1.contains)
          } // END: IF(item1 !=)
        } // END: FOR(idx, item1)  // MARK: END(levels)

        // MARK: MANIPULATE "LINES" BACK TO ORIGINAL CONFIGURATION
        if lines1.first == oddStr {
          lines1.removeFirst()
        } // END: IF(lines.first == oddStr)
        // MARK: END FIX(lines)

        // MARK: BUILD ARRAY OF THE PAST 5 DAYS OF OBSERVATION(averaged)
        var tempStr1:   String = ""
        var tempDub:    Double = 0
        var startIndex: Int    = 0

        for n in 1...5 {
          for idx1 in startIndex..<day*n {
            tempStr1 = String(levels[idx1].dropLast(2))
            tempDub += Double(tempStr1) ?? 0.0
            tempStr1 = String(format: "%.1f", tempDub/24.0)
          } // END: FOR(idx)
          days.append(tempStr1)
          startIndex += day
          tempDub = 0
        } // END: FOR(n)
      } catch {
        print("\ncontents could not be loaded.\n")
      } // END: CATCH(do)
    } else {
      print("\nthe URL was bad!\n")
    }  // END: ELSE
    return days
  }
} // END: CLASS

