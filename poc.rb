require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'bunq-client'

# Generate keys on the fly. Make sure you save these keys in a secure location.
# Alternatively use keys already generated.
openssl_key = OpenSSL::PKey::RSA.new(2048)
public_key = openssl_key.public_key.to_pem
private_key = openssl_key.to_pem

Bunq.configure do |config|
  config.api_key = 'YOUR API KEY'
  config.private_key = private_key
  config.server_public_key = nil # you don't have this yet
  cofig.installation_token = nil # this MUST be nil for creating installations
end

# Create the installation
installation = Bunq.client.installations.create(public_key)

# Print the installation token to put in your Bunq::Configuration
installation_token = installation[1]['Token']['token']
puts "config.installation_token = #{installation_token}"

# Keep the public key to put in your Bunq::Configuration
server_public_key_location = "./server_public_key.pub"
File.open(server_public_key_location, 'w') { |file| file.write(installation[2]['ServerPublicKey']['server_public_key']) }
puts "config.server_public_key written to file #{server_public_key_location}"
