//
//  https://github.com/k9doghouse/LRMG901.git
//  greenish = Color(red: 103/255, green: 183/255, blue: 164/255)
//
//  DetailView.swift
//  LMRG901
//
//  Created by murph on 9/11/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import SwiftUI

let blackish: String = "blackishColor"
let greenish: String = "greenishColor"
let bgColor:  String = "backgroundColor"

struct DetailView: View {
  let station: StationViewModel
  
  private let regrFont  = "Avenir Next Regular"
  private let condRegr  = "Avenir Next Condensed Regular"
  private let padSml: CGFloat = 12.0
  private let padMed: CGFloat = 20.0
  private let padLrg: CGFloat = 40.0
  private let fntMed: CGFloat = 20.0
  private let fntLrg: CGFloat = 40.0
  
  var body: some View {
    VStack(alignment: .center) {
      // 0
      Group {
        HStack(alignment: .center) {
          Spacer()
          Text("\(station.stationName)"); Spacer()
        }
        .font(.custom(condRegr, size: fntLrg))
        HStack {
          Spacer()
          Text("Today  \(station.levelZero)ft")
          Spacer()
        }
        .font(.custom(condRegr, size: fntMed))
        VStack {
          Text("Floods at \(station.stationFlood)ft")
            .font(.custom(condRegr, size: fntMed))
          Text("Change from previous \(station.levelDelta)")
            .font(.custom(condRegr, size: fntMed))
            .padding(.horizontal, padLrg)
            .padding(.bottom, padSml/2)
        }
      } // END: GROUP(0)
      // 1
      Group {
        HStack {
          Spacer()
          Text("Five Day Forecast")
            .fontWeight(.light)
          Spacer()
        }
      } // END: GROUP(1)
      // 2
      Group {
        VStack(alignment: .leading) {
          HStack {
            Text("One day after");Spacer()
            Text("\(station.levelOne)ft").multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Two days after");Spacer()
            Text("\(station.levelTwo)ft").multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Three days after");Spacer()
            Text("\(station.levelThree)ft").multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Four days after");Spacer()
            Text("\(station.levelFour)ft").multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Five days after");Spacer()
            Text("\(station.levelFive)ft").multilineTextAlignment(.trailing)
          }
        }
        .font(.custom(condRegr, size: fntMed))
        .padding(.horizontal, padMed+padLrg)
        .padding(.bottom, 4)
      } // END: GROUP(2)
      // 3
      Group {
        DrawChart(station: station)
      } // END: GROUP(3)
      Spacer() // MARK: PUSH UP
    } // END: VSTACK(main)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .font(.custom(regrFont, size: fntMed))
    .minimumScaleFactor(0.5)
    .lineLimit(1)
    .padding()
    .navigationBarTitle("\(station.obsDateTime)", displayMode: .inline).lineLimit(1)
  }
} // END: STRUCT(detail view)

  struct DrawChart: View {
    @State var screenColor = Color(bgColor)
    let station: StationViewModel
    var body: some View {
      ZStack {
        Screen().fill(screenColor).frame(maxWidth: .infinity, maxHeight: .infinity)
        Box(station: station).fill(Color(greenish))
        Label(station: station).offset(x: 0.0, y: 50).padding(.horizontal, 40)
      }
    }
  } // END: STRUCT(draw chart)

  struct Screen: Shape {
    func path(in rect: CGRect) -> Path {
      var path = Path()
      path.move(to: CGPoint(x: 0, y: 50))
      path.addQuadCurve(to: CGPoint(x: 50, y: 0), control: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: 300, y: 0))
      path.addQuadCurve(to: CGPoint(x: 350, y: 50), control: CGPoint(x: 350, y: 0))
      path.addLine(to: CGPoint(x: 350, y: 200))
      path.addQuadCurve(to: CGPoint(x: 300, y: 250), control: CGPoint(x: 350, y: 250))
      path.addLine(to: CGPoint(x: 50, y: 250))
      path.addQuadCurve(to: CGPoint(x: 0, y: 200), control: CGPoint(x: 0, y: 250))
      path.closeSubpath()//.addLine(to: CGPoint(x: 0, y: 50))
      let scale = (rect.width/350) * (9/10)
      let xoffset = (rect.width * (1/10))/2
      let yoffset = (rect.height - rect.height*scale) * (1/10)/2
      return path
        .applying(CGAffineTransform(scaleX: scale, y: scale))
        .applying(CGAffineTransform(translationX: xoffset,  y: yoffset))
    }
  } // END: STRUCT(screen)

  struct Box: Shape {
    let station: StationViewModel
    fileprivate let room = 28
    func path(in rect: CGRect) -> Path {
      let mFive  = Float(station.minusFive)?.rounded()  ?? 0
      let mFour  = Float(station.minusFour)?.rounded()  ?? 0
      let mThree = Float(station.minusThree)?.rounded() ?? 0
      let mTwo   = Float(station.minusTwo)?.rounded()   ?? 0
      let mOne   = Float(station.minusOne)?.rounded()   ?? 0
      let lZero  = Float(station.levelZero)?.rounded()  ?? 0
      let lOne   = Float(station.levelOne)?.rounded()   ?? 0
      let lTwo   = Float(station.levelTwo)?.rounded()   ?? 0
      let lThree = Float(station.levelThree)?.rounded() ?? 0
      let lFour  = Float(station.levelFour)?.rounded()  ?? 0
      let lFive  = Float(station.levelFive)?.rounded()  ?? 0
      let levelArray = [mFive, mFour, mThree, mTwo, mOne, lZero, lOne, lTwo, lThree, lFour, lFive]
      var path = Path()
      for indx in 0..<levelArray.count {
        path.addRoundedRect(in: CGRect(x: 20 + room*indx,
                                       y: 75,
                                   width: 22,
                                  height: Int(levelArray[indx])*2),
                cornerSize: CGSize(width: 3, height: 3))
      }
      let scale = (rect.width/340) * (9/10)
      let xoffset = (rect.width * (1/11))/2
      let yoffset = (rect.height - rect.height * scale) * (1/11)/2
      return path
        .applying(CGAffineTransform(scaleX: scale, y: scale))
        .applying(CGAffineTransform(translationX: xoffset, y: yoffset))
    }
  } // END: STRUCT(box)

struct Label: View {
  let station: StationViewModel

  var body: some View {
    let levelArray: [String] = [station.minusFive, station.minusFour, station.minusThree,
                                station.minusTwo, station.minusOne, station.levelZero,
                                station.levelOne, station.levelTwo, station.levelThree,
                                station.levelFour, station.levelFive]
    VStack {
      HStack {
        Spacer()
        Text("past")
          .foregroundColor(Color(.systemGray))
        Spacer()
        Text(" present")
          .foregroundColor(Color(greenish))
        Spacer()
        Text("future")
          .foregroundColor(.blue)
        Spacer()
      }
      .font(.caption)
      .opacity(0.5)
      HStack {
        // past
        Group {
          Text("\(levelArray[0])")
          Text("\(levelArray[1])")
          Text("\(levelArray[2])")
          Text("\(levelArray[3])")
          Text("\(levelArray[4])")
        }
        .foregroundColor(Color(.systemGray))
        // present
        Group {
          Text("\(levelArray[5])")
            .fontWeight(.semibold)
            .foregroundColor(Color(greenish))
        }
        // future
        Group {
          Text("\(levelArray[6])")
          Text("\(levelArray[7])")
          Text("\(levelArray[8])")
          Text("\(levelArray[9])")
          Text("\(levelArray[10])")
        }.foregroundColor(.blue)
      }
      .font(.caption)
    }
  }
} // END: STRUCT(label)

