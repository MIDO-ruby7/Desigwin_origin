//
//  Mydw+CoreDataProperties.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/27.
//
//

import Foundation
import CoreData


extension Mydw {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mydw> {
        return NSFetchRequest<Mydw>(entityName: "Mydw")
    }

    @NSManaged public var name: String?
    @NSManaged public var txt: String?
    @NSManaged public var img: Data?
    @NSManaged public var date: Date?
    @NSManaged public var isFav: Bool
    @NSManaged public var id: UUID?

}

extension Mydw {
    public var wrappedName: String {name ?? ""}
    public var wrappedTxt: String {txt ?? ""}
    public var wrappedImg: Data {img ?? Data.init(capacity: 0)}
    public var wrappedDate: Date {date ?? Date()}
    public var wrappedIsFav: Bool {isFav}
    public var wrappedId: UUID {id ?? UUID()}
}

extension Mydw : Identifiable {

}
