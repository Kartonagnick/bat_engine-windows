
// --- workspace/scripts/bat/msvc                         [find_in][find_in.hpp]
//   [2024-12m-24][09:09:00] 005 Kartonagnick PRE
//   [2024-04m-25][11:04:22] 004 Kartonagnick PRE
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick PRE
//   [2023-06m-01][01:54:31] 002 Kartonagnick PRE
//   [2022-08m-05][05:59:37] 001 Kartonagnick PRE

//==============================================================================
//==============================================================================

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
    // --- const std::string& path
    // --- const size_t depth

    enum eFIND_RESPONCE { eFIND_DONE, eFIND_SKIP_DIR, eFIND_CONTINUE };
    using call_t = ::std::function<
        eFIND_RESPONCE(const bool, const ::std::string&, const size_t)
    >;

    struct settings
    {
        list_t scan_include  ;
        list_t scan_exclude  ;
        list_t dirs_include  ;
        list_t dirs_exclude  ;
        list_t files_include ;
        list_t files_exclude ;
        bool case_sensitive  ;
        bool dir_once        ;
        bool regexp          ;
        bool sorted          ;
        call_t call          ;
    };

    void find_in(const str_t& start, settings params);
    bool dir_match(const str_t& start, settings params);

} // namespace fsystem

//==============================================================================
//==============================================================================

#endif // dFSYSTEM_FIND_IN_USED_

