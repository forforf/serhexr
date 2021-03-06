require 'rspec'
require 'spec_helper'
include Serhexr

describe Port do


  context 'send_cmd' do
    let(:raw_response){ [0x04,0x31,0x32,0x33,0x00,0x00,0x00].pack('C*') }
    let(:sized_response){ [0x31,0x32,0x33,0x00].pack('C*') }
    let(:fixed_size_response){ [0x04, 0x31,0x32,0x33,0x00].pack('C*')}
    let(:stripped_raw_response){ [0x31,0x32,0x33].pack('C*)') }
    let(:sized_hexdump_response){ "31 32 33 00"}
    let(:port){ Port.new("/dev/blackhole") }


    it 'by default returns length specified in first byte' do
      allow_any_instance_of(Port).to receive(:send_raw_cmd){ raw_response }
      expect( port.send_cmd("abc") ).to eq( sized_response )
    end

    it 'can return untruncated bytes' do
      allow_any_instance_of(Port).to receive(:send_raw_cmd){ raw_response }
      expect( port.send_cmd("abc", :length => nil) ).to eq( raw_response )
    end

    it 'can return fixed length bytes' do
      allow_any_instance_of(Port).to receive(:send_raw_cmd){ raw_response }
      expect( port.send_cmd("abc", :length => 5) ).to eq( fixed_size_response )
    end

    it 'can return byte array' do
      allow_any_instance_of(Port).to receive(:send_raw_cmd){ raw_response }
      expect( port.send_cmd("abc", :response_format => :array) ).to eq( sized_response.chars )
    end

    it 'can return a hex string (hexdump)' do
      allow_any_instance_of(Port).to receive(:send_raw_cmd){ raw_response }
      expect( port.send_cmd("abc", :response_format => :string) ).to eq( sized_hexdump_response )
    end
  end

  context 'set options at initialization' do
    let(:raw_response){ [0x31,0x32,0x33,0x00,0x00,0x00].pack('C*') }
    let(:fixed_hexdump_response){ "31 32 33 00 00"}
    let(:port){ Port.new("/dev/blackhole", :response_format => :string, :length => 5) }

    it 'honors them' do
      allow_any_instance_of(Port).to receive(:send_raw_cmd){ raw_response }
      expect( port.send_cmd("abc") ).to eq( fixed_hexdump_response )
    end
  end

  context 'log level' do
    let(:port){ Port.new("/dev/blackhole") }

    it 'sets them' do
      # default log level at initialization
      expect(Serhexr).to receive(:set_rblog_level).with(:error)

      # override default log level
      expect(Serhexr).to receive(:set_rblog_level).with(:debug)
      port.log_level(:debug)
    end
  end

end
