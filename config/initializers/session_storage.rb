# Keep the session with the browser so every Puma worker can validate the same
# CSRF token. Rails encrypts and signs the cookie with secret_key_base.
Rails.application.config.session_store :cookie_store, expire_after: 10.minutes
