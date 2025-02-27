
// --- workspace/scripts/bat/msvc                         [find_in][find_in.cpp]
//   [2024-12m-24][09:09:00] 005 Kartonagnick    
//   [2024-04m-25][11:04:22] 004 Kartonagnick    
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick    
//   [2023-06m-01][01:54:31] 002 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#include <tools/find_in.hpp>
#include <tools/pattern.hpp>
#include <tools/fsystem.hpp>
#include <tools/to_upper.hpp>

#include <regex>
#include <stack>
#include <set>

//==============================================================================
//==============================================================================

namespace fsystem {}
namespace FS = fsystem;

namespace fsystem
{
    static inline bool matchedMyMaskSensitive(const str_t& name, const list_t& masks) noexcept
    {
        for (const auto& mask : masks)
            if (tools::match_pattern(name, mask))
                return true;
        return false;
    }


    static inline bool matchedMyMaskInsensitive(const str_t& name, const list_t& masks) noexcept
    {
        for (const auto& mask : masks)
            if (tools::match_pattern_insensitive(name, mask))
                return true;
        return false;
    }


    static inline bool matchedMyRegexp(const str_t& name, const list_t& masks, const bool case_sensitive) noexcept
    {
        const auto mode = case_sensitive ?
            std::regex::basic :
            std::regex::icase ;

        for (const auto& mask : masks)
        {
            try
            {
                const std::regex rx(mask, mode);
                if (std::regex_match(name, rx))
                    return true;
            }
            catch (const std::exception& e)
            {
                const char* reason = e.what();
                (void)reason;
                assert(false && "matchedMyRegexp(std::exception): unexpected");
            }
        }
        return false;
    }


    static inline bool matchedMyRegexpSensitive(const str_t& name, const list_t& masks) noexcept
    {
        return matchedMyRegexp(name, masks, true);
    }


    static inline bool matchedMyRegexpInsensitive(const str_t& name, const list_t& masks) noexcept
    {
        return matchedMyRegexp(name, masks, false);
    }


    struct entry
    {
        entry(const fs::path& d, const size_t i)
            : dir(d), depth(i) {}

        fs::path dir;
        size_t depth;
    };


    static inline void checkRegexp(const bool case_sensitive, const list_t& collect)
    {
        const auto mode = case_sensitive ?
            std::regex::basic :
            std::regex::icase ;

        for (const auto& rx : collect)
        {
            try
            {
                std::regex(rx, mode);
            }
            catch (const std::exception& e)
            {
                const str_t reason = "invalid syntasix of regular expression: '" + rx + "'\n";
                throw std::logic_error(reason + e.what());
            }
        }
    }


    static inline void apply(settings& params)
    {
        if (params.regexp)
        {
            const auto mode = params.case_sensitive;
            FS::checkRegexp(mode, params.scan_include );
            FS::checkRegexp(mode, params.scan_exclude );
            FS::checkRegexp(mode, params.dirs_include );
            FS::checkRegexp(mode, params.dirs_exclude );
            FS::checkRegexp(mode, params.files_include);
            FS::checkRegexp(mode, params.files_exclude);
            return;
        }

        if (params.case_sensitive)
            return;

        tools::to_upper_collection(params.scan_include );
        tools::to_upper_collection(params.scan_exclude );
        tools::to_upper_collection(params.dirs_include );
        tools::to_upper_collection(params.dirs_exclude );
        tools::to_upper_collection(params.files_include);
        tools::to_upper_collection(params.files_exclude);
    }


    using flist_t = std::list<fs::path>;
    using func_t = bool(*)(const str_t&, const list_t&);

    static inline void findUnsorted(const str_t& start, const settings& params, func_t matched)
    {
        const call_t& call = params.call;
        using stack_t = std::stack<entry>;
        using set_t = std::set<fs::path>;
        set_t already;

        stack_t mystack;
        mystack.emplace(start, 0);

        while (!mystack.empty())
        {
            flist_t dirs, dirs_check;
            entry cur = std::move(mystack.top());
            mystack.pop();

            for (const fs::path& path : fs::directory_iterator(cur.dir))
            {
                if(already.find(path) != already.cend())
                    continue;
                already.emplace(path);

                const auto name = path.filename().generic_string();
                if (fs::is_directory(path))
                {
                    bool was_matched = false;
                    if (!params.dirs_include.empty() && matched(name, params.dirs_include))
                        if (params.dirs_exclude.empty() || !matched(name, params.dirs_exclude))
                        {
                            dirs_check.emplace_back(path);
                            was_matched = true;
                        }

                    if (!was_matched)
                    {
                        if (!params.scan_include.empty() && !matched(name, params.scan_include))
                            continue;
                        if (!params.scan_exclude.empty() && matched(name, params.scan_exclude))
                            continue;

                        dirs.emplace_back(path);
                    }
                }
                else
                {
                    if (params.files_include.empty() || !matched(name, params.files_include))
                        continue;
                    if (!params.files_exclude.empty() && matched(name, params.files_exclude))
                        continue;
                    if (!call(false, path.generic_string(), cur.depth))
                        return;
                }
            }

            bool skip = false;
            for (const auto& d : dirs_check)
            {
                const auto re = call(true, d.generic_string(), cur.depth);
                if (re == eFIND_RESPONCE::eFIND_DONE)
                    return;
                if (re == eFIND_RESPONCE::eFIND_SKIP_DIR)
                    skip = true;
            }

            if(!skip)
                for (const auto& d : dirs)
                    mystack.emplace(d, cur.depth + 1);
        }
    }


