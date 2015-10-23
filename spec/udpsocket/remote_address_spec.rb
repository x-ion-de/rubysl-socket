require 'socket'
require File.expand_path('../../fixtures/classes', __FILE__)

describe 'UDPSocket#remote_address' do
  before :all do
    @host   = SocketSpecs.hostname
    @port   = SocketSpecs.port
    @server = UDPSocket.open

    @server.bind(@host, SocketSpecs.port)
  end

  after :all do
    @server.close
  end

  describe 'using an explicit hostname' do
    before do
      @sock = UDPSocket.new(Socket::AF_INET)

      @sock.connect(@host, @port)
    end

    after do
      @sock.close
    end

    it 'returns an Addrinfo' do
      @sock.remote_address.should be_an_instance_of(Addrinfo)
    end

    describe 'the returned Addrinfo' do
      it 'uses AF_INET as the address family' do
        @sock.remote_address.afamily.should == Socket::AF_INET
      end

      it 'uses PF_INET as the protocol family' do
        @sock.remote_address.pfamily.should == Socket::PF_INET
      end

      it 'uses SOCK_DGRAM as the socket type' do
        @sock.remote_address.socktype.should == Socket::SOCK_DGRAM
      end

      it 'uses the correct IP address' do
        @sock.remote_address.ip_address.should == @host
      end

      it 'uses the correct port' do
        @sock.remote_address.ip_port.should == @port
      end

      it 'uses 0 as the protocol' do
        @sock.remote_address.protocol.should == 0
      end
    end
  end

  describe 'using an implicit hostname' do
    before do
      @sock = UDPSocket.new(Socket::AF_INET)

      @sock.connect(nil, @port)
    end

    after do
      @sock.close
    end

    describe 'the returned Addrinfo' do
      it 'uses the correct IP address' do
        @sock.remote_address.ip_address.should == @host
      end
    end
  end
end