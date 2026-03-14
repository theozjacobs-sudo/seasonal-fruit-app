import Foundation

final class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    private let defaults: UserDefaults?
    private let key = "favoriteProduceIDs"

    @Published private(set) var favoriteIDs: Set<String>

    private init() {
        defaults = UserDefaults(suiteName: SharedConstants.appGroupID)
        let stored = defaults?.stringArray(forKey: key) ?? []
        favoriteIDs = Set(stored)
    }

    func isFavorite(_ id: String) -> Bool {
        favoriteIDs.contains(id)
    }

    func toggle(_ id: String) {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
        save()
    }

    private func save() {
        defaults?.set(Array(favoriteIDs), forKey: key)
    }
}
