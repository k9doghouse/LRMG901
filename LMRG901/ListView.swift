//
//  https://github.com/k9doghouse/LRMG901.git
//
//  ListView.swift
//  LMRG901
//
//  Created by murph on 9/8/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import SwiftUI

struct ListView: View {
  @EnvironmentObject var appData: AppData
  @State private var selectedLink: UUID? = nil
  
  private let monoLight: String = "SFMono-Light.otf"
  private let lightFont: String = "Avenir Next Ultra Light"
  private let regrFont: String  = "Avenir Next Regular"
  private let condLight: String = "Avenir Next Condensed Ultra Light"
  private let bgColor : String  = "BackgroundColor"
  private let fntSize:  CGFloat = 20
  private let rowHgt:   CGFloat = 40
  
  var body: some View {
    NavigationView {
      List {
        ForEach(appData.userData) { station in
          NavigationLink(destination: DetailView(station: station), tag: station.id, selection: self.$selectedLink) {
            HStack {
              Text(station.stationName.capitalized)
              Spacer()
              Text(station.stationFlood)
            } // END HSTACK
            .font(.custom(regrFont, size: fntSize))
          } // END: NAV-LINK
        } // END: FOR-EACH
      } // END: LIST
      .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
      .listRowBackground(Color(bgColor))
      .listStyle(GroupedListStyle())
      .environment(\.defaultMinListRowHeight, 40)
      .onAppear(perform: appData.fetchData)

      // MARK: FOR FUTURE ENHANCEMENT
      //        .onAppear(perform: appData.getObserved)

      .onAppear { UITableView.appearance().separatorStyle = .none }
      .navigationBarTitle("Stations", displayMode: .large)
    } //END: NAV VIEW
  } // END: BODY
} // END: STRUCT


