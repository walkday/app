import Archivable

extension Cloud where Output == Archive {
    public func update(challenge series: Series, value: Double) async {
        var model = await model
        let challenge = Challenge(series, value: .init(value))
        guard model.settings.challenge != challenge else { return }
        model.settings.challenge = challenge
        await update(model: model)
    }
    
    public func update(iOS: Settings.IOS) async {
        var model = await model
        guard model.settings.iOS != iOS else { return }
        model.settings.iOS = iOS
        await update(model: model)
    }
    
    public func update(watchOS: Settings.WatchOS) async {
        var model = await model
        guard model.settings.watchOS != watchOS else { return }
        model.settings.watchOS = watchOS
        await update(model: model)
    }
}
