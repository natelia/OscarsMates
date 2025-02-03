Rails.application.config.session_store :cookie_store, {
  key: '_oscarsmates_session',
  expire_after: 30.days
}
