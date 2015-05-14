require 'serhexr/ffi_extension'
require 'serhexr/hexdump'

module Serhexr
  class Port
    RESP_LEN = 80  #maximum response size
    # Log levels, :error, :warn, :info, :debug

    attr_accessor :port

    def initialize(port, options={})
      @port = port
      # response_format: bytes, byte array or hex dump (string representation of bytes)
      # truncate:  none, :null_bytes, :first_byte_length
      #
      @default_command_options = {:response_format => :bytes, :truncate => :first_byte_length}
      @options = @default_command_options.merge(options)
      @default_log_level = :error
      @response_length = 80
      log_level(@default_log_level)
    end

    def send_cmd(byte_string, options=@options)
      options = @default_command_options.merge(options)
      resp = send_raw_cmd(byte_string)


      resp = case options[:truncate]
      when :none
        resp
      when :nullbytes
        resp.strip
      when :first_byte_length
        size_by_first_byte(resp)
      end
      if options[:truncate] == :nullbytes
        resp = resp.strip
      end

      case options[:response_format]
      when :bytes
        resp
      when :array
        resp.chars
      when :hexdump
        hexdump(resp.chars)
      else #default to raw bytes
        resp
      end
    end

    def hexdump(bytes)
      Serhexr.hexdump(bytes)
    end

    def log_level(level)
      level = level.to_sym
      Serhexr.set_rblog_level(level)
    end

    private

    def send_raw_cmd(byte_string)
      resp = Array.new(@response_length, 0).pack("C*")
      Serhexr.send_cmd(@port, byte_string, byte_string.size, resp)
      resp
    end

    def size_by_first_byte(bytes)
      byte_array = bytes.chars
      len_byte = byte_array.shift
      len = len_byte.ord
      byte_array.first(len).join()
    end
  end
end