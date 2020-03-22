RSpec.describe Roleman::Parser do
  describe "#parse" do
    subject { parser.parse }
    let(:parser) { Roleman::Parser.new(config, options) }

    context 'Valid config' do
      let(:config) { {
        'roleman' => {
          'version' => '1',
          'routes' => [
            { 'path' => '/', 'method' => 'GET' },
            { 'path' => '/login', 'method' => 'GET' },
            { 'path' => '/login', 'method' => 'POST' },
          ]
        }
      } }
      let(:options) { {} }
      it 'successful' do
        actual_config = subject

        expect(actual_config.version).to eq '1'
        expect(actual_config.role_field).to eq 'role'
        expect(actual_config.routes.size).to eq 3
      end
    end

    context 'Invalid config' do
      context 'not have roleman key' do
        let(:config) { {
          'roleman2' => {
            'version' => '1',
            'routes' => [
              { 'path' => '/', 'method' => 'GET' },
              { 'path' => '/login', 'method' => 'GET' },
              { 'path' => '/login', 'method' => 'POST' },
            ]
          }
        } }
        let(:options) { {} }
        it 'raise error' do
          expect{ subject }.to raise_error ::ArgumentError
        end
      end

      context 'roleman is not Hash' do
        let(:config) { {
          'roleman' => '',
        } }
        let(:options) { {} }
        it 'raise error' do
          expect{ subject }.to raise_error ::ArgumentError
        end
      end
    end
  end
end