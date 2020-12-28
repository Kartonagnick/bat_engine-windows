
#include "cmd.hpp"

#include <iostream>
#include <cstring>
#include <cassert>

#include "tools/find_in.hpp"
#include <tools/fsystem.hpp>
#include "tools/strncomp.hpp"
#include "tools/tokenizer.hpp"
#include "tools/pattern.hpp"
#include "tools/bitexe.hpp"
#include "tools/trim.hpp"
#include "tools/env.hpp"

#include <iostream>

//==============================================================================
//==============================================================================

namespace cmd
{
    bool checkQuotes(const char* text) noexcept
    {
        assert(text);
        size_t count = 0;
        for (const auto* i = text; *i != 0; ++i)
            if (*i == '"')
                ++count;

        if (count % 2 == 0)
            return true;
        return false;
    }

    void view_arguments(const int argi, char* argv[]) noexcept
    {
        assert(argi != 0);
        std::cout << "command arguments:\n";
        if (argi == 0)
        {
            std::cout << " -- none\n";
            return;
        }
        const size_t argc = static_cast<size_t>(argi);
        for (size_t i = 0; i != argc; ++i)
            std::cout << i << ") " << argv[i] << '\n';
    }

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
    inline list_t split(const char* src)
    {
        list_t result;
        const auto word = [&result](const char* text, const size_t len)
        {
            std::string tmp(text, len);
            ::tools::trim(tmp);
            if(!tmp.empty())
                result.emplace_back(std::move(tmp));
        };
        const auto punct = [](const char){};

        const auto& sep = ";";

        ::tools::tokenize(
            src, src + ::std::strlen(src),
            std::begin(sep), std::end(sep), 
            word, punct
        );

        return result;
    }

    inline void setCommandOptions(int argi, char** argv, options& dst)
    {
        assert(argi >= 1);
        if (argi <= 1)
            return;

        const size_t argc = static_cast<size_t>(argi);

        for(size_t i = 1; i != argc; ++i)
        {
            size_t x = 0;
            const char* arg = argv[i];

            if(!arg)
                goto next;

            while(arg[x] == ' ' || arg[x] == '-')
                if(arg[++x] == 0)
                    goto next;

            if (tools::strncmp_nocase(arg + x, "start:", 6) == 0)
                dst.dirs_start = cmd::split(arg + x + 6);

            if (tools::strncmp_nocase(arg + x, "mask:", 5) == 0)
                dst.dirs_mask = cmd::split(arg + x + 5);

            else if (tools::strncmp_nocase(arg + x, "s:", 2) == 0)
                dst.scan_include = cmd::split(arg + x + 2);

            else if (tools::strncmp_nocase(arg + x, "es:", 3) == 0)
                dst.scan_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "d:", 2) == 0)
                dst.dirs_include = cmd::split(arg + x + 2);

