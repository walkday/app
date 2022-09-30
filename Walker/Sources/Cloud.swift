import Archivable

extension Cloud where Output == Archive {
    public func update(settings: Settings) async {
        await model {
            guard $0.settings != settings else { throw Fail.dontSave }
            $0.settings = settings
        }
    }
}
