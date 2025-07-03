import Foundation
import UIKit

extension GOVUKColors {
    public struct Fills {
        public static let surfaceFixedContainer: UIColor = {
            .init(
                light: .white.withAlphaComponent(0.75),
                dark: .black.withAlphaComponent(0.75)
            )
        }()

        public static let surfaceBackground: UIColor = {
            .init(
                light: .white,
                dark: .black
            )
        }()

        public static let surfaceCardDefault: UIColor = {
            .init(
                light: .white,
                dark: .grey800
            )
        }()

        public static let surfaceCardBlue: UIColor = {
            .init(
                light: .blueLighter95,
                dark: .blueDarker50
            )
        }()

        public static let surfaceCardSelected: UIColor = {
            .init(
                light: .greenLighter95,
                dark: .greenDarker50
            )
        }()

        public static let surfaceButtonPrimary: UIColor = {
            .init(
                light: .primaryGreen,
                dark: .accentGreen
            )
        }()

        public static let surfaceButtonPrimaryHighlight: UIColor = {
            .init(
                light: .greenDarker25,
                dark: .greenLighter25
            )
        }()

        public static let surfaceButtonPrimaryFocussed: UIColor = {
            .primaryYellow
        }()

        public static let surfaceButtonPrimaryDisabled: UIColor = {
            .init(
                light: .grey100,
                dark: .grey400
            )
        }()

        public static let surfaceButtonSecondary: UIColor = {
            .clear
        }()

        public static let surfaceButtonSecondaryHighlight: UIColor = {
            .clear
        }()

        public static let surfaceButtonSecondaryFocussed: UIColor = {
            .primaryYellow
        }()

        public static let surfaceButtonCompact: UIColor = {
            .init(
                light: .blueLighter95,
                dark: .blueDarker80
            )
        }()

        public static let surfaceButtonCompactHighlight: UIColor = {
            .init(
                light: .blueLighter95,
                dark: .blueDarker80
            )
        }()

        public static let surfaceButtonCompactFocussed: UIColor = {
            .primaryYellow
        }()

        public static let surfaceButtonCompactDisabled: UIColor = {
            .init(
                light: .grey100,
                dark: .grey400
            )
        }()

        public static let surfaceButtonDestructive: UIColor = {
            .init(
                light: .primaryRed,
                dark: .accentRed
            )
        }()

        public static let surfaceButtonDestructiveHighlight: UIColor = {
            .init(
                light: .redDarker25,
                dark: .primaryRed
            )
        }()

        public static let surfaceModal: UIColor = {
            .init(
                light: .white,
                dark: .grey850
            )
        }()

        public static let surfaceSearchBox: UIColor = {
            .init(
                light: .grey550.withAlphaComponent(0.12),
                dark: .grey550.withAlphaComponent(0.24)
            )
        }()

        public static let surfaceHomeHeaderBackground: UIColor = {
            .init(
                light: .primaryBlue,
                dark: .blueDarker50
            )
        }()

        public static let surfaceToggleSelected: UIColor = {
            .init(
                light: .primaryGreen,
                dark: .primaryGreen
            )
        }()

        public static let surfaceList: UIColor = {
            .init(
                light: .blueLighter95,
                dark: .blueDarker80
            )
        }()

        public static let surfaceListHeading: UIColor = {
            .init(
                light: .blueLighter95,
                dark: .blueDarker50
            )
        }()

        public static let surfaceChatAnswer: UIColor = {
            .init(
                light: .white,
                dark: .blueDarker50
            )
        }()

        public static let surfaceChatQuestion: UIColor = {
            .init(
                light: .blueLighter80,
                dark: .grey850
            )
        }()
    }
}
