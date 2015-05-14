require 'serhexr/ffi_extension'
require 'serhexr/hexdump'

module Serhexr
  class Port

    attr_accessor :port, :max_response_length

    def initialize(port, options={})
      @port = port
      # response_format: bytes, byte array or string (string representation of bytes)
      # length:  number, :remove_nulls, :first_byte
      #
      @default_command_options = {:response_format => :bytes, :length => :first_byte}
      @options = @default_command_options.merge(options)
      @default_log_level = :error

      # 64 is the maximum for serhex
      @max_response_length = 64
      log_level(@default_log_level)
    end

    def send_cmd(byte_string, options=@options)
      options = @default_command_options.merge(options)
      resp = send_raw_cmd(byte_string)

      resp = case options[:length]
      # digit
      when 1..@max_response_length
       len = options[:length]
        resp.chars.first(len).join()
      when :remove_nulls
        resp.strip
      when :first_byte
        size_by_first_byte(resp)
      else
        resp
      end

      case options[:response_format]
      when :bytes
        resp
      when :array
        resp.chars
      when :string
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
      resp = Array.new(@max_response_length, 0).pack("C*")
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
