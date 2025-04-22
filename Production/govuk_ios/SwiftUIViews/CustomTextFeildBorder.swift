import Foundation
import SwiftUI

struct CustomTextFieldBorder: TextFieldStyle {
    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color(uiColor: UIColor.govUK.strokes.listDivider),
                        lineWidth: 0.5
                    )
            )
    }
}
