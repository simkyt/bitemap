//
//  FilteredList.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-10.
//

import Foundation
import SwiftUI
import CoreData

struct Filter {
    let predicate: () -> NSPredicate
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    var onContentChange: ((Bool) -> Void)?
    
    var body: some View {
        if fetchRequest.isEmpty {
            EmptyView()
        } else {
            Text("YOUR FOOD")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
            ForEach(fetchRequest, id: \.self) { object in
                self.content(object)
            }
        }
    }
    
    init(filters: [Filter], sorts: [SortDescriptor<T>], @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        
        let predicates = filters.map { $0.predicate() }
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        _fetchRequest = FetchRequest<T>(sortDescriptors: sorts, predicate: combinedPredicate)
    }
}
