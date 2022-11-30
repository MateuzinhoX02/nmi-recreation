shake = '0.02, 0.01'

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if getProperty('dad.curCharacter') == 'majim-starved' then
        triggerEvent('Screen Shake', shake, '0, 0');
        health = getProperty('health')
        if getProperty('health') > 0.1 then
           setProperty('health', health- 0.018);
        end
    end
end

function onStepHit()
    if curStep == 1693 then   
    removeLuaSprite('preto', true);
    removeLuaSprite('chaum', true);
    removeLuaSprite('chaum2', true);
    end   
end