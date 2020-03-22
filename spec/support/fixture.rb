require 'yaml'
require 'json'

def fixture_path
  File.join(__dir__, '..', 'fixtures')
end

def load_fixture(path, type: :text)
  file_path = File.join(fixture_path, path)

  case type.to_sym
  when :text
    File.read(file_path)
  when :yaml
    YAML.load_file(file_path)
  when :json
    JSON.load(file_path)
  end
end