            else if(tools::strncmp_nocase(arg + x, "ed:", 3) == 0)
                dst.dirs_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "f:", 2) == 0)
                dst.files_include = cmd::split(arg + x + 2);

            else if(tools::strncmp_nocase(arg + x, "ef:", 3) == 0)
                dst.files_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "debug", 5) == 0)
                dst.debug = true;

            else if (tools::strncmp_nocase(arg + x, "once", 4) == 0)
                dst.once = true;

            else if (tools::strncmp_nocase(arg + x, "exe32", 5) == 0)
                dst.exe = 1;

            else if (tools::strncmp_nocase(arg + x, "exe64", 5) == 0)
                dst.exe = 2;

            else if (tools::strncmp_nocase(arg + x, "dirnames", 8) == 0)
                dst.dirnames = true;

        next:
            void();
        }
    }

    inline void commit(list_t& dirs)
    {
        if (dirs.empty())
        {
            dirs.emplace_back(
                fs::current_path().generic_string()
            );
            return;
        }

        for(auto& val: dirs)
        {
            val = tools::env::expand(val);
            fs::path p = val + "/";
            if(!p.is_absolute())
                p = fs::current_path()/p;
            val = fs::canonical(p).generic_string();
        }
    }

    void options::view_syntaxis()
    {
        const char* msg
            = R"raw(syntaxis:

find_in 
    "--start: dirs-where-search"    [required] 
    "--mask: masks-dir-or-files"    [optional]
    "--S: dirs-masks-include"       [optional]
    "--ES: dirs-masks-exclude"      [optional]
    "--D: dirs-masks-include"       [optional]
    "--ED: dirs-masks-exclude"      [optional]
    "--F: files-masks-include"      [optional]
    "--EF: files-masks-exclude"     [optional]
    "--once"                        [optional]
    "--dirnames"                    [optional]
    "--exe32"                       [optional]
    "--exe64"                       [optional]
    "--debug"                       [optional]
)raw";
        std::cout << msg << "\n";
    }

    options::options(int argc, char** argv)
        : debug        ()
        , once         ()
        , dirnames     ()
        , exe          ()
        , dirs_start   ()
        , scan_include ()
        , scan_exclude ()
        , dirs_include ()
        , dirs_exclude ()
        , files_include()
        , files_exclude()
    {
        cmd::setCommandOptions(argc, argv, *this);
        cmd::commit(this->dirs_start);
    }

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
    std::string commit(const options& opt, const std::string& path)
    {
        return opt.dirnames ?
            fs::path(path).parent_path().generic_string() :
            path;
    }

    void view_result(
        const options& opt, 
        const size_t depth, 
        const std::string& path)
    {
        std::cout
            << "[FILE] "
            << std::string(depth * 2, ' ')
            << commit(opt, path)
            << '\n';
    }

    void view_result(
        const options& opt, 
        const size_t depth,
        const std::string& path, 
        const std::string& dsc)
    {
        std::cout
            << "[FILE] "
            << std::string(depth * 2, ' ')
            << commit(opt, path)
            << ' ' << dsc 
            << '\n';
    }


    void run(const options& opt)
    {
        fsystem::settings params =
        {
            std::move(opt.scan_include ),
            std::move(opt.scan_exclude ),
            std::move(opt.dirs_include ),
            std::move(opt.dirs_exclude ),
            std::move(opt.files_include),
            std::move(opt.files_exclude)
        };

        if (!opt.dirs_mask.empty())
        {
            params.dirs_include.assign(
                opt.dirs_mask.cbegin(), 
                opt.dirs_mask.cend()
            );

            params.files_include.assign(
                opt.dirs_mask.cbegin(), 
                opt.dirs_mask.cend()
            );
        }

        bool found = false;

        const auto call = [&found, &opt](
            const bool is_directory, 
            const std::string& path, 
            const size_t depth)
        {
            if (opt.debug)
            {
                std::cout << "[" << depth << "]";

                if (is_directory)
                    std::cout << "[DIR]  " << std::string(depth * 2, ' ') << path << '\n';
                else
                {
                    if (opt.exe == 0)
                        view_result(opt, depth, path);
                    else if (opt.exe == 1)
                    {
                        const auto info = fsystem::check_bit_model(path);
                        if (info == fsystem::eBIT_32_ELF || info == fsystem::eBIT_32_WIN)
                            view_result(opt, depth, path);
                        else
                        {
                            view_result(opt, depth, path, "[SKIP-64]");
                            return true;
                        }
                    }
                    else if (opt.exe == 2)
                    {
                        const auto info = fsystem::check_bit_model(path);
                        if (info == fsystem::eBIT_64_ELF || info == fsystem::eBIT_64_WIN)
                            view_result(opt, depth, path);
                        else
                        {
                            view_result(opt, depth, path, "[SKIP-32]");
                            return true;
                        }
                    }
                }
                found = true;
                return opt.once ? false : true;
            }

            if (is_directory)
                std::cout << path << '\n';
            else
            {
                if (opt.exe == 0)
                    std::cout << commit(opt, path) << '\n';
                else if (opt.exe == 1)
                {
                    const auto info = fsystem::check_bit_model(path);
                    if (info == fsystem::eBIT_32_ELF || info == fsystem::eBIT_32_WIN)
                        std::cout << commit(opt, path) << '\n';
                    else
                        return true;
                }
                else if (opt.exe == 2)
                {
                    const auto info = fsystem::check_bit_model(path);
                    if (info == fsystem::eBIT_64_ELF || info == fsystem::eBIT_64_WIN)
                        std::cout << commit(opt, path) << '\n';
                    else
                        return true;
                }
            }
            found = true;
            return opt.once ? false : true;
        };

        for (const auto& dir : opt.dirs_start)
        {
            if (opt.debug)
                std::cout << "find in: " << dir << '\n';
            fsystem::find_in(dir, params, call);
            if (opt.once && found)
                return;
        }

        if (opt.debug && !found)
            std::cout << " -- not found\n";
    }

} // namespace cmd
