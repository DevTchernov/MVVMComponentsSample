// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  typealias Color = UIColor
#elseif os(OSX)
  import AppKit.NSColor
  typealias Color = NSColor
#endif

extension Color {
  convenience init(rgbaValue: UInt32) {
    let red = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue = CGFloat((rgbaValue >> 8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

// swiftlint:disable file_length
// swiftlint:disable type_body_length
enum ColorName {
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ededf3"></span>
  /// Alpha: 100% <br/> (0xededf3ff)
  case backgroundGray
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#38474f"></span>
  /// Alpha: 29% <br/> (0x38474f4c)
  case disableTitleOption
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#435259"></span>
  /// Alpha: 29% <br/> (0x4352594c)
  case disableValueOption
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d8d8d8"></span>
  /// Alpha: 100% <br/> (0xd8d8d8ff)
  case grey
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#38474f"></span>
  /// Alpha: 100% <br/> (0x38474fff)
  case greyBlue
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#435259"></span>
  /// Alpha: 50% <br/> (0x43525980)
  case lightGrayBlue
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f6846a"></span>
  /// Alpha: 100% <br/> (0xf6846aff)
  case orange
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d55f5f"></span>
  /// Alpha: 100% <br/> (0xd55f5fff)
  case red
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#67b1d6"></span>
  /// Alpha: 100% <br/> (0x67b1d6ff)
  case sky
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
	case skyWithAlpha

  case white
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f8f8f8"></span>
  /// Alpha: 100% <br/> (0xf8f8f8ff)
  case whiteGray

  var rgbaValue: UInt32 {
    switch self {
    case .backgroundGray: return 0xededf3ff
    case .disableTitleOption: return 0x38474f4c
    case .disableValueOption: return 0x4352594c
    case .grey: return 0xd8d8d8ff
    case .greyBlue: return 0x38474fff
    case .lightGrayBlue: return 0x43525980
    case .orange: return 0xf6846aff
    case .red: return 0xd55f5fff
    case .sky: return 0x67b1d6ff
		case .skyWithAlpha: return 0x67b1d680
    case .white: return 0xffffffff
    case .whiteGray: return 0xf8f8f8ff
    }
  }

  var color: Color {
    return Color(named: self)
  }
}
// swiftlint:enable type_body_length

extension Color {
  convenience init(named name: ColorName) {
    self.init(rgbaValue: name.rgbaValue)
  }
}
