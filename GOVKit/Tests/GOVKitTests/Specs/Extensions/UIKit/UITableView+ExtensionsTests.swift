import Foundation
import UIKit
import Testing

@testable import GOVKit

@Suite
@MainActor
struct UITableView_ExtensionsTests {
    @Test
    func register_dequeue_returnsCell() throws {
        let sut = TestTableView()
        sut.register(TestTableViewCell.self)

        var cell: TestTableViewCell?
        cell = sut.dequeue(
            indexPath: .init(row: 0, section: 0)
        )

        #expect(cell != nil)
    }

    @Test
    func selectAllRows_selectsRows() throws {
        let sut = TestTableView()
        sut._numberOfRows = 10
        sut._numberOfSections = 5

        sut.selectAllRows(animated: true)

        #expect(sut._selectedRows.count == 50)
    }

    @Test
    func deselectAllRows_selectsRows() throws {
        let sut = TestTableView()
        sut._numberOfRows = 11
        sut._numberOfSections = 5

        sut.deselectAllRows(animated: true)

        #expect(sut._deselectedRows.count == 55)
    }
}

private class TestTableView: UITableView {

    var _numberOfSections: Int = 0
    override var numberOfSections: Int {
        _numberOfSections
    }

    var _numberOfRows: Int = 0
    override func numberOfRows(inSection section: Int) -> Int {
        _numberOfRows
    }

    var _selectedRows: [IndexPath] = []
    override func selectRow(at indexPath: IndexPath?,
                            animated: Bool,
                            scrollPosition: UITableView.ScrollPosition) {
        if let indexPath = indexPath {
            _selectedRows.append(indexPath)
        }
        super.selectRow(
            at: indexPath,
            animated: animated,
            scrollPosition: scrollPosition
        )
    }

    var _deselectedRows: [IndexPath] = []
    override func deselectRow(at indexPath: IndexPath,
                              animated: Bool) {
        _deselectedRows.append(indexPath)
        super.deselectRow(
            at: indexPath,
            animated: animated
        )
    }
}

private class TestTableViewCell: UITableViewCell {}
