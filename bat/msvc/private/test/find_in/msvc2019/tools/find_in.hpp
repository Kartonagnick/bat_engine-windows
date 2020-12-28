
#pragma once
#ifndef dFSYSTEM_FIND_IN_USED_
#define dFSYSTEM_FIND_IN_USED_ 1

#include <functional>
#include <string>
#include <list>

//==============================================================================
//==============================================================================

namespace fsystem
{
    using str_t  = ::std::string;
    using list_t = ::std::list<str_t>;

    // --- const bool is_directory
    // --- const ::std::string& path
    // --- const size_t depth
    using call_t = ::std::function<
        bool(const bool, const ::std::string&, const size_t)
    >;

    struct settings
    {
        list_t scan_include  ;
        list_t scan_exclude  ;
        list_t dirs_include  ;
        list_t dirs_exclude  ;
        list_t files_include ;
        list_t files_exclude ;
    };

    void find_in(
        const str_t&    start, 
        const settings& params, 
        const call_t&   call
    );

} // namespace fsystem

//==============================================================================
//==============================================================================

#endif // !dFSYSTEM_FIND_IN_USED_

