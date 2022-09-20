class UserConfig {
  String _userId;

  void setUserId(String userId) {
    if (_isUserIdChangeAllowed(userId)) {
      this._userId = userId;
    }
  }

  String getUserId() {
    return this._userId;
  }

  bool _isUserIdChangeAllowed(String userId) {
    return (_userId == null && userId != null)
        || (_userId != null && userId == null);
  }
}