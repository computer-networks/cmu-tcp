-- Copyright (C) 2022 Carnegie Mellon University
--
-- This file is part of the TCP in the Wild course project developed for the
-- Computer Networks course (15-441/641) taught at Carnegie Mellon University.
--
-- No part of the project may be copied and/or distributed without the express
-- permission of the 15-441/641 course staff.

tcp = Proto("cmutcp", "CMU TCP")

local f_identifier  = ProtoField.uint32("cmutcp.identifier", "Identifier")
local f_source_port  = ProtoField.uint16("cmutcp.source_port", "Source Port")
local f_destination_port  = ProtoField.uint16("cmutcp.destination_port", "Destination Port")
local f_seq_num  = ProtoField.uint32("cmutcp.seq_num", "Sequence Number")
local f_ack_num  = ProtoField.uint32("cmutcp.ack_num", "ACK Number")
local f_hlen  = ProtoField.uint16("cmutcp.hlen", "Header Length")
local f_plen  = ProtoField.uint16("cmutcp.plen", "Packet Length")
local f_flags  = ProtoField.uint8("cmutcp.flags", "Flags")
local f_advertised_window  = ProtoField.uint16("cmutcp.advertised_window", "Advertised Window")
local f_extension_length  = ProtoField.uint16("cmutcp.extension_length", "Extension Length")
local f_extension_data = ProtoField.string("cmutcp.extension_data", "Extension Data")

tcp.fields = { f_identifier, f_source_port, f_destination_port, f_seq_num, f_ack_num, f_hlen, f_plen, f_flags, f_advertised_window, f_extension_length , f_extension_data}

function tcp.dissector(tvb, pInfo, root) -- Tvb, Pinfo, TreeItem
   if (tvb:len() < 25 or tvb:len() ~= tvb:reported_len()) then
      return 0 -- ignore partially captured packets
      -- this can/may be re-enabled only for unfragmented UDP packets
   end

   if tvb(0,4):uint() ~= 15441 then return 0 end
   local hlen = tvb(16,2):uint()
   local plen = tvb(18,2):uint()
   local extension_length = tvb(23,2):uint()
   if hlen < 25 or hlen > plen or plen ~= tvb:len() or
      extension_length ~= hlen - 25 then return 0 end

   local t = root:add(tcp, tvb(0,hlen))
   t:add(f_identifier, tvb(0,4))
   t:add(f_source_port, tvb(4,2))
   t:add(f_destination_port, tvb(6,2))
   t:add(f_seq_num, tvb(8,4))
   t:add(f_ack_num, tvb(12,4))
   t:add(f_hlen, tvb(16,2))
   t:add(f_plen, tvb(18,2))
   local f = t:add(f_flags, tvb(20,1))
   t:add(f_advertised_window, tvb(21,2))
   t:add(f_extension_length, tvb(23,2))
   t:add(f_extension_data, tvb(25,extension_length))


   local flag = tvb(20,1):uint()

   if bit.band(flag, 8) ~= 0 then
      f:add(tvb(20,1), "SYN")
   end
   if bit.band(flag, 4) ~= 0 then
      f:add(tvb(20,1), "ACK")
   end
   if bit.band(flag, 2) ~= 0 then
      f:add(tvb(20,1), "FIN")
   end

   pInfo.cols.protocol = "CMU TCP"
end

-- have to put the port for the server here
local udpDissectorTable = DissectorTable.get("udp.port")
udpDissectorTable:add("15441", tcp)

io.stderr:write("tcp.lua is successfully loaded\n")
