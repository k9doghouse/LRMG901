//
//  DrawChart.swift
//  DrawChart
//
//  Thanks to: SchwiftyUI
//  Copyleft 2020. All rights absurd.
//

import SwiftUI

extension Color {
  static let greenish = Color(red: 103/255, green: 183/255, blue: 164/255)
  static let whiteish = Color(red: 208/255, green: 208/255, blue: 208/255)
  static let blackish = Color(red: 30/255, green: 32/255, blue: 36/255)
}

struct DrawChart: View {
  @State var textColor = Color.black
  @State var screenColor = Color.black
  @State var buttonOffset = 0.0
  @State var degreesLoaded = 0.0

  var body: some View {
    ZStack {
      Border().fill(Color.greenish)
      Screen().fill(screenColor)
      Box(animatableData: buttonOffset).fill(Color.greenish)
    }
  } // END: BODY
} // END: STRUCT(logo drawing)

struct Border: Shape {
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
    path.addLine(to: CGPoint(x: 0, y: 50))

    let scale = (rect.width / 350) * (9 / 10)
    let xoffset = (rect.width * (1/10))/2
    let yoffset = (rect.height - rect.height * scale) * (1/10) / 2

    return path.applying(CGAffineTransform(scaleX: scale,
                                                y: scale))
      .applying(CGAffineTransform(translationX: xoffset,
                                             y: yoffset))
  }
}

struct Screen: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: 10, y: 40))
    path.addQuadCurve(to: CGPoint(x: 40, y: 10), control: CGPoint(x: 10, y: 10))
    path.addLine(to: CGPoint(x: 310, y: 10))
    path.addQuadCurve(to: CGPoint(x: 340, y: 40), control: CGPoint(x: 340, y: 10))
    path.addLine(to: CGPoint(x: 340, y: 210))
    path.addQuadCurve(to: CGPoint(x: 310, y: 240), control: CGPoint(x: 340, y: 240))
    path.addLine(to: CGPoint(x: 40, y: 240))
    path.addQuadCurve(to: CGPoint(x: 10, y: 210), control: CGPoint(x: 10, y: 240))
    path.addLine(to: CGPoint(x: 10, y: 40))

    let scale = (rect.width / 350) * (9 / 10)
    let xoffset = (rect.width * (1/10))/2
    let yoffset = (rect.height - rect.height * scale) * (1/10) / 2

    return path.applying(CGAffineTransform(scaleX: scale,
                                                y: scale))
      .applying(CGAffineTransform(translationX: xoffset,
                                             y: yoffset))
  }
}

struct Box: Shape {
  fileprivate let levelArray = [-24, -9.5, -1, 1.5, 2.6, 8.1, 8.9, 12.4, 15, 28.2, 72]
  fileprivate let room = 28

  func path(in rect: CGRect) -> Path {
    var path = Path()

    for indx in 0..<levelArray.count {
        path.addRoundedRect(in: CGRect(x: 20 + (room*indx),
                                       y: 75,
                                   width: 22,
                                  height: Int(CGFloat(levelArray[indx]))*2),
                              cornerSize: CGSize(width: 3,
                                                height: 3))
      } // END: FOR(indx)

    let scale = (rect.width / 340) * (9 / 10)
    let xoffset = (rect.width * (1/11))/2
    let yoffset = (rect.height - rect.height * scale) * (1/11) / 2

    return path.applying(CGAffineTransform(scaleX: scale,
                                                y: scale))
      .applying(CGAffineTransform(translationX: xoffset,
                                             y: yoffset))
  }
  var animatableData: Double
}

struct LogoDrawing_Previews: PreviewProvider {
  static var previews: some View {
    DrawChart()
  }
}




















/*
 struct LoadingBar: Shape {
 func path(in rect: CGRect) -> Path {
 var path = Path()

 path.addArc(center: CGPoint(x: 350/2,
 y: 350/2),
 radius: 350/4,
 startAngle: Angle(degrees: 0),
 endAngle: Angle(degrees: animatableData),
 clockwise: false)

 let scale = (rect.width / 350) * (9 / 10)
 let xoffset = (rect.width * (1/10))/2
 let yoffset = (rect.height - rect.height * scale) * (1/10) / 2

 return path.applying(CGAffineTransform(scaleX: scale,
 y: scale))
 .applying(CGAffineTransform(translationX: xoffset,
 y: yoffset))
 }
 var animatableData: Double
 }
 */
