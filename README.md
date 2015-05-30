# serhexr

Ruby wrapper around the serhex C Library

Useful for sending commands in raw hex over a serial port 

### Install

( once it's been pushed to a gem server )

    ```
    gem install serhexr
    ```

This will build the native extension, but no external libraries are required.
All native source code is self-contained within the gem.

### Using `serhexr`

Assume we have a [RadBeacon USB](http://store.radiusnetworks.com/products/radbeacon-usb-2) plugged in

    ```
    require 'serhexr'
    
    # Feed it the serial port
    serhex = Serhexr::Port.new('/dev/cu.usbmodem1')
    
    # send hex commands and receive hex response
    raw_byte_response = serhex.send_cmd("\x03")  
    #=> "\xFE\x10\x03\x00\a\x808H'"
    ```
    
However, it might be nice to the response in a more human readable form:

    ```
    hexdump_response = serhex.send_cmd("\x03", :response_format => :string)
    #=> "FE 10 03 00 07 80 38 48 27"
    ```
    
You can set the option at instantiation as well
    ```
    serhex = Serhexr::Port.new('/dev/cu.usbmodem1', :response_format => :string)
    hexdump_response = serhex.send_cmd("\x03")
    #=> "FE 10 03 00 07 80 38 48 27"
    ```
    
#### Serhexr Options

#### Response Format (`:response_format`)

Specify how the response should be formatted

##### `:response_format => :bytes` (Default)

Example: `r = s.send_cmd(data, :response_format => :bytes)`  
Response: `"\x01\x02\x03"`

The response will be in a byte string. This format may not be suitable for display.

##### `:response_format => :string`

Example: `r = s.send_cmd(data, :response_format => :string)`  
Response: `"01 02 03"`

The response will be the bytes in hex, separated by spaces. A good choice if the data should be human readable.

##### `:response_format => :array`

Example: `r = s.send_cmd(data, :response_format => :array)`  
Response: `["\x01", "\x02", "0x03]`

The response will be a byte array.

#### Response Length (`:length`)

Specifies how to set the length of the serial port response

###### `:length => :first_byte` (Default)

Example: `r = s.send_cmd(data, :length => :first_byte)`  
Response: `"\x01\x02\x03"`

After sending a command the first byte returned over the serial port is assumed to be the length of the response.
This length will be silently consumed to build the actual response. For example:

    ```
    Raw Serial Port Bytes: [0x03, 0x01, 0x02, 0x03]
                      length ^^           
    
    Serhexr response: "\x01\x02\x03"
    ```
    
###### `:length => <integer>`

Example: `r = s.send_cmd(data, :length => 5)`  
Response: `"\x01\x02\x03\x00\x00"`

Returns a response of fixed length specified by the integer, up to the maximum buffer size ( currently 64 bytes )

###### `:length => nil`

Example: `r = s.send_cmd(data, :length => nil)`  
Response: `"\x01\x02\x03\x00\x00 ... \x00"`  

Returns the full buffer ( currrently 64 bytes )
    
    

### Logging

Set the `RBLOG_LEVEL` environmental variable with the log level desired:

Log level names:

- `RBLOG_DEBUG`
- `RBLOG_INFO`
- `RBLOG_WARN`
- `RBLOG_ERROR`  (Default)

For example:

```
$ export RBLOG_LEVEL=RBLOG_DEBUG
```

Then run `serhex` normally.

