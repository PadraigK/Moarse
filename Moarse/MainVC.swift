//
//  ViewController.swift
//  Moarse
//
//  Created by Padraig O Cinneide on 2021-10-31.
//

import Cocoa


enum KeyCode: UInt16 {
  case rightShift = 60
  case leftShift = 56
  case backspace = 51
  case space = 49
}

enum KeyState {
  case down
  case up
}

class MainVC: XiblessVC<MainView>, NSTextFieldDelegate {
  var message: [Morse.Character] = []
  var downTimestamp: TimeInterval?

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.window?.makeFirstResponder(contentView)

    contentView.morseView.placeholderString = "Hold shift to do a dash. Tap shift for a dot. Press space move to the next character. Backspace to delete."

    contentView.translationView.delegate = self
  }

  func controlTextDidChange(_ obj: Notification) {
    renderMorse()
  }

  override var acceptsFirstResponder: Bool { true }

  override func keyDown(with event: NSEvent) {
    guard contentView.window?.firstResponder == contentView else {
      super.keyDown(with: event)
      return
    }

    guard let key = KeyCode(rawValue: event.keyCode) else {
      super.keyDown(with: event)
      return
    }
    
    switch key {
    case .backspace:
      _ = message.popLast()
    case .space:
      message.append(.space)
    default:
      super.keyDown(with: event)
    }
    
    renderMessage()
  }

  override func flagsChanged(with event: NSEvent) {
    guard contentView.window?.firstResponder == contentView else {
      super.flagsChanged(with: event)
      return
    }

    guard KeyCode(rawValue: event.keyCode) == .rightShift else {
      super.flagsChanged(with: event)
      return
    }

    if let downTimestamp = downTimestamp {
      let duration = event.timestamp - downTimestamp
      if event.modifierFlags.contains(.shift) {
        emit(.down, duration: duration)
      } else {
        emit(.up, duration: duration)
      }
    }

    downTimestamp = event.timestamp
  }

  func emit(_ keyState: KeyState, duration: TimeInterval) {
    switch keyState {
    case .down:
      if duration > 0.8 {
        // We could infer a space between letters here, but
        // that annoyed Ida as she was trying to type.
        
        // message.append(.space)
      }
    case .up:
      if duration <= 0.4 {
        message.append(.dot)
      } else {
        message.append(.dash)
      }
    }

    renderMessage()
  }

  override func mouseDown(with event: NSEvent) {
    // This un-focuses the alphabet view when the user clicks outside it
    contentView.window?.makeFirstResponder(contentView)
    super.mouseDown(with: event)
  }

  override func cancelOperation(_ sender: Any?) {
    // This un-focuses the alphabet view when the user hits escape
    contentView.window?.makeFirstResponder(contentView)
  }

  func renderMessage() {
    contentView.morseView.attributedStringValue = NSAttributedString(with: message)

    let translated: String = {
      message
        .split(separator: .space)
        .map { group in
          if let character = Morse.alphabetMap[Array(group)] {
            return character
          }
          return "?"
        }.joined()
    }()

    contentView.translationView.stringValue = translated
  }

  func renderMorse() {
    let morseChars = contentView.translationView.stringValue
      .uppercased()
      .compactMap { character -> [Morse.Character]? in
        Morse.morseMap[String(character)]
      }
      .flatMap { $0 + [Morse.Character.space] }

    message = morseChars

    contentView.morseView.attributedStringValue = NSAttributedString(with: morseChars)
  }

  @objc func clearText() {
    message = []
    renderMessage()
  }

  @objc func copyMorse() {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([.string], owner: nil)
    pasteboard.setString(contentView.morseView.stringValue, forType: .string)
  }
}

extension NSAttributedString {
  convenience init(with morseCode: [Morse.Character]) {
    var morseCodeString = morseCode.map { $0.description }.joined()

    if morseCodeString.count > 0 {
      // add a crappy cursor. really we should make the text view work
      // properly but this is good enough.
      morseCodeString += "︳"
    }
    
    self.init(
      string: morseCodeString,
      attributes: [.kern: 1.4]
    )
  }
}

class MainView: XiblessView {
  let morseView = NSTextField.autolayoutable()
  let translationView = NSTextField.autolayoutable()
  let clearButton = NSButton(title: "Clear",
                             target: nil, action:
                              #selector(MainVC.clearText)).autolayoutable()
  
  let copyButton = NSButton(title: "Copy",
                             target: nil, action:
                              #selector(MainVC.copyMorse)).autolayoutable()
  
  override var acceptsFirstResponder: Bool { true }

  override func setupView() {
    let translationLabel = NSTextField(labelWithString: "Translation:").autolayoutable()
    let morseLabel = NSTextField(labelWithString: "Morse Code:").autolayoutable()

    subviews = [morseLabel,
                morseView,
                translationLabel,
                translationView,
                clearButton,
                copyButton]

    morseView.isEditable = false

    let morseCodeFont = NSFont.monospacedSystemFont(ofSize: 16, weight: .medium)
    morseView.font = morseCodeFont
    translationView.font = morseCodeFont

    morseView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    translationView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    NSLayoutConstraint.activate([
      widthAnchor.constraint(greaterThanOrEqualToConstant: 500),

      morseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      morseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),

      morseView.leadingAnchor.constraint(equalTo: morseLabel.leadingAnchor),
      morseView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      morseView.topAnchor.constraint(equalTo: morseLabel.bottomAnchor, constant: 4),
      morseView.heightAnchor.constraint(equalToConstant: 80),

      copyButton.topAnchor.constraint(equalTo: morseView.bottomAnchor, constant: 8),
      copyButton.trailingAnchor.constraint(equalTo: morseView.trailingAnchor),
      
      translationLabel.leadingAnchor.constraint(equalTo: morseLabel.leadingAnchor),
      translationLabel.topAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: 40),

      translationView.leadingAnchor.constraint(equalTo: morseView.leadingAnchor),
      translationView.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 4),
      translationView.trailingAnchor.constraint(equalTo: morseView.trailingAnchor),
      translationView.heightAnchor.constraint(equalTo: morseView.heightAnchor),

      clearButton.topAnchor.constraint(equalTo: translationView.bottomAnchor, constant: 8),
      clearButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
      clearButton.trailingAnchor.constraint(equalTo: translationView.trailingAnchor)
    ])
  }
}
