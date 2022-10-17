import Archivable

extension Cloud where Output == Archive {
    public func update(challenge: Challenge) async {
        var model = await model
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
