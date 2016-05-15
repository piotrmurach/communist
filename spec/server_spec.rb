# encoding: utf-8

RSpec.describe Communist::Server do

  let(:app) { proc { |env| [200, {'Content-Length' => '13'}, "Hello Server!"] } }

  it "sets rackup app" do
    server = Communist::Server.new(app)
    expect(server.app).to eq(app)
  end

  it "defaults host to localhost" do
    server = Communist::Server.new(app)
    expect(server.host).to eq('127.0.0.1')
  end

  it "defaults port" do
    server = Communist::Server.new(app)
    expect(server.port).to_not be_nil
  end

  it "adds port to ports after server start" do
    server = Communist::Server.new(app)
    server.start
    expect(Communist::Server.ports).to include({app.object_id => server.port})
    server.stop
  end

  it "is unresponsive if not started" do
    server = Communist::Server.new(app)
    expect(server.responsive?).to eq(false)
  end

  it "is responsive when started" do
    server = Communist::Server.new(app)
    server.start
    expect(server.responsive?).to eq(true)
    server.stop
  end

  it "spins up a server to catch request with canned response" do
    server = Communist::Server.run do
      get '/' do
        'Yow Piotr!'
      end
    end
    uri = URI("http://#{server.host}:#{server.port}")
    response = Net::HTTP.get_response(uri)
    expect(response.body).to eq(JSON.generate(['Yow Piotr!']))
    server.stop
  end

  it "binds to specified host" do
    server = Communist::Server.new(app)
    Communist.server_host = "0.0.0.0"
    expect(server.host).to eq("0.0.0.0")
    Communist.server_host = nil
  end
end
