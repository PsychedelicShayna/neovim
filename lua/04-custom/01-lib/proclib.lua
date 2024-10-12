local M = {}

-- Define the PgrepOpts class with fields corresponding to pgrep's options.
---@class PgrepOpts
---@field delimiter string? Delimiter for output, corresponds to -d, --delimiter
---@field list_name boolean? List PID and process name, corresponds to -l, --list-name
---@field list_full boolean? List PID and full command line, corresponds to -a, --list-full
---@field inverse boolean? Negates the matching, corresponds to -v, --inverse
---@field lightweight boolean? List all TID, corresponds to -w, --lightweight
---@field count boolean? Count of matching processes, corresponds to -c, --count
---@field full boolean? Use full process name to match, corresponds to -f, --full
---@field pgroup string? Match listed process group IDs, corresponds to -g, --pgroup
---@field group string? Match real group IDs, corresponds to -G, --group
---@field icase boolean? Match case insensitively, corresponds to -i, --ignore-case
---@field newest boolean? Select most recently started, corresponds to -n, --newest
---@field oldest boolean? Select least recently started, corresponds to -o, --oldest
---@field older number? Select processes older than specified seconds, corresponds to -O, --older
---@field parent string? Match child processes of the given parent, corresponds to -P, --parent
---@field session string? Match session IDs, corresponds to -s, --session
---@field signal string? Signal to send, corresponds to --signal
---@field terminal string? Match by controlling terminal, corresponds to -t, --terminal
---@field euid string? Match by effective IDs, corresponds to -u, --euid
---@field uid string? Match by real IDs, corresponds to -U, --uid
---@field exact boolean? Match exactly with the command name, corresponds to -x, --exact
---@field pidfile string? Read PIDs from file, corresponds to -F, --pidfile
---@field logpidfile boolean? Fail if PID file is not locked, corresponds to -L, --logpidfile
---@field runstates string? Match runstates [D,S,Z,...], corresponds to -r, --runstates
---@field ignore_ancestors boolean? Exclude ancestors from results, corresponds to -A, --ignore-ancestors
---@field cgroup string? Match by cgroup v2 names, corresponds to --cgroup
---@field ns string? Match processes in same namespace, corresponds to --ns
---@field nslist string? List namespaces to consider, corresponds to --nslist

-- The actual implementation of the pgrep wrapper function.
---@param name string Name or pattern of the process to match.
---@param opts PgrepOpts? Table of options corresponding to pgrep arguments.
---@return (table|number[]|number)? Resulting PIDs or process information.
function M.pgrep(name, opts)
    opts = opts or {}
    local cmd = { "pgrep" }

    -- Handle command-line options
    if opts.delimiter then
        table.insert(cmd, "-d")
        table.insert(cmd, opts.delimiter)
    end
    if opts.list_name then table.insert(cmd, "-l") end
    if opts.list_full then table.insert(cmd, "-a") end
    if opts.inverse then table.insert(cmd, "-v") end
    if opts.lightweight then table.insert(cmd, "-w") end
    if opts.count then table.insert(cmd, "-c") end
    if opts.full then table.insert(cmd, "-f") end
    if opts.pgroup then
        table.insert(cmd, "-g")
        table.insert(cmd, opts.pgroup)
    end
    if opts.group then
        table.insert(cmd, "-G")
        table.insert(cmd, opts.group)
    end
    if opts.icase == nil or opts.icase == true then table.insert(cmd, "-i") end
    if opts.newest then table.insert(cmd, "-n") end
    if opts.oldest then table.insert(cmd, "-o") end
    if opts.older then
        table.insert(cmd, "-O")
        table.insert(cmd, tostring(opts.older))
    end
    if opts.parent then
        table.insert(cmd, "-P")
        table.insert(cmd, opts.parent)
    end
    if opts.session then
        table.insert(cmd, "-s")
        table.insert(cmd, opts.session)
    end
    if opts.signal then
        table.insert(cmd, "--signal")
        table.insert(cmd, opts.signal)
    end
    if opts.terminal then
        table.insert(cmd, "-t")
        table.insert(cmd, opts.terminal)
    end
    if opts.euid then
        table.insert(cmd, "-u")
        table.insert(cmd, opts.euid)
    end
    if opts.uid then
        table.insert(cmd, "-U")
        table.insert(cmd, opts.uid)
    end
    if opts.exact then table.insert(cmd, "-x") end
    if opts.pidfile then
        table.insert(cmd, "-F")
        table.insert(cmd, opts.pidfile)
    end
    if opts.logpidfile then table.insert(cmd, "-L") end
    if opts.runstates then
        table.insert(cmd, "-r")
        table.insert(cmd, opts.runstates)
    end
    if opts.ignore_ancestors then table.insert(cmd, "-A") end
    if opts.cgroup then
        table.insert(cmd, "--cgroup")
        table.insert(cmd, opts.cgroup)
    end
    if opts.ns then
        table.insert(cmd, "--ns")
        table.insert(cmd, opts.ns)
    end
    if opts.nslist then
        table.insert(cmd, "--nslist")
        table.insert(cmd, opts.nslist)
    end

    -- Add the process name/pattern
    table.insert(cmd, name)

    -- Run the command and capture the output
    local handle = io.popen(table.concat(cmd, " "))

    if not handle then
        PrintDbg("Could not open pipe for command: " .. table.concat(cmd), LL_ERROR)
        return nil
    end

    local result = handle:read("*a")
    handle:close()

    -- Trim trailing newline
    result = result:gsub("\n$", "")

    -- If --count is used, return the count as a number
    if opts.count then
        return tonumber(result)
    end

    -- Parse the result based on the options
    if result == "" then
        return nil -- No match found
    elseif opts.list_name or opts.list_full then
        local output = {}
        for line in result:gmatch("[^\r\n]+") do
            local pid, info = line:match("(%d+)%s+(.+)")

            pid = tonumber(pid)

            if pid then
                output[pid] = {
                    name = opts.list_name and info or nil,
                    full_command = opts.list_full and info or nil
                }
            end
        end
        return output
    else
        local pids = {}

        for pid in result:gmatch("%d+") do
            table.insert(pids, tonumber(pid))
        end

        if #pids == 1 then
            return pids[1]
        end

        return pids
    end
end

return M
