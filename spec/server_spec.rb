require 'spec_helper'

describe Communist::Server do

  let(:app) { proc { |env| [200, {}, "Hello Server!"] } }

  context 'initialization' do
    it 'sets application' do
      server = Communist::Server.new(app)
      server.app.should == app
    end

    it "sets port" do
      server = Communist::Server.new(app).start
      server.port.should == Communist::Server.ports[app.object_id]
    end
  end

  it "spins up a server" do
    server = Communist::Server.new(app).start
    res = Net::HTTP.start(server.host, server.port) { |http| http.get('/') }
    res.body.should include("Hello Server!")
  end

  it "binds to specified host" do
    Communist.server_host = "0.0.0.0"
    server = Communist::Server.new(app).start
    server.host.should == "0.0.0.0"
    Communist.server_host = nil
  end

end # Communist::Server
