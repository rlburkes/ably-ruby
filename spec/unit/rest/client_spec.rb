# encoding: utf-8
require 'spec_helper'
require 'shared/client_initializer_behaviour'

describe Ably::Rest::Client do
  subject do
    Ably::Rest::Client.new(client_options)
  end

  it_behaves_like 'a client initializer'

  context 'initializer options' do
    context 'TLS' do
      context 'disabled' do
        let(:client_options) { { key: 'appid.keyuid:keysecret', tls: false } }

        it 'fails for any operation with basic auth and attempting to send an API key over a non-secure connection (#RSA1)' do
          expect { subject.channel('a').publish('event', 'message') }.to raise_error(Ably::Exceptions::InsecureRequest)
        end
      end
    end

    context ':use_token_auth' do
      context 'set to false' do
        context 'with a key and :tls => false' do
          let(:client_options) { { use_token_auth: false, key: 'appid.keyuid:keysecret', tls: false } }

          it 'fails for any operation with basic auth and attempting to send an API key over a non-secure connection' do
            expect { subject.channel('a').publish('event', 'message') }.to raise_error(Ably::Exceptions::InsecureRequest)
          end
        end

        context 'without a key' do
          let(:client_options) { { use_token_auth: false } }

          it 'fails as a key is required if not using token auth' do
            expect { subject.channel('a').publish('event', 'message') }.to raise_error(ArgumentError)
          end
        end
      end

      context 'set to true' do
        context 'without a key or token' do
          let(:client_options) { { use_token_auth: true, key: true } }

          it 'fails as a key is required to issue tokens' do
            expect { subject.channel('a').publish('event', 'message') }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end

  context 'request_id generation' do
    let(:client_options) { { key: 'appid.keyuid:keysecret', add_request_ids: true } }
    it 'includes request_id in URL' do
      expect(subject.add_request_ids).to eql(true)
    end
  end
end
