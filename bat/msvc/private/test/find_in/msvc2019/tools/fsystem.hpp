
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

#endif // !dFSYSTEM_USED_

