
#pragma once

#include <string>
#include <list>

#define dOUT_TO_STREAM(classname)  \
    template<class ostream> friend \
    ostream& operator<<(ostream& out, const classname& obj)

//==============================================================================
//==============================================================================

namespace cmd
{
    bool checkQuotes(const char* text) noexcept;
    void view_arguments(const int argi, char* argv[]) noexcept;

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
    using list_t = std::list<std::string>;

    template<class ostream> 
    void view(ostream& out, const list_t& lst, const char* descript) noexcept
    {
        out << descript <<":\n";
        if(lst.empty())
            out << "  (empty)\n";
        else
            for (const auto& val : lst)
                out << "  " << val << "\n";
    }

    template<class ostream>
    void view(ostream& out, const bool val, const char* descript) noexcept
    {
        out << descript;
        (val) ? out << ": ON\n" : out << ": OFF\n";
    }

    struct options
    {
        dOUT_TO_STREAM(options)
        {
            view(out, obj.debug , "DEBUG");
            view(out, obj.once  , "ONCE" );

            if(obj.exe == 1)
                view(out, true, "EXE32");
            else if (obj.exe == 2)
                view(out, true, "EXE64");

            view(out, obj.dirnames, "INTERESTED IN DIRECTORY NAMES");

            view(out, obj.dirs_start   , "WHERE"        );
            view(out, obj.dirs_mask    , "TARGET ITEMS" );
            view(out, obj.scan_include , "SCAN INCLUDE" );
            view(out, obj.scan_exclude , "SCAN EXCLUDE" );
            view(out, obj.dirs_include , "DIRS INCLUDE" );
            view(out, obj.dirs_exclude , "DIRS EXCLUDE" );
            view(out, obj.files_include, "FILES INCLUDE");
            view(out, obj.files_exclude, "FILES EXCLUDE");
            return out;
        }

        options(int argc, char** argv);

        static void view_syntaxis();

        static auto version() noexcept { return "1.0.0"; }

        bool debug           ;
        bool once            ;
        bool dirnames        ;
        int  exe             ;
        list_t dirs_start    ;
        list_t dirs_mask     ;
        list_t scan_include  ;
        list_t scan_exclude  ;
        list_t dirs_where    ;
        list_t dirs_include  ;
        list_t dirs_exclude  ;
        list_t files_include ;
        list_t files_exclude ;
    };

    void run(const options& opt);

} // namespace cmd

//==============================================================================
//==============================================================================
