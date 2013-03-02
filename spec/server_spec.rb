require 'spec_helper'

describe Communist::Server do

  let(:app) { proc { |env| [200, {'Content-Length' => '13'}, "Hello Server!"] } }

  subject(:server) { described_class.new(app).start }

  after { server.stop }

  its(:app) { should == app }

  its(:host) { should == '127.0.0.1' }

  its(:port) { should == described_class.ports[app.object_id] }

  its(:responsive?) { should be_true }

  it "spins up a server" do
    res = Net::HTTP.start(server.host, server.port) { |http| http.get('/') }
    expect(Communist.servers).to_not be_empty
    expect(res.body).to eql "Hello Server!"
  end

  it "binds to specified host" do
    Communist.server_host = "0.0.0.0"
    expect(server.host).to eq "0.0.0.0"
    Communist.server_host = nil
  end

end # Communist::Server
