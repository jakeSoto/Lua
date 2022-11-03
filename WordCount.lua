textfile = arg[1]
file = io.open(textfile, "r")
lines = file:lines()
print("Amount of memory used after opening file, but before loading into table... " .. collectgarbage("count"))
function split (inputstr, sep)
    if sep == nil then
            sep = "%s" -- %s is whitespace in lua
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do -- We do a little regex!
            table.insert(t, str)
    end
    return t
end
--[[
tab = split("Split me up boss", " ")
for i, v in pairs(tab) do
    print(i .. " " .. v)
end

--]]

function manageWords (wordTable, word)
    if wordTable[word] ~= nil then
        wordTable[word] = wordTable[word] + 1
    else wordTable[word] = 1
    end
end

function topX(wordTable, numWords)  -- take a table of word,#appearing pairs, and how many of the frequent words you want
    local topXWords = {} -- empty table for now
    for i=1, numWords,1 do -- until we've filled bottomXWords with NumWords words...
        local tempWordPair = {num=0, word=""} -- Using this table to track the current most frequent word and its count
        for word, count in pairs(wordTable) do
            if(topXWords[word]==nil and wordTable[word] > tempWordPair.num) then -- if we find a word with a higher count
                --and it isn't already in topXWords,
                tempWordPair.num = wordTable[word] --mark it as potentially the nex top word
                tempWordPair.word=word
            end
        end
        topXWords[tempWordPair.word]=tempWordPair.num -- record the new top word.
        print(tempWordPair.word .. " appeared " .. tempWordPair.num .. " times!")
    end
    return topXWords
end


function bottomX(wordTable, numWords)
    local bottomXWords = {} 
    for i=1, numWords,1 do 
        local tempWordPair = {num=99999999, word=""} 
        for word, count in pairs(wordTable) do
            if(bottomXWords[word]==nil and wordTable[word] < tempWordPair.num) then 
                tempWordPair.num = wordTable[word]
                tempWordPair.word=word
            end
        end
        bottomXWords[tempWordPair.word]=tempWordPair.num
        print(tempWordPair.word .. " appeared " .. tempWordPair.num .. " times!")
    end
    return bottomXWords
end
    

WordCount = {} -- empty table

print("Reading in file...");
for line in lines do
    words = split(line, " ") -- split by spaces
    for i, v in pairs(words) do -- iterate through key,val pair
        first,last = string.find(v,"%w*'?%w?") -- find the actual words, no spaces
        if first ~=nil and last~=nil then -- if string.find failed, just skip
            fixedWord = string.sub(v,first,last) -- get the trimmed word based on the indeces we found
            manageWords(WordCount,fixedWord) -- increment our WordCount for that word
    end
    end
end


--[[]
for key,value in pairs(wordCount) do
    print(key .. " appeared " .. value .. " times!")
end
--]]
print("Calling for function to see what the top X=10 most frequent words were in the text: ".. textfile );
topX(WordCount,10)
print("Calling for function to see what 5 most INFREQUENT words were in the text: ".. textfile );

bottomX(WordCount,5)
--print("Amount of memory with WordCount fully loaded... " .. collectgarbage("count") .. " kb")
WordCount = nil
print("Amount of memory with WordCount set to nil but garbage NOT YET collected... " .. collectgarbage("count") .. " kb")
collectgarbage("collect")
print("Amount of memory with WordCount set to nil and call to collect garbage immediately.... " .. collectgarbage("count") .. " kb")