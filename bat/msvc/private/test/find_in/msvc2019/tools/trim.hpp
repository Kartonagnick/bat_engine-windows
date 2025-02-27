
// --- workspace/scripts/bat/msvc                            [find_in][trim.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick    
//   [2023-06m-01][01:54:31] 002 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#pragma once

#include <string>

//==============================================================================
//==============================================================================

namespace tools
{
    // trim from end of string (right)
    inline std::string& rtrim(std::string& s, const char* t = " \t\n\r\f\v")
    {
        s.erase(s.find_last_not_of(t) + 1);
        return s;
    }

    // trim from beginning of string (left)
    inline std::string& ltrim(std::string& s, const char* t = " \t\n\r\f\v")
    {
        s.erase(0, s.find_first_not_of(t));
        return s;
    }

    // trim from both ends of string (left and right)
    inline std::string& trim(std::string& s, const char* t = " \t\n\r\f\v")
        { return ltrim(rtrim(s, t), t); }

} // namespace tools

//==============================================================================
//==============================================================================
