require File.expand_path('../../fixtures/classes', __FILE__)

describe "UNIXSocket#peeraddr" do

  platform_is_not :windows do
    before :each do
      @path = SocketSpecs.socket_path
      rm_r @path

      @server = UNIXServer.open(@path)
      @client = UNIXSocket.open(@path)
    end

    after :each do
      @client.close
      @server.close
      rm_r @path
    end

    it "returns the address familly and path of the server end of the connection" do
      @client.peeraddr.should == ["AF_UNIX", @path]
    end

    it "raises an error in server sockets" do
      lambda { @server.peeraddr }.should raise_error
    end
  end

end
