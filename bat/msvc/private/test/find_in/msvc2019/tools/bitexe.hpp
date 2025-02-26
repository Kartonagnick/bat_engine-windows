
// --- workspace/scripts/bat/msvc                          [find_in][bitexe.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick PRE
//   [2023-06m-01][01:54:31] 002 Kartonagnick PRE
//   [2022-08m-05][05:59:37] 001 Kartonagnick PRE

//==============================================================================
//==============================================================================

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

//==============================================================================
//==============================================================================

#endif // dFSYSTEM_BITEXE_USED_