    enum eRESULT { eCONTINUE, eDONE, eSKIP, eSKIP_DIR };
    static inline eRESULT checkDirectory(const fs::path& d_path, const settings& params, func_t matched, const size_t depth)
    {
        const call_t& call = params.call;
        assert(call);
        assert(fs::is_directory(d_path));
        const auto name = d_path.filename().generic_string();

        if (!params.dirs_include.empty() && matched(name, params.dirs_include))
            if (params.dirs_exclude.empty() || !matched(name, params.dirs_exclude))
            {
                const auto re = call(true, d_path.generic_string(), depth);
                if(re == eFIND_RESPONCE::eFIND_SKIP_DIR)
                    return eRESULT::eSKIP_DIR;
                if(re == eFIND_RESPONCE::eFIND_DONE)
                    return eRESULT::eDONE;
            }

        if (!params.scan_include.empty() && !matched(name, params.scan_include))
            return eRESULT::eSKIP;
        if (!params.scan_exclude.empty() && matched(name, params.scan_exclude))
            return eRESULT::eSKIP;

        return eRESULT::eCONTINUE;
    }


    static inline void findSorted(const str_t& start, const settings& params, func_t matched)
    {
        const call_t& call = params.call;

        constexpr const size_t max_depth = 255;
        using iter_t = fs::directory_iterator;
        using stack_t = std::stack<iter_t>;

        flist_t files;
        size_t depth = 0;
        stack_t mystack;
        mystack.emplace(start);

        using set_t = std::set<fs::path>;
        set_t already;

        while (!mystack.empty() && depth < max_depth)
        {
            auto& it = mystack.top();
            if (it == iter_t())
            {
                mystack.pop();
                --depth;
                continue;
            }

            for (; it != iter_t(); ++it)
            {
                const fs::path& cur = *it;

                if(already.find(cur) != already.cend())
                    continue;
                already.emplace(cur);

                const auto name = cur.filename().generic_string();

                if (fs::is_directory(cur))
                {
                    const auto result = checkDirectory(cur, params, matched, depth);
                    if (result == eRESULT::eSKIP_DIR)
                        break;
                    if (result == eRESULT::eDONE)
                        return;
                    if (result == eRESULT::eSKIP)
                        continue;
                    mystack.emplace(cur);
                    ++it;
                    ++depth;
                    break;
                }
                else
                {
                    if (params.files_include.empty() || !matched(name, params.files_include))
                        continue;
                    if (!params.files_exclude.empty() && matched(name, params.files_exclude))
                        continue;
                    files.emplace_back(cur);
                }
            }

            for(const auto& f: files)
            {
                const auto re = call(false, f.generic_string(), depth);
                if(re == eFIND_RESPONCE::eFIND_DONE)
                    return;
                if(re == eFIND_RESPONCE::eFIND_SKIP_DIR)
                    break;
            }
        }
    }


    static void inline checkStartDirectory(const str_t& start)
    {
        if (!fs::exists(start))
            throw std::logic_error("find_in(start directory not exist): '" + start + "'");

        if(!fs::is_directory(start))
            throw std::logic_error("find_in(start path must be directory): '" + start + "'");
    }


    void find_in(const str_t& start, settings params)
    {
        fsystem::checkStartDirectory(start);
        fsystem::apply(params);

        const func_t matched = params.case_sensitive ?
            (params.regexp ? FS::matchedMyRegexpSensitive   : FS::matchedMyMaskSensitive) :
            (params.regexp ? FS::matchedMyRegexpInsensitive : FS::matchedMyMaskInsensitive)
        ;

        return params.sorted ?
            findSorted(start, params, matched): 
            findUnsorted(start, params, matched);
    }


    static inline bool checkThisDirectory(const fs::path& d_path, const settings& params, func_t matched, const size_t depth)
    {
        const call_t& call = params.call;
        assert(call);
        assert(fs::is_directory(d_path));
        const auto name = d_path.filename().generic_string();
        if (!params.dirs_include.empty() && matched(name, params.dirs_include))
            if (params.dirs_exclude.empty() || !matched(name, params.dirs_exclude))
                if (!call(true, d_path.generic_string(), depth))
                    return true;
        return false;
    }


    static inline bool checkDirectoryStart(const fs::path& d_path, const settings& params, func_t matched, const size_t depth)
    {
        for(const auto& d: d_path)
            if(checkThisDirectory(d, params, matched, depth))
                return true;
        return false;
    }


    bool dir_match(const str_t& start, settings params)
    {
        fsystem::checkStartDirectory(start);
        fsystem::apply(params);

        const func_t matched = params.case_sensitive ?
            (params.regexp ? FS::matchedMyRegexpSensitive   : FS::matchedMyMaskSensitive) :
            (params.regexp ? FS::matchedMyRegexpInsensitive : FS::matchedMyMaskInsensitive)
        ;
        return checkDirectoryStart(start, params, matched, 0);
    }

} // namespace fsystem

//==============================================================================
//==============================================================================


