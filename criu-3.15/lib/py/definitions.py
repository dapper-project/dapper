"""
Copyright (c) 2021. Abhishek Bapat. SSRG, Virginia Tech.
abapat28@vt.edu
"""

from pycriu import stack_map_utils
from pycriu import elf_utils
from . import regops
from . import properties

X86_64 = 0
AARCH64 = 1

SM_REGISTER = 0x1
SM_DIRECT = 0x2
SM_INDIRECT = 0x3
SM_CONSTANT = 0x4
SM_CONST_IDX = 0x5

Set = 0
Add = 1
Sub = 2
Mult = 3
Divide = 4
LShift = 5
RShiftLog = 6
RShiftArith = 7
Mask = 8
Load32 = 9
Load64 = 10

UINT64_MAX = 0b1111111111111111111111111111111111111111111111111111111111111111

class StHandle:
    def __init__(self, arch_type, elffile):
        self.type = arch_type
        if self.type == X86_64:
            self.regops = regops.x86
            self.properties = properties.x86
        elif self.type == AARCH64:
            self.regops = regops.aarch
            self.properties = properties.aarch
        else:
            raise Exception("Architecture not supported")

        section = elf_utils.get_elf_section(
            elffile, stack_map_utils.UNWIND_ADDR_SECTION)
        self.unw_addr_entries = elf_utils.get_num_entries(section)
        if self.unw_addr_entries > 0:
            self.unwind_addrs = stack_map_utils.parse_unwind_addrs(section)

        section = elf_utils.get_elf_section(
            elffile, stack_map_utils.UNWIND_SECTION)
        self.unw_loc_entries = elf_utils.get_num_entries(section)
        if self.unw_loc_entries > 0:
            self.unwind_locs = stack_map_utils.parse_unwind_locs(section)

        section = elf_utils.get_elf_section(
            elffile, stack_map_utils.ID_SECTION)
        self.cs_id_entries = elf_utils.get_num_entries(section)
        if self.cs_id_entries > 0:
            self.call_sites_id = stack_map_utils.parse_call_sites_by_id(
                section)

        section = elf_utils.get_elf_section(
            elffile, stack_map_utils.ADDR_SECTION)
        self.cs_addr_entries = elf_utils.get_num_entries(section)
        if self.cs_addr_entries > 0:
            self.call_sites_addr = stack_map_utils.parse_call_sites_by_addr(
                section)

        section = elf_utils.get_elf_section(
            elffile, stack_map_utils.LIVE_VALUE_SECTION)
        self.live_val_entries = elf_utils.get_num_entries(section)
        if self.live_val_entries > 0:
            self.live_vals = stack_map_utils.parse_live_values(section, self.live_val_entries)

        section = elf_utils.get_elf_section(
            elffile, stack_map_utils.ARCH_LIVE_SECTION)
        self.arch_live_entries = elf_utils.get_num_entries(section)
        if self.arch_live_entries > 0:
            self.arch_live_vals = stack_map_utils.parse_arch_live_values(
                section, self.arch_live_entries)
    
    def get_call_site_from_addr(self, address):
        #TODO implement binary search
        cs = [c for c in self.call_sites_addr if c.addr == address]
        if cs:
            return cs[0]
        else:
            return None

    def get_call_site_from_id(self, id):
        #TODO implement binary search
        cs = [c for c in self.call_sites_id if c.id == id]
        if cs:
            return cs[0]
        else:
            return None


class Activation:
    def __init__(self, cs, cfo, regset, libc = False):
        self.call_site = cs
        self.cfo = cfo # canonical frame offset
        self.regset = regset
        self.isLibc = libc

class Fixup:
    def __init__(self, src_addr, src_sp, act, dest_live_val):
        self.src_addr = src_addr
        self.src_sp = src_sp
        self.act = act
        self.dest_live_val = dest_live_val

class RewriteContext:
    def __init__(self,st_handle, regset, stack_top_offset = 0, stack_base_offset = 0, pages = None):
        self.st_handle = st_handle
        self.stack_base_offset = stack_base_offset
        self.stack_top_offset = stack_top_offset
        self.stack_size = 0
        self.regset = regset
        self.act = 0
        self.activations = []
        self.stack_pointers = []
        self.pages = pages
