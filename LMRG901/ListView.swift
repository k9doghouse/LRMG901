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

  private let regrFont: String  = "Avenir Next Regular"
  private let bgColor : String  = "BackgroundColor"
  private let fntSize:  CGFloat = 20
  private let rowHgt:   CGFloat = 48
  private let zipPad:     CGFloat = 0
  private let medPad:   CGFloat = 20
  
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
      .listRowInsets(EdgeInsets(top: zipPad, leading: medPad, bottom: zipPad, trailing: medPad))
      .listRowBackground(Color(bgColor))
      .listStyle(GroupedListStyle())
      .environment(\.defaultMinListRowHeight, rowHgt)
      .onAppear(perform: appData.fetchData)

      // MARK: FOR FUTURE ENHANCEMENT
      //        .onAppear(perform: appData.getObserved)

      .onAppear { UITableView.appearance().separatorStyle = .none }
      .navigationBarTitle("Stations", displayMode: .large)
    } //END: NAV VIEW
  } // END: BODY
} // END: STRUCT



struct ListView_Previews: PreviewProvider {
  static var previews: some View {
    ListView().environmentObject(AppData())
  }
}
