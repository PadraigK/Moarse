//
//  Xibless.swift
//  TableView
//
//  Created by Padraig O Cinneide on 2021-08-13.
//

import AppKit

class XiblessVC<View: XiblessView>: NSViewController {
  override func loadView() {
    view = View()
  }

  var contentView: View {
    view as! View
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class XiblessView : NSView {
  required init() {
    super.init(frame: .zero)
    setupView()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() { }
}

extension NSView {
  static func autolayoutable() -> Self {
    let view = Self(frame: .zero)
    return view.autolayoutable()
  }
  func autolayoutable() -> Self {
    self.translatesAutoresizingMaskIntoConstraints = false
    return self
  }
}
