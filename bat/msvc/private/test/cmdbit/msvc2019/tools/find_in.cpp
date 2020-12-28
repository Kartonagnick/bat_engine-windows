
#include <tools/find_in.hpp>
#include <tools/pattern.hpp>
#include <tools/fsystem.hpp>

#include <stack>

//==============================================================================
//==============================================================================

namespace fsystem
{
    bool matched(const str_t& name, const list_t& masks) noexcept
    {
        for (const auto& mask : masks)
            if (tools::match_pattern(name, mask))
                return true;
        return false;
    }

    #if 0
    optimize version
        работает быстрее.
        памяти кушает меньше
        однако не гарантируется, что файлы будут обработаны прежде каталогов
        что является неприемлимым на практике

    void find_in(const str_t& start, const settings& params, const call_t& call)
    {
        constexpr const size_t max_depth = 255;
        using iter_t = fs::directory_iterator;
        using stack_t = ::std::stack<iter_t>;

        size_t depth = 0;
        stack_t mystack;
        mystack.emplace(start);

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
                const auto name = cur.filename().generic_string();

                if (fs::is_directory(cur))
                {
                    if (!params.dirs_include.empty() && matched(name, params.dirs_include))
                        if (params.dirs_exclude.empty() || !matched(name, params.dirs_exclude))
                            if (!call(true, cur.generic_string(), depth))
                                return;

                    if (!params.scan_include.empty() && !matched(name, params.scan_include))
                        continue;
                    if (!params.scan_exclude.empty() && matched(name, params.scan_exclude))
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
                    if (!call(false, cur.generic_string(), depth))
                        return;
                }
            }
        }
    }
    #endif

    void find_in(const str_t& start, const settings& params, const call_t& call)
    {
        struct entry
        {
            entry(const fs::path& d, const size_t i)
                : dir(d), depth(i) {}

            fs::path dir;
            size_t depth;
        };

        using stack_t = ::std::stack<entry>;
        using flist_t = ::std::list<fs::path>;

        stack_t mystack;
        mystack.emplace(start, 0);

        while (!mystack.empty())
        {
            flist_t dirs, dirs_check;
            entry cur = ::std::move(mystack.top());
            mystack.pop();

            for (const fs::path& path : fs::directory_iterator(cur.dir))
            {
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

            for (const auto& d : dirs_check)
                if (!call(true, d.generic_string(), cur.depth))
                    return;

            for (const auto& d : dirs)
                mystack.emplace(d, cur.depth + 1);
        }
    }

} // namespace fsystem

//==============================================================================
//==============================================================================


