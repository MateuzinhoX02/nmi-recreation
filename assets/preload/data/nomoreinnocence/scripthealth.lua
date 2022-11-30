function onStepHit()
    if curStep == 1693 then
        setProperty('health', 2)
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if curStep >= 1693 then
        setProperty('health', getProperty('health') - 0.023)
    end
end