import Foundation
import SwiftUI

struct CustomTextFieldBorder: TextFieldStyle {
    var borderColor: UIColor
    init(borderColor: UIColor = UIColor.govUK.strokes.listDivider) {
        self.borderColor = borderColor
    }
    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color(uiColor: borderColor),
                        lineWidth: 0.5
                    )
            )
    }
}
