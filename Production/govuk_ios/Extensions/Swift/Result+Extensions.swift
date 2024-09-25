extension Result {
    func getError() -> Failure? {
        if case .failure(let failure) = self {
            return failure
        }
        return nil
    }
}
