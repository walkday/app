import Archivable

extension Cloud where Output == Archive {
    public func update(preferences: Preferences) async {
        guard model.preferences != preferences else { return }
        model.preferences = preferences
        await stream()
    }
}
