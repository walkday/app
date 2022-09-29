import Archivable

extension Cloud where Output == Archive {
    public func update(preferences: Preferences) async {
        await model {
            guard $0.preferences != preferences else { throw Fail.dontSave }
            $0.preferences = preferences
        }
    }
}
