#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

require "test_helper"
require "minitest/autorun"

class ProtocolDroid::CSVLoaderTest < Minitest::Test

  def setup
    @config = {"apiCachePath" => "tmp/test.cache", "fileId" => "config-file-id"}

    client_secrets = stub(client_id: "config-client-id", client_secret: "config-client-secret")
    Google::APIClient::ClientSecrets.stubs(:load).returns(client_secrets)

    mock_app_flow = stub(:authorize)
    Google::APIClient::InstalledAppFlow.expects(:new).with do |actual_params|
      actual_params[:client_id] == "config-client-id" &&
        actual_params[:client_secret] == "config-client-secret"
    end.returns(mock_app_flow)

    Marshal.stubs(:dump)
  end

  def teardown
    File.delete(@config["apiCachePath"])
  end

  def test_load_creates_csv_from_google_spreadsheet_data
    mock_api_client = stub(discovered_api: stub(files: stub(get: :get)))
    mock_api_client.stub_everything
    mock_api_client.expects(:execute!).with do |actual_params|
      actual_params[:parameters] &&
        actual_params[:parameters]["fileId"] == "config-file-id"
    end.returns(stub(
      status: 200,
      data: stub(
        export_links: {
          "text/csv" => "url-to-csv-content"
        }
      )
    ))

    raw_csv_data = <<-CSV
Key,Comment,en
key-one,comment-one,en-one
CSV
    mock_api_client.expects(:execute!).with do |actual_params|
      actual_params[:http_method] == :get &&
        actual_params[:uri] == "url-to-csv-content"
    end.returns(stub(body: raw_csv_data))

    Google::APIClient.stubs(:new).returns(mock_api_client)

    csv = ProtocolDroid::CSVLoader.new(@config).load

    row_one = csv.entries.first
    assert_equal "key-one", row_one["Key"]
    assert_equal "comment-one", row_one["Comment"]
    assert_equal "en-one", row_one["en"]
  end
end
