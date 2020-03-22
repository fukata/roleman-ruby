RSpec.describe Roleman::Router do
  describe "#find_route" do
    subject { router.find_route(path, method) }

    let(:options) { {} }
    let(:config) { Roleman::Config.load(load_fixture('valid_config_001.yml', type: :yaml), options) }
    let(:router) { Roleman::Router.new(config.routes) }

    context 'Exist route /login' do
      let(:path) { '/login' }
      let(:method) { 'GET' }
      it 'return route object' do
        route = subject
        expect(route).not_to be_nil
        expect(route.is_a? Roleman::Route).to be_truthy
        expect(route.path).to eq path
        expect(route.method).to eq method
      end
    end

    context 'Exist route /items/:id/edit' do
      let(:path) { '/items/1/edit' }
      let(:method) { 'GET' }
      it 'return route object' do
        route = subject
        expect(route).not_to be_nil
        expect(route.is_a? Roleman::Route).to be_truthy
        expect(route.path).to eq '/items/:id/edit'
        expect(route.method).to eq method
      end
    end

    context 'Exist route /items/:id' do
      let(:path) { '/items/1' }
      let(:method) { 'GET' }
      it 'return route object' do
        route = subject
        expect(route).not_to be_nil
        expect(route.is_a? Roleman::Route).to be_truthy
        expect(route.path).to eq '/items/:id'
        expect(route.method).to eq method
      end
    end

    context 'Not exist route' do
      let(:path) { '/secret/path' }
      let(:method) { 'GET' }
      it 'return nil' do
        route = subject
        expect(route).to be_nil
      end
    end
  end
end