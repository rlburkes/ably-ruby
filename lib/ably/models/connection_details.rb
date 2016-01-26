module Ably::Models
  # Convert connection details attributes to a {ConnectionDetails} object
  #
  # @param attributes (see #initialize)
  #
  # @return [ConnectionDetails]
  def self.ConnectionDetails(attributes)
    case attributes
    when ConnectionDetails
      return attributes
    else
      ConnectionDetails.new(attributes || {})
    end
  end

  # ConnectionDetails are optionally passed to the client library in the +CONNECTED+ {Ably::Models::ProtocolMessage#connectionDetails} attribute
  # to inform the client about any constraints it should adhere to and provide additional metadata about the connection.
  # For example, if a request is made to publish a message that exceeds the +maxMessageSize+, the client library can reject
  # the message immediately, without communicating with the Ably service
  #
  class ConnectionDetails
    include Ably::Modules::ModelCommon

    # @param attributes [Hash]
    # @option attributes [String]    :client_id             contains the client ID assigned to the connection
    # @option attributes [String]    :connection_key        the connection secret key string that is used to resume a connection and its state
    # @option attributes [Integer]   :max_message_size      maximum individual message size in bytes
    # @option attributes [Integer]   :max_frame_size        maximum size for a single frame of data sent to Ably. This restriction applies to a {Ably::Models::ProtocolMessage} sent over a realtime connection, or the total body size for a REST request
    # @option attributes [Integer]   :max_inbound_rate      maximum allowable number of requests per second from a client
    # @option attributes [Integer]   :connection_state_ttl  duration in seconds that Ably will persist the connection state when a Realtime client is abruptly disconnected
    # @option attributes [String]    :server_id             unique identifier of the Ably server where the connection is established
    #
    def initialize(attributes = {})
      @hash_object = IdiomaticRubyWrapper(attributes.clone)
      hash[:connection_state_ttl] = (hash[:connection_state_ttl].to_f / 1000).round if hash[:connection_state_ttl]
      hash.freeze
    end

    %w(client_id connection_key max_message_size max_frame_size max_inbound_rate connection_state_ttl server_id).each do |attribute|
      define_method attribute do
        hash[attribute.to_sym]
      end
    end

    def has_client_id?
      hash.has_key?(:client_id)
    end

    # @!attribute [r] hash
    # @return [Hash] Access the token details Hash object ruby'fied to use symbolized keys
    def hash
      @hash_object
    end
  end
end
