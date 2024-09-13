import SwiftUI
import CoreData

struct RecentItemsView: View {
    let model: RecentItemsViewStructure
    let selected: (ActivityItem) -> Void
    @Environment(\.managedObjectContext) private var context

    init(model: RecentItemsViewStructure,
         selected: @escaping (ActivityItem) -> Void) {
        self.model = model
        self.selected = selected
    }
    var body: some View {
        ScrollView {
            if model.todaysItems.count >= 1 {
                let rows = model.todaysItems.map({ activityRow(activityItem: $0) })

                GroupedList(content: [GroupedListSection(
                    heading: "Today", rows: rows, footer: nil)])
            }
            if model.thisMonthsItems.count >= 1 {
                let rows = model.thisMonthsItems.map({ activityRow(activityItem: $0) })
                GroupedList(content: [GroupedListSection(heading: "This Month",
                                                         rows: rows,
                                                         footer: nil)])
            }
            if model.otherMonthItems.count >= 1 {
                GroupedList(content: buildSectionsView())
            }
        }
    }

    private func activityRow(activityItem: ActivityItem) -> LinkRow {
        LinkRow(
            id: activityItem.id,
            title: activityItem.title,
            body: activityItem.formattedDate,
            action: {
                self.selected(activityItem)
            }
        )
    }

    private func buildSectionsView() -> [GroupedListSection] {
        print(model.listOfOtherItemDateStrings)
        var groupedSections: [GroupedListSection] = []

        for dateString in model.listOfOtherItemDateStrings {
            let filteredArray = model.otherMonthItems.filter { item in
                DateHelper.getMonthAndYear(date: item.date) == dateString }
            let rows = filteredArray.map({ activityRow(activityItem: $0) })
            groupedSections.append(GroupedListSection(
                heading: dateString,
                rows: rows,
                footer: nil))
        }
        return groupedSections
    }
}
