#encoding: utf-8

require 'sinatra/base'
require 'active_support/core_ext'
require 'json'
require 'yaml'

CONFIG_PATH = './config/config.yaml'
CLOSET_FILE = '.closet'

module Closet
  class Application < Sinatra::Base
    configure do
      set :root, File.dirname(__FILE__)
    end

    get '/projects/:name' do |name|
      config = YAML.load(open(CONFIG_PATH)).symbolize_keys
      project = config[:projects][name]
      raise 'プロジェクトは定義されていません。config/config.yamlに設定を記入してください' if project.nil?

      project_dir = project["dir"]
      closet_file = project_dir+File::SEPARATOR+CLOSET_FILE
      raise 'プロジェクトディレクトリに.closetが存在しません' unless File.exists?(closet_file)

      system(File.read(closet_file))

      true.to_json
    end
  end
end
