//
//  CollegeifyWidgetLiveActivity.swift
//  CollegeifyWidget
//
//  Created by lakshay chauhan on 18/06/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CollegeifyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CollegeifyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CollegeifyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CollegeifyWidgetAttributes {
    fileprivate static var preview: CollegeifyWidgetAttributes {
        CollegeifyWidgetAttributes(name: "World")
    }
}

extension CollegeifyWidgetAttributes.ContentState {
    fileprivate static var smiley: CollegeifyWidgetAttributes.ContentState {
        CollegeifyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CollegeifyWidgetAttributes.ContentState {
         CollegeifyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CollegeifyWidgetAttributes.preview) {
   CollegeifyWidgetLiveActivity()
} contentStates: {
    CollegeifyWidgetAttributes.ContentState.smiley
    CollegeifyWidgetAttributes.ContentState.starEyes
}
