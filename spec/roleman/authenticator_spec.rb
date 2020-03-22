RSpec.describe Roleman::Authenticator do
  let(:authenticator) { Roleman::Authenticator.new(config: config, router: router) }
  let(:config) { Roleman::Config.load(config_path, options) }
  let(:config_path) { load_fixture('valid_config_001.yml', type: :yaml) }
  let(:router) { Roleman::Router.new(config.routes) }
  let(:options) { {} }

  describe '#authorize' do
    subject { authenticator.authorize(user, path: path, request: request, method: method, extras: extras) }

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

  describe '#get_role' do
    subject { authenticator.send(:get_role, user) }

    context 'user is String' do
      let(:user) { 'read' }
      it 'return same argument' do
        is_expected.to eq user
      end
    end

    context 'user is Hash' do
      let(:user) { {
        'role' => 'read',
        'name' => 'fukata'
      } }
      it 'return same argument' do
        is_expected.to eq 'read'
      end
    end

    context 'user is Hash' do
      let(:user) { {
        'role' => 'read',
        'name' => 'fukata'
      } }
      it 'return same argument' do
        is_expected.to eq 'read'
      end
    end

    context 'user is class isntance' do
      let(:user) { User.new('read') }
      it 'return same argument' do
        is_expected.to eq 'read'
      end
    end
  end

  describe '#get_path' do
    subject { authenticator.send(:get_path, path: path, request: request) }

    context 'request is nil' do
      let(:path) { '/login' }
      let(:request) { nil }
      it 'return path' do
        is_expected.to eq path
      end
    end

    context 'request is class instance' do
      let(:path) { '/' }
      let(:request) { Request.new('/login') }
      it 'return request.path' do
        is_expected.to eq request.path
      end
    end

    context 'request is class instance but not have path property' do
      let(:path) { '/login' }
      let(:request) { RequestNoPath.new() }
      it 'raise error' do
        expect{ subject }.to raise_error ::ArgumentError
      end
    end

    context 'path and request is nil' do
      let(:path) { nil }
      let(:request) { nil }
      it 'raise error' do
        expect{ subject }.to raise_error ::ArgumentError
      end
    end
  end

  class User
    attr_accessor :role
    def initialize(role)
      @role = role
    end
  end

  class Request
    attr_accessor :path
    def initialize(path)
      @path = path
    end
  end

  class RequestNoPath
  end
end