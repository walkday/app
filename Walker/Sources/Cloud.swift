import Archivable

extension Cloud where Output == Archive {
    public func update(challenge series: Series, value: Double) async {
        var model = await model
        let challenge = Challenge(series, value: .init(value))
        guard model.settings.challenge != challenge else { return }
        model.settings.challenge = challenge
        await update(model: model)
    }
    
    public func update(settings: Settings) async {
        var model = await model
        guard model.settings != settings else { return }
        model.settings = settings
        await update(model: model)
    }
}
