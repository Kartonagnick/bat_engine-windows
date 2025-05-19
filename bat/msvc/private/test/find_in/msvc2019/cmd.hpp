
// --- workspace/scripts/bat/msvc                             [find_in][cmd.hpp]
// reconstruct:
//   [2024-12m-24][09:09:00] 005 Kartonagnick PRE
//   [2024-04m-02][00:15:59] 004 Kartonagnick PRE
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick PRE
//   [2023-06m-01][01:54:31] 002 Kartonagnick PRE
//   [2022-08m-05][05:59:37] 001 Kartonagnick PRE

//==============================================================================
//==============================================================================

#pragma once

#include <string>
#include <list>

#define dOUT_TO_STREAM(classname)  \
    template<class ostream> friend \
    ostream& operator<<(ostream& out, const classname& obj)

using str_t = std::string;
using list_t = std::list<str_t>;

//==============================================================================
//=== [checkQuotes/viewArguments] ==============================================

namespace cmd
{
    // used in main();

    bool checkQuotes(const char* text) noexcept;
    void showArguments(const int argi, char* argv[]) noexcept;

    int  invalidSyntaxis();
    bool needShowHelpInfo(char* argv[]);
    bool checkArgument(int argc, char* argv[]);

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
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
            view(out, obj.debug   , "DEBUG");
            view(out, obj.once    , "ONCE" );
            view(out, obj.dir_once, "DIR ONCE" );

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
            view(out, obj.regexp, "USE REGULAR EXPRESSION");
            view(out, obj.match_mode, "USE MATCH MODE");
            view(out, obj.case_sensitive, "USE CASE SENSITIVE");
            view(out, obj.sorted, "NEED SORTED");
            return out;
        }

        options(int argc, char** argv);

        static void viewSyntaxis();
        static auto version() noexcept { return "0.0.4"; }
        static bool checkVersion(const char* arg) noexcept;
        static bool checkHelp(const char* arg)    noexcept;
    private:
        static bool checkCommand(const char* arg, const char* cmd) noexcept;
        void parseCommands(size_t argc, const char* const* const argv);
        void applyParams();
    public:
        bool debug           ;
        bool once            ;
        bool dir_once        ;
        bool dirnames        ;
        bool regexp          ;
        bool match_mode      ;
        bool case_sensitive  ;
        bool sorted          ;
        int  exe             ;
        list_t dirs_start    ;
        list_t dirs_mask     ;
        list_t scan_include  ;
        list_t scan_exclude  ;
        list_t dirs_include  ;
        list_t dirs_exclude  ;
        list_t files_include ;
        list_t files_exclude ;
    };

    void run(const options& opt);

} // namespace cmd

//==============================================================================
//==============================================================================
