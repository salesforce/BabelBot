#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

require "google/api_client"
require "google/api_client/client_secrets"
require "google/api_client/auth/installed_app"
require "google/api_client/auth/file_storage"
require "csv"

module ProtocolDroid
  class CSVLoader

    API_VERSION = "v2"

    def initialize(config={})
      @config = config;
    end

    def load
      authorize_client
      load_csv
    end

    def authorize_client
      if cached_auth_exists?
        client.authorization = file_storage.authorization
      else
        client.authorization = app_flow.authorize(file_storage)
      end
    end

    def drive
      return @drive if @drive

      api_cache_file_path = @config["apiCachePath"]
      if File.exists?(api_cache_file_path)
        File.open(api_cache_file_path) do |file|
          @drive = Marshal.load(file)
        end
      else
        @drive = client.discovered_api("drive", API_VERSION)
        File.open(api_cache_file_path, "w") do |file|
          Marshal.dump(@drive, file)
        end
      end

      @drive
    end

    def load_csv
      file_metadata_result = client.execute!(
        api_method: drive.files.get,
        parameters: { "fileId" => @config["fileId"] }
      )

      raise "Error requesting CSV" unless file_metadata_result.status == 200

      csv_raw_data = client.execute!(
        http_method: :get,
        uri: file_metadata_result.data.export_links["text/csv"]
      )
      CSV.parse(csv_raw_data.body, {headers: true})
    end

    def client
      @client ||= Google::APIClient.new(
        application_name: @config["googleAppName"] || "String File Generator",
        application_version: ProtocolDroid::VERSION
      )
    end

    def cached_auth_exists?
      file_storage.authorization
    end

    def file_storage
      @file_storage ||= Google::APIClient::FileStorage.new(@config["credentialsCachePath"])
    end

    def app_flow
      @app_flow ||= Google::APIClient::InstalledAppFlow.new(
        client_id: client_secrets.client_id,
        client_secret: client_secrets.client_secret,
        scope: ["https://www.googleapis.com/auth/drive"]
      )
    end

    def client_secrets
      @client_secrets ||= Google::APIClient::ClientSecrets.load
    end
  end
end
