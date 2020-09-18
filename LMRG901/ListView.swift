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
  
  var monoLight = "SFMono-Light.otf"
  var lightFont = "Avenir Next Ultra Light"
  var regrFont  = "Avenir Next Regular"
  var condLight = "Avenir Next Condensed Ultra Light"
  var bgColor   = "BackgroundColor"
  
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
          } // END: NAV-LINK
        } // END: FOR-EACH
      } // END: LIST
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .listRowBackground(Color(bgColor))
        .listStyle(GroupedListStyle())
        .environment(\.defaultMinListRowHeight, 32)
        .onAppear(perform: appData.fetchData)
        
        // MARK: FOR FUTURE ENHANCEMENT
        //        .onAppear(perform: appData.getObserved)
        
        .onAppear { UITableView.appearance().separatorStyle = .none }
        .navigationBarTitle("Stations", displayMode: .large)
    } //END: NAV VIEW
  } // END: BODY
} // END: STRUCT


