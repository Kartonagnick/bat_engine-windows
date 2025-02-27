
// --- workspace/scripts/bat/msvc                   [find_in][tools/fsystem.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 004 Kartonagnick    
//   [2023-06m-01][01:54:31] 003 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#pragma once
#ifndef dFSYSTEM_USED_
#define dFSYSTEM_USED_ 1

#include <string>

#define _SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING
#include <experimental/filesystem>
namespace fs = ::std::experimental::filesystem;

//==============================================================================
//==============================================================================

namespace fsystem
{
    bool is_directory(const ::std::string& path) noexcept;

    void remove_directory(const ::std::string& dir);
    void remove_file(const ::std::string& path);
    void remove_all(const ::std::string& path);

} // namespace fsystem

//==============================================================================
//==============================================================================

#endif // dFSYSTEM_USED_

