local function FindAllFilesInFolder(folder)
    local files = {}
    local results = love.filesystem.getDirectoryItems(folder)
    if results == nil then
        return
    end
    
    for _, item in ipairs(results) do
        local info = love.filesystem.getInfo(folder.."/"..item)
        if info.type == "directory" then
            local subfolderFiles = FindAllFilesInFolder(folder.."/"..item)
            table.append(files, subfolderFiles)
        elseif info.type == "file" then
            local convertedFolder = folder:gsub("/", ".")
            table.insert(files, convertedFolder.."."..item:sub(1, -5))
        end
    end
    return files
end

function RequireScripts(scriptsFolder)
    local files = FindAllFilesInFolder(scriptsFolder) or {}
    for i_, file in ipairs(files) do
        print("requiring " .. file)
        require(file)
    end
end


function table.append(table1, table2)
    for _, value in ipairs(table2) do
        table.insert(table1, value)
    end
end