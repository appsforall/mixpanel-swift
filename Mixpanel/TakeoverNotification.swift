//
//  TakeoverNotification.swift
//  Mixpanel
//
//  Created by Yarden Eitan on 1/24/17.
//  Copyright © 2017 Mixpanel. All rights reserved.
//

import Foundation

class TakeoverNotification: InAppNotification {

    let buttons: [InAppButton]
    let closeButtonColor: UInt
    var title: String? = nil
    let titleColor: UInt
    var shouldFadeImage: Bool = false

    override init?(JSONObject: [String: Any]?) {

        guard let object = JSONObject else {
            Logger.error(message: "notification json object should not be nil")
            return nil
        }

        guard let unparsedButtons = object["buttons"] as? [[String: Any]] else {
            Logger.error(message: "invalid notification buttons list")
            return nil
        }

        var parsedButtons = [InAppButton]()
        for unparsedButton in unparsedButtons {
            guard let button = InAppButton(JSONObject: unparsedButton) else {
                Logger.error(message: "invalid notification button")
                return nil
            }
            parsedButtons.append(button)
        }

        guard let closeButtonColor = object["close_color"] as? UInt else {
            Logger.error(message: "invalid notification close button color")
            return nil
        }

        if let title = object["title"] as? String {
            self.title = title
        }

        guard let titleColor = object["title_color"] as? UInt else {
            Logger.error(message: "invalid notification title color")
            return nil
        }

        self.buttons            = parsedButtons
        self.closeButtonColor   = closeButtonColor
        self.titleColor         = titleColor

        super.init(JSONObject: JSONObject)

        guard let shouldFadeImage = extras["image_fade"] as? Bool else {
            Logger.error(message: "invalid notification fade image boolean")
            return nil
        }
        self.shouldFadeImage    = shouldFadeImage
        imageURL = URL(string: imageURL.absoluteString.appendSuffixBeforeExtension(suffix: "@2x"))!

    }
}

extension String {
    func appendSuffixBeforeExtension(suffix: String) -> String {
        var newString = suffix
        do {
            let regex = try NSRegularExpression(pattern: "(\\.\\w+$)", options: [])
            newString = regex.stringByReplacingMatches(in: self,
                                                       options: [],
                                                       range: NSRange(location: 0,
                                                                      length: self.characters.count),
                                                       withTemplate: "\(suffix)$1")
        } catch {
            Logger.error(message: "cannot add suffix to URL string")
        }
        return newString
    }
}
