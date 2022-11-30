function onCountdownTick(counter)
    if counter == 0 then
        setProperty('countdownReady.visible', false);
		doTweenX('circlemove', 'Circle', 0, 1, 'linear')
        doTweenX('textmove', 'Text', 0, 1, 'linear')
    end
	if counter == 1 then
        setProperty('countdownReady.visible', false);
    end
    if counter == 2 then
        setProperty('countdownSet.visible', false);
    end
    if counter == 3 then
        setProperty('countdownGo.visible', false);
    end
end

function onTweenCompleted(tag)

    if tag == 'circlemove' then
        runTimer('wait', 0.5, 1)
    end
end

function onTimerCompleted(tag)

	if tag == 'wait' then
        doTweenAlpha('circlealpha', 'Circle', 0, 1, 'linear')
        doTweenAlpha('textalpha', 'Text', 0, 1, 'linear')
        doTweenAlpha('bgalpha', 'TitleBG', 0, 1, 'linear')
    end
end