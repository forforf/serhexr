module Serhexr
  def self.hexdump(bytes)
    bytes.map{|b| sprintf("%02X", b.ord) }.join(" ")
  end
end