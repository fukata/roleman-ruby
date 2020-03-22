RSpec.describe Roleman::Config do
  describe '#load' do
    subject { Roleman::Config.load(config, options) }

    context 'Config is valid path' do
      let(:config) { File.join(fixture_path, 'valid_config_001.yml') }
      let(:options) { {} }
      it 'successful' do
        actual_config = subject
        expect(actual_config.routes.size).to eq 7
      end
    end

    context 'Config is valid hash' do
      let(:config) { load_fixture('valid_config_001.yml', type: :yaml) }
      let(:options) { {} }
      it 'successful' do
        actual_config = subject
        expect(actual_config.routes.size).to eq 7
      end
    end
  end
end