//
//  https://github.com/k9doghouse/LRMG901.git
//
//  DetailView.swift
//  LMRG901
//
//  Created by murph on 9/11/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import SwiftUI

struct DetailView: View {
  let station: StationViewModel
  let monoLight = "SFMono-Light.otf"
  let lightFont = "Avenir Next Ultra Light"
  let regrFont  = "Avenir Next Regular"
  let condRegr  = "Avenir Next Condensed Regular"
  let tungsten = "TungstenColor"
  let padSml: CGFloat = 12.0
  let padMed: CGFloat = 18.0
  let padLrg: CGFloat = 40.0
  let fntTny: CGFloat = 16.0
  let fntSml: CGFloat = 18.0
  let fntMed: CGFloat = 20.0
  let fntBig: CGFloat = 30.0
  let fntLrg: CGFloat = 40.0
  let dimmer: Double  = 0.70

  var body: some View {
    VStack(alignment: .center) {
      // 0
      Group {
        HStack(alignment: .center) {
          Spacer()
          Text("\(station.stationName)"); Spacer()
        } // END: HSTACK
        .font(.custom(condRegr, size: fntLrg))
        HStack {
          Spacer()
          Text("Today  \(station.levelZero)ft")
          Spacer()
        } // END: HSTACK
        .font(.custom(condRegr, fixedSize: fntBig))
        VStack {
          Text("\(Text(station.stationFlood))")
          Text("Change from previous \(station.levelDelta)")
          Divider()
            .font(.custom(condRegr, size: fntSml))
            .padding(.horizontal, padLrg)
        } // END VSTACK
      } // END: GROUP 0

      // 1
      Group {
        HStack {
          Spacer()
          Text("Five Day Forecast")
            .fontWeight(.light)
          //            .padding(.top, padSml)
          Spacer()
        } // END: VSTACK
      } // END: GROUP 1

      // 2
      Group {
        VStack(alignment: .leading) {
          HStack {
            Text("One day after");Spacer()
            Text("\(station.levelOne)ft")
              .multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Two days after");Spacer()
            Text("\(station.levelTwo)ft")
              .multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Three days after");Spacer()
            Text("\(station.levelThree)ft")
              .multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Four days after");Spacer()
            Text("\(station.levelFour)ft")
              .multilineTextAlignment(.trailing)
          }
          HStack {
            Text("Five days after");Spacer()
            Text("\(station.levelFive)ft")
              .multilineTextAlignment(.trailing)
          }
          Spacer()
        } // END: VSTACK
        .font(.custom(condRegr, size: fntMed))
        .padding(.horizontal, padMed+padLrg)
      } // END: GROUP 2

      // MARK: PUSH UP
      Spacer()
    } // END: VSTACK(main)
    .font(.custom(regrFont, size: fntMed))
    .minimumScaleFactor(0.5)
    .lineLimit(1)
    .padding()
    .navigationBarTitle("\(station.obsDateTime)", displayMode: .inline).lineLimit(1)
  } // END: BODY
} // END: STRUCT
