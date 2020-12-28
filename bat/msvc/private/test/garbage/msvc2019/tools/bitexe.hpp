
#pragma once
#ifndef dFSYSTEM_BITEXE_USED_
#define dFSYSTEM_BITEXE_USED_ 1

#include <string>

namespace fsystem
{
	enum eBIT_MODEL
	{
		eBIT_NONE  ,
		eBIT_32_ELF,
		eBIT_64_ELF,
		eBIT_32_WIN,
		eBIT_64_WIN
	};

	eBIT_MODEL check_bit_model(const ::std::string& exe_file);

} // namespace fsystem

#endif // !dFSYSTEM_BITEXE_USED_

