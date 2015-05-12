require 'ffi'

SERHEX_LIB_PATH = File.join(File.dirname(__FILE__), '../ext/serhex')
SERHEX_SO_PATH = File.join(SERHEX_LIB_PATH, 'lib/libserhex.so')

unless File.exist?(SERHEX_SO_PATH)
  `make -C #{SERHEX_LIB_PATH}`
  unless File.exist?(SERHEX_SO_PATH)
    raise IOError, "Unable to find or make #{SERHEX_SO_PATH}"
  end
end

module Serhexr
  extend FFI::Library

  enum :rblog_levels, [
      :undef, 0,
      :error,
      :warn,
      :info,
      :debug
  ]

  ffi_lib 'c'
  ffi_lib SERHEX_SO_PATH
  attach_function :configure_port, [:int, :int], :int
  attach_function :open_port, [:string], :int
  attach_function :send_cmd, [:string, :pointer, :int, :pointer], :int
  attach_function :send_cmd_with_delay, [:string, :pointer, :int, :pointer, :int], :int
  attach_function :set_rblog_level, [ :rblog_levels ], :void
end
