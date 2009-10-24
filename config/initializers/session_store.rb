# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_follow-info_session',
  :secret      => 'a3d0d5afa9ef02ed60251d9c9fb0b015d963dc77612bf7f1a4a8304b4e2a17e9cd902dbef037083ccfc45314caacdda3cbca36368a4edca9309bf742362b17f0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
