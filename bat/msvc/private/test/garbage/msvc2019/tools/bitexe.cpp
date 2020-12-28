
#include <tools/bitexe.hpp>

#include <fstream>
#include <cstring>

char Elf32Magic[20] = "\x7f\x45\x4c\x46\01"; //7F 45 4C 46  01 // ELF32 
char Elf64Magic[20] = "\x7f\x45\x4c\x46\02"; //7F 45 4C 46  02 // ELF64
char Win32Magic[20] = "\x50\x45\x00\x00\x4C\x01"; // PE32
char Win64Magic[20] = "\x50\x45\x00\x00\x64\x86"; // PE64

namespace fsystem
{
	eBIT_MODEL check_bit_model(const ::std::string& file)
	{
		::std::fstream in(file, std::fstream::in);
		if (!in)
			throw ::std::runtime_error(
				"can not open: '" + file + "'"
			);

		char header[0x200];
		in.read(header, 0x200);

		if (::std::memcmp(header, Elf32Magic, 5) == 0)
			return eBIT_32_ELF;

		if (::std::memcmp(header, Elf64Magic, 5) == 0)
			return eBIT_64_ELF;

		char peheader[20] = {};
		size_t k = 0;
		for (size_t i = 0; i < 0x200; ++i)
			if (header[i] == 0x50 && header[i + 1] == 0x45) // PE     
				for (size_t j = i; j < i + 6; ++j, ++k)
					peheader[k] = header[j];

		if (::std::memcmp(&peheader, Win32Magic, 6) == 0)
			return eBIT_32_WIN;

		if (::std::memcmp(&peheader, Win64Magic, 6) == 0)
			return eBIT_64_WIN;

		return eBIT_NONE;
	}

} // namespace fsystem
