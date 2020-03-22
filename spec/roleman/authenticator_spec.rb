RSpec.describe Roleman::Authenticator do
  describe '#authorize' do
    subject { authenticator.authorize(user, path: path, request: request, method: method, extras: extras) }
    let(:authenticator) { Roleman::Authenticator.new(config: config, router: router) }
    let(:config) { Roleman::Config.load(config_path, options) }
    let(:config_path) { load_fixture('valid_config_001.yml', type: :yaml) }
    let(:router) { Roleman::Router.new(config.routes) }
    let(:options) { {} }

    context 'Exist route' do
      let(:path) { '/items/1/edit' }
      let(:method) { 'GET' }
      let(:user) { {role: 'read'}}
      let(:request) { nil }
      let(:extras) { {} }

      context 'has role' do
        let(:user) { {role: 'edit'}}
        it 'return true' do
          is_expected.to be_truthy
        end
      end

      context 'not has role' do
        let(:user) { {role: 'read'}}
        it 'return false' do
          is_expected.to be_falsey
        end
      end
    end

    context 'Not exist route' do
      let(:path) { '/secret/path' }
      let(:method) { 'GET' }
      let(:user) { nil }
      let(:request) { nil }
      let(:extras) { {} }

      context 'raise_unknown_path is nil' do
        it 'return true' do
          is_expected.to be_truthy
        end
      end

      context 'raise_unknown_path is set lambda' do
        it 'return true' do
          config.raise_unknown_path = lambda do |user, request|
            raise Roleman::Error.new('Failed Authentication')
          end

          expect{ subject }.to raise_error Roleman::Error
        end
      end

    end
  end
